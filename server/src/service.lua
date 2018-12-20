local subprocess = require 'bee.subprocess'
local method     = require 'method'
local thread     = require 'thread'
local rpc        = require 'rpc'
local parser     = require 'parser'
local matcher    = require 'matcher'

local ErrorCodes = {
    -- Defined by JSON RPC
    ParseError           = -32700,
    InvalidRequest       = -32600,
    MethodNotFound       = -32601,
    InvalidParams        = -32602,
    InternalError        = -32603,
    serverErrorStart     = -32099,
    serverErrorEnd       = -32000,
    ServerNotInitialized = -32002,
    UnknownErrorCode     = -32001,

    -- Defined by the protocol.
    RequestCancelled     = -32800,
}

local mt = {}
mt.__index = mt

function mt:_callMethod(name, params)
    local optional
    if name:sub(1, 2) == '$/' then
        name = name:sub(3)
        optional = true
    end
    local f = method[name]
    if f then
        local clock = os.clock()
        local suc, res = xpcall(f, log.error, self, params)
        local passed = os.clock() - clock
        if passed > 0.1 then
            log.debug(('Task [%s] takes [%.3f]sec.'):format(name, passed))
        end
        if suc then
            return res
        else
            local suc, res = pcall(table.dump, params)
            local dump = suc and res or 'Cyclic table'
            log.debug(('Task [%s] failed, params: %s'):format(
                name, dump
            ))
            return nil, {
                code = ErrorCodes.InternalError,
                message = res,
            }
        end
    end
    if optional then
        return nil
    else
        return nil, {
            code = ErrorCodes.MethodNotFound,
            message = 'MethodNotFound',
        }
    end
end

function mt:_doProto(proto)
    local id     = proto.id
    local name   = proto.method
    local params = proto.params
    local response, err = self:_callMethod(name, params)
    if not id then
        return
    end
    local container = table.container()
    if err then
        container.error = err
    else
        container.result = response
    end
    rpc:response(id, container)
end

function mt:_doDiagnostic()
    if not next(self._needDiagnostics) then
        return
    end
    local clock = os.clock()
    local count = 0
    local copy = {}
    for uri, data in pairs(self._needDiagnostics) do
        count = count + 1
        copy[uri] = data
        self._needDiagnostics[uri] = nil
    end
    for uri, data in pairs(copy) do
        local name = 'textDocument/publishDiagnostics'
        local res  = self:_callMethod(name, data)
        if res then
            rpc:notify(name, {
                uri = uri,
                diagnostics = res,
            })
        end
    end
    local passed = os.clock() - clock
    if passed > 0.1 then
        log.debug(('\n\z
        Diagnostics completion\n\z
        Cost:  [%.3f]sec\n\z
        Num:   [%d]'):format(
            passed,
            count
        ))
    end
end

function mt:clearDiagnostics(uri)
    rpc:notify('textDocument/publishDiagnostics', {
        uri = uri,
        diagnostics = {},
    })
end

function mt:_buildTextCache()
    if not next(self._needCompile) then
        return
    end
    local list = {}
    for uri in pairs(self._needCompile) do
        list[#list+1] = uri
    end

    local size = 0
    local clock = os.clock()
    for _, uri in ipairs(list) do
        local obj = self:compileText(uri)
        size = size + #obj.text
    end
    local passed = os.clock() - clock
    if passed > 0.1 then
        log.debug(('\n\z
        Cache completion\n\z
        Cost:  [%.3f]sec\n\z
        Num:   [%d]\n\z
        Size:  [%.3f]kb'):format(
            passed,
            #list,
            size / 1000
        ))
    end
end

function mt:read(mode)
    if not self._input then
        return nil
    end
    return self._input(mode)
end

function mt:saveText(uri, version, text)
    local obj = self._file[uri]
    if obj then
        if obj.version >= version then
            return
        end
        obj.version = version
        obj.text = text
        self._needCompile[uri] = true
    else
        self._file[uri] = {
            version = version,
            text = text,
        }
        self._needCompile[uri] = true
    end
end

function mt:loadText(uri)
    local obj = self._file[uri]
    if not obj then
        return nil
    end
    self:compileText(uri)
    return obj.vm, obj.lines
end

function mt:compileText(uri)
    local obj = self._file[uri]
    if not obj then
        return nil
    end
    if not self._needCompile[uri] then
        return nil
    end
    self._needCompile[uri] = nil
    local ast = parser:ast(obj.text)

    obj.vm = matcher.vm(ast)
    obj.lines = parser:lines(obj.text, 'utf8')
    if not obj.vm then
        return obj
    end

    self._needDiagnostics[uri] = {
        vm    = obj.vm,
        lines = obj.lines,
        uri   = uri,
    }

    return obj
end

function mt:removeText(uri)
    self._file[uri] = nil
    self._needCompile[uri] = nil
end

function mt:on_tick()
    while true do
        local proto = thread.proto()
        if not proto then
            break
        end
        if proto.method then
            self:_doProto(proto)
        else
            rpc:recieve(proto)
        end
    end
    self:_buildTextCache()
    self:_doDiagnostic()

    if os.clock() - self._clock >= 600 then
        self._clock = os.clock()
        local count = 0
        for _ in pairs(self._file) do
            count = count + 1
        end
        local mem = collectgarbage 'count'
        log.debug(('\n\z
        State\n\z
        Mem:   [%.3f]kb\n\z
        Cache: [%d]'):format(
            mem,
            count
        ))
    end
end

function mt:listen()
    subprocess.filemode(io.stdin, 'b')
    subprocess.filemode(io.stdout, 'b')
    io.stdin:setvbuf 'no'
    io.stdout:setvbuf 'no'

    thread.require 'proto'

    while true do
        thread.on_tick()
        self:on_tick()
        thread.sleep(0.001)
    end
end

return function ()
    local session = setmetatable({
        _file = {},
        _needCompile = {},
        _needDiagnostics = {},
        _clock = -100,
    }, mt)
    return session
end
