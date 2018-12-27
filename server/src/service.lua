local subprocess = require 'bee.subprocess'
local method     = require 'method'
local thread     = require 'bee.thread'
local async      = require 'async'
local rpc        = require 'rpc'
local parser     = require 'parser'
local matcher    = require 'matcher'
local lang       = require 'language'

thread.newchannel 'proto'

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
        local suc, res = xpcall(f, debug.traceback, self, params)
        local passed = os.clock() - clock
        if passed > 0.1 then
            log.debug(('Task [%s] takes [%.3f]sec.'):format(name, passed))
        end
        if suc then
            return res
        else
            local ok, r = pcall(table.dump, params)
            local dump = ok and r or 'Cyclic table'
            log.debug(('Task [%s] failed, params: %s'):format(
                name, dump
            ))
            log.debug(res)
            return nil, {
                code = ErrorCodes.InternalError,
                message = r .. '\n' .. res,
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
    for uri in pairs(self._needDiagnostics) do
        self._needDiagnostics[uri] = nil
        count = count + 1
        copy[uri] = true
    end
    for uri in pairs(copy) do
        local obj = self._file[uri]
        if obj and obj.vm then
            local data = {
                uri   = uri,
                vm    = obj.vm,
                lines = obj.lines,
            }
            local name = 'textDocument/publishDiagnostics'
            local res  = self:_callMethod(name, data)
            if res then
                rpc:notify(name, {
                    uri = uri,
                    diagnostics = res,
                })
            end
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

function mt:compileAll()
    if not next(self._needCompile) then
        return
    end
    local list = {}
    for i, uri in ipairs(self._needCompile) do
        list[i] = uri
    end

    local size = 0
    local clock = os.clock()
    for _, uri in ipairs(list) do
        local obj = self:compileVM(uri)
        if obj then
            size = size + #obj.text
        end
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

function mt:needCompile(uri, compiled)
    if self._needCompile[uri] then
        return
    end
    if not compiled then
        compiled = {}
    end
    if compiled[uri] then
        return
    end
    self._needCompile[uri] = compiled
    table.insert(self._needCompile, 1, uri)
end

function mt:saveText(uri, version, text)
    local obj = self._file[uri]
    if obj then
        if obj.version >= version then
            return
        end
        obj.version = version
        obj.text = text
        self:needCompile(uri)
    else
        self._file[uri] = {
            version = version,
            text = text,
        }
        self:needCompile(uri)
    end
end

function mt:readText(uri, path)
    local obj = self._file[uri]
    if obj then
        return
    end
    local text = io.load(path)
    if not text then
        return
    end
    self._file[uri] = {
        version = -1,
        text = text,
    }
    self:needCompile(uri)
end

function mt:open(uri)
    self._opening[uri] = true
end

function mt:close(uri)
    self._opening[uri] = nil
end

function mt:isOpen(uri)
    return self._opening[uri] == true
end

function mt:reCompile()
    local compiled = {}
    for uri in pairs(self._opening) do
        self:needCompile(uri, compiled)
    end

    if self._needShowComplete then
        self._needShowComplete = nil
        rpc:notify('window/showMessage', {
            type = 3,
            message = lang.script.MWS_COMPLETE,
        })
    end
end

function mt:loadVM(uri)
    local obj = self._file[uri]
    if not obj then
        return nil
    end
    self:compileVM(uri)
    return obj.vm, obj.lines
end

function mt:_markCompiled(uri)
    local compiled = self._needCompile[uri]
    if compiled then
        compiled[uri] = true
        self._needCompile[uri] = nil
    end
    for i, u in ipairs(self._needCompile) do
        if u == uri then
            table.remove(self._needCompile, i)
            break
        end
    end
    return compiled
end

function mt:compileAst(obj)
    local ast, err = parser:ast(obj.text)
    if not ast then
        if type(err) == 'string' then
            local message = lang.script('PARSER_CRASH', err)
            log.debug(message)
            rpc:notify('window/showMessage', {
                type = 3,
                message = lang.script('PARSER_CRASH', err:match 'grammar%.lua%:%d+%:(.+)'),
            })
        else
            obj.astErr = err
        end
    end
    return ast
end

function mt:_clearChainNode(obj, uri)
    if obj.parent then
        for pUri in pairs(obj.parent) do
            local parent = self._file[pUri]
            if parent and parent.child then
                parent.child[uri] = nil
            end
        end
    end
end

function mt:_compileChain(obj, compiled)
    if not obj.child then
        return
    end
    if not compiled then
        compiled = {}
    end
    local list = {}
    for child in pairs(obj.child) do
        list[#list+1] = child
    end
    table.sort(list)
    for _, child in ipairs(list) do
        self:needCompile(child, compiled)
    end
end

function mt:compileVM(uri)
    local obj = self._file[uri]
    if not obj then
        return nil
    end
    if not self._needCompile[uri] then
        return nil
    end

    local compiled = self:_markCompiled(uri)
    local ast = self:compileAst(obj)
    self:_clearChainNode(obj, uri)

    obj.vm = matcher.vm(ast, self, uri)
    obj.lines = parser:lines(obj.text, 'utf8')
    if not obj.vm then
        return obj
    end

    self:_compileChain(obj, compiled)

    self._needDiagnostics[uri] = true

    return obj
end

function mt:getVM(uri)
    local obj = self._file[uri]
    if not obj then
        return nil
    end
    return obj.vm
end

function mt:compileChain(child, parent)
    local parentObj = self._file[parent]
    local childObj = self._file[child]

    if not parentObj or not childObj then
        return
    end
    if parentObj == childObj then
        return
    end

    if not parentObj.child then
        parentObj.child = {}
    end
    parentObj.child[child] = true

    if not childObj.parent then
        childObj.parent = {}
    end
    childObj.parent[parent] = true
end

function mt:removeText(uri)
    self._file[uri] = nil
end

function mt:checkWorkSpaceComplete()
    if self._hasCheckedWorkSpaceComplete then
        return
    end
    self._hasCheckedWorkSpaceComplete = true
    if self.workspace:isComplete() then
        return
    end
    self._needShowComplete = true
    rpc:notify('window/showMessage', {
        type = 3,
        message = lang.script.MWS_NOT_COMPLETE,
    })
end

function mt:onTick()
    while true do
        local ok, proto = self._proto:pop()
        if not ok then
            break
        end
        if proto.method then
            self:_doProto(proto)
        else
            rpc:recieve(proto)
        end
    end
    self:compileAll()
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

    self._proto = thread.channel 'proto'

    async.call([[require 'proto']])

    while true do
        async.onTick()
        self:onTick()
        thread.sleep(0.001)
    end
end

return function ()
    local session = setmetatable({
        _file = {},
        _needCompile = {},
        _needDiagnostics = {},
        _opening = {},
        _clock = -100,
        _version = 0,
    }, mt)
    return session
end
