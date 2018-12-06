local subprocess = require 'bee.subprocess'
local method     = require 'method'
local thread     = require 'thread'
local json       = require 'json'
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
        if passed > 0.01 then
            log.debug(('Task [%s] takes [%.3f]sec.'):format(name, passed))
        end
        if suc then
            return res
        else
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

function mt:_send(data)
    data.jsonrpc = '2.0'
    local content = json.encode(data)
    local buf = ('Content-Length: %d\r\n\r\n%s'):format(#content, content)
    io.write(buf)
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
    container.id    = id
    if err then
        container.error = err
    else
        container.result = response
    end
    self:_send(container)
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
            self:_send {
                method = name,
                params = {
                    uri = uri,
                    diagnostics = res,
                },
            }
            log.debug('publishDiagnostics', uri)
        end
    end
    local passed = os.clock() - clock
    log.debug(('\n\z
    Diagnostics completion\n\z
    Cost:  [%.3f]sec\n\z
    Num:   [%d]'):format(
        passed,
        count
    ))
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

    local sum = 0
    for _ in pairs(self._file) do
        sum = sum + 1
    end
    log.debug(('\n\z
    Cache completion\n\z
    Cost:  [%.3f]sec\n\z
    Num:   [%d]\n\z
    Size:  [%.3f]kb\n\z
    Speed：[%.3f]kb/s\n\z
    Mem：  [%.3f]kb\n\z
    Sum:   [%d]'):format(
        passed,
        #list,
        size / 1000,
        size / passed / 1000,
        collectgarbage 'count',
        sum
    ))
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
    return obj.results, obj.lines
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
    local ast   = parser:ast(obj.text)
    obj.results = matcher.compile(ast)
    if not obj.results then
        return obj
    end
    obj.lines       = parser:lines(obj.text)

    self._needDiagnostics[uri] = {
        ast     = ast,
        results = obj.results,
        lines   = obj.lines,
    }

    return obj
end

function mt:removeText(uri)
    self._file[uri] = nil
    self._needCompile[uri] = nil
end

function mt:on_tick()
    local proto = thread.proto()
    if proto then
        self._idleClock = os.clock()
        self:_doProto(proto)
        return
    end
    if os.clock() - self._idleClock >= 0.2 then
        self._idleClock = os.clock()
        self:_buildTextCache()
        self:_doDiagnostic()
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
        _idleClock = os.clock(),
    }, mt)
    return session
end
