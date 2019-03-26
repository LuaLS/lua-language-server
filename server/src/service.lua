local subprocess = require 'bee.subprocess'
local method     = require 'method'
local thread     = require 'bee.thread'
local async      = require 'async'
local rpc        = require 'rpc'
local parser     = require 'parser'
local core       = require 'core'
local lang       = require 'language'
local updateTimer= require 'timer'
local buildVM    = require 'vm'
local sourceMgr  = require 'vm.source'
local localMgr   = require 'vm.local'
local valueMgr   = require 'vm.value'

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

local CachedVM = setmetatable({}, {__mode = 'kv'})

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
        if passed > 0.2 then
            log.debug(('Task [%s] takes [%.3f]sec.'):format(name, passed))
        end
        if suc then
            return res
        else
            local ok, r = pcall(table.dump, params)
            local dump = ok and r or '<Cyclic table>'
            if #dump > 10000 then
                dump = '<Large table>'
            end
            log.debug(('Task [%s] failed, params: %s'):format(
                name, dump
            ))
            log.error(res)
            if res:find 'not enough memory' then
                self:restartDueToMemoryLeak()
            end
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

function mt:responseProto(id, response, err)
    local container = table.container()
    if err then
        container.error = err
    else
        container.result = response
    end
    rpc:response(id, container)
end

function mt:_doProto(proto)
    local id     = proto.id
    local name   = proto.method
    local params = proto.params
    local response, err = self:_callMethod(name, params)
    if not id then
        return
    end
    if type(response) == 'function' then
        response(function (final)
            self:responseProto(id, final)
        end)
    else
        self:responseProto(id, response, err)
    end
end

function mt:clearDiagnostics(uri)
    rpc:notify('textDocument/publishDiagnostics', {
        uri = uri,
        diagnostics = {},
    })
    self._needDiagnostics[uri] = nil
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

function mt:isNeedCompile(uri)
    return self._needCompile[uri]
end

function mt:isWaitingCompile()
    if self._needCompile[1] then
        return true
    else
        return false
    end
end

function mt:saveText(uri, version, text)
    self._lastLoadedVM = nil
    local obj = self._file[uri]
    if obj then
        obj.version = version
        obj.oldText = obj.text
        obj.text = text
        self:needCompile(uri)
    else
        self._file[uri] = {
            version = version,
            text = text,
            uri = uri,
        }
        self:needCompile(uri)
    end
end

function mt:isDeadText(uri)
    local obj = self._file[uri]
    if not obj then
        return true
    end
    if obj.version == -1 then
        return true
    end
    return false
end

function mt:open(uri, version, text)
    self:saveText(uri, version, text)
    local obj = self._file[uri]
    if obj then
        obj._openByClient = true
    end
end

function mt:close(uri)
    local obj = self._file[uri]
    if obj then
        obj._openByClient = false
    end
end

function mt:isOpen(uri)
    local obj = self._file[uri]
    if obj and obj._openByClient then
        return true
    else
        return false
    end
end

function mt:readText(uri, path, buf, compiled)
    local obj = self._file[uri]
    if obj then
        return
    end
    local text = buf or io.load(path)
    if not text then
        log.debug('No file: ', path)
        return
    end
    self._file[uri] = {
        version = 0,
        text = text,
        uri = uri,
    }
    self:needCompile(uri, compiled)
end

function mt:removeText(uri)
    if not self._file[uri] then
        return
    end
    self:saveText(uri, -1, '')
    self:compileVM(uri)
    self._file[uri] = nil
end

function mt:reCompile()
    local compiled = {}
    local n = 0
    for uri in pairs(self._file) do
        self:needCompile(uri, compiled)
        n = n + 1
    end
    log.debug('reCompile:', n)
    self:_testMemory()
end

function mt:reDiagnostic()
    for uri in pairs(self._file) do
        self._needDiagnostics[uri] = true
    end
end

function mt:ClearAllFiles()
    for uri in pairs(self._file) do
        self:removeText(uri)
        self:clearDiagnostics(uri)
    end
end

function mt:loadVM(uri)
    local obj = self._file[uri]
    if not obj then
        return nil
    end
    if uri ~= self._lastLoadedVM then
        self:needCompile(uri)
    end
    self:compileVM(uri)
    if obj.vm then
        self._lastLoadedVM = uri
    end
    return obj.vm, obj.lines, obj.text
end

function mt:_markCompiled(uri, compiled)
    local newCompiled = self._needCompile[uri]
    if newCompiled then
        newCompiled[uri] = true
        self._needCompile[uri] = nil
    end
    for i, u in ipairs(self._needCompile) do
        if u == uri then
            table.remove(self._needCompile, i)
            break
        end
    end
    if newCompiled == compiled then
        return compiled
    end
    if not compiled then
        compiled = {}
    end
    for k, v in pairs(newCompiled) do
        compiled[k] = v
    end
    return compiled
end

function mt:compileAst(obj)
    local ast, err = parser:ast(obj.text)
    obj.astErr = err
    if not ast then
        if type(err) == 'string' then
            local message = lang.script('PARSER_CRASH', err)
            log.debug(message)
            rpc:notify('window/showMessage', {
                type = 3,
                message = lang.script('PARSER_CRASH', err:match 'grammar%.lua%:%d+%:(.+)' or err),
            })
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
    if not compiled then
        compiled = {}
    end
    if obj.child then
        for uri in pairs(obj.child) do
            self:needCompile(uri, compiled)
        end
    end
    if obj.parent then
        for uri in pairs(obj.parent) do
            self:needCompile(uri, compiled)
        end
    end
end

function mt:_compileGlobal(compiled)
    local uris = self.global:getAllUris()
    for _, uri in ipairs(uris) do
        self:needCompile(uri, compiled)
    end
end

function mt:_clearGlobal(uri)
    self.global:clearGlobal(uri)
end

function mt:_hasSetGlobal(uri)
    return self.global:hasSetGlobal(uri)
end

function mt:compileVM(uri)
    local obj = self._file[uri]
    if not obj then
        self:_markCompiled(uri)
        return nil
    end
    local compiled = self._needCompile[uri]
    if not compiled then
        return nil
    end

    local clock = os.clock()
    local ast = self:compileAst(obj)
    local version = obj.version
    obj.astCost = os.clock() - clock
    obj.oldText = nil

    self:_clearChainNode(obj, uri)
    self:_clearGlobal(uri)

    local clock = os.clock()
    local vm, err = buildVM(ast, self, uri)
    if vm then
        CachedVM[vm] = true
    end
    if self:isDeadText(uri) then
        if vm then
            vm:remove()
        end
        return nil
    end
    if version ~= obj.version then
        if vm then
            vm:remove()
        end
        return nil
    end
    if self._needCompile[uri] then
        self:_markCompiled(uri, compiled)
    else
        if vm then
            vm:remove()
        end
        return nil
    end
    if obj.vm then
        obj.vm:remove()
    end
    obj.vm = vm
    obj.vmCost = os.clock() - clock
    obj.vmVersion = version

    local clock = os.clock()
    obj.lines = parser:lines(obj.text, 'utf8')
    obj.lineCost = os.clock() - clock

    self._needDiagnostics[uri] = true

    if obj.vmCost > 0.2 then
        log.debug(('Compile VM[%s] takes: %.3f sec'):format(uri, obj.vmCost))
    end
    if not obj.vm then
        error(err)
    end

    self:_compileChain(obj, compiled)
    if self:_hasSetGlobal(uri) then
        self:_compileGlobal(compiled)
    end

    return obj
end

function mt:doDiagnostics(uri)
    if not self._needDiagnostics[uri] then
        return
    end
    local name = 'textDocument/publishDiagnostics'
    local obj = self._file[uri]
    if not obj or not obj.vm then
        self._needDiagnostics[uri] = nil
        self:clearDiagnostics(uri)
        return
    end
    local data = {
        uri   = uri,
        vm    = obj.vm,
        lines = obj.lines,
        version = obj.vmVersion,
    }
    local res  = self:_callMethod(name, data)
    if self:isDeadText(uri) then
        return
    end
    if obj.version ~= data.version then
        return
    end
    if self._needDiagnostics[uri] then
        self._needDiagnostics[uri] = nil
    else
        return
    end
    if res then
        rpc:notify(name, {
            uri = uri,
            diagnostics = res,
        })
    else
        self:clearDiagnostics(uri)
    end
end

function mt:getVM(uri)
    local obj = self._file[uri]
    if not obj then
        return nil
    end
    return obj.vm, obj.lines, obj.text
end

function mt:getText(uri)
    local obj = self._file[uri]
    if not obj then
        return nil
    end
    return obj.text, obj.oldText
end

function mt:getAstErrors(uri)
    local obj = self._file[uri]
    if not obj then
        return nil
    end
    return obj.astErr
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

function mt:_createCompileTask()
    if not self:isWaitingCompile() and not next(self._needDiagnostics) then
        if self._needShowComplete then
            self._needShowComplete = nil
            rpc:notify('window/showMessage', {
                type = 3,
                message = lang.script.MWS_COMPLETE,
            })
        end
        return
    end
    self._compileTask = coroutine.create(function ()
        self:doDiagnostics(self._lastLoadedVM)
        local uri = self._needCompile[1]
        if uri then
            pcall(function () self:compileVM(uri) end)
        else
            uri = next(self._needDiagnostics)
            if uri then
                self:doDiagnostics(uri)
            end
        end
    end)
end

function mt:_doCompileTask()
    if not self._compileTask then
        self:_createCompileTask()
    end
    if not self._compileTask then
        return
    end
    while true do
        local suc, res = coroutine.resume(self._compileTask)
        if not suc then
            self._compileTask = nil
            return
        end
        if res == 'stop' then
            self._compileTask = nil
            return
        end
        if coroutine.status(self._compileTask) == 'suspended' then
            self:_loadProto()
        else
            self._compileTask = nil
            return
        end
    end
end

function mt:_loadProto()
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
end

function mt:restartDueToMemoryLeak()
    rpc:requestWait('window/showMessageRequest', {
        type = 3,
        message = lang.script('DEBUG_MEMORY_LEAK', '[Lua]'),
        actions = {
            {
                title = lang.script.DEBUG_RESTART_NOW,
            }
        }
    }, function ()
        os.exit(true)
    end)
    ac.wait(5, function ()
        os.exit(true)
    end)
end

function mt:_testMemory()
    local cachedVM = 0
    local cachedSource = 0
    for _, obj in pairs(self._file) do
        if obj.vm then
            cachedVM = cachedVM + 1
            cachedSource = cachedSource + #obj.vm.sources
        end
    end
    local aliveVM = 0
    local deadVM = 0
    for vm in pairs(CachedVM) do
        if vm:isRemoved() then
            deadVM = deadVM + 1
        else
            aliveVM = aliveVM + 1
        end
    end

    local alivedSource = 0
    local deadSource = 0
    for _, id in pairs(sourceMgr.watch) do
        if sourceMgr.list[id] then
            alivedSource = alivedSource + 1
        else
            deadSource = deadSource + 1
        end
    end

    local totalLocal = 0
    for _ in pairs(localMgr.watch) do
        totalLocal = totalLocal + 1
    end

    local totalValue = 0
    for _ in pairs(valueMgr.watch) do
        totalValue = totalValue + 1
    end

    local mem = collectgarbage 'count'
    log.debug(('\n\z
    State\n\z
    Mem:      [%.3f]kb\n\z
    CachedVM: [%d]\n\z
    AlivedVM: [%d]\n\z
    DeadVM:   [%d]\n\z
    CachedSrc:[%d]\n\z
    AlivedSrc:[%d]\n\z
    DeadSrc:  [%d]\n\z
    TotalLoc: [%d]\n\z
    TotalVal: [%d]'):format(
        mem,
        cachedVM,
        aliveVM,
        deadVM,
        cachedSource,
        alivedSource,
        deadSource,
        totalLocal,
        totalValue
    ))
end

function mt:onTick()
    self:_loadProto()
    self:_doCompileTask()
    if os.clock() - self._clock >= 60 then
        self._clock = os.clock()
        self:_testMemory()
    end
end

function mt:listen()
    subprocess.filemode(io.stdin, 'b')
    subprocess.filemode(io.stdout, 'b')
    io.stdin:setvbuf 'no'
    io.stdout:setvbuf 'no'

    local _, out = async.run 'proto'
    self._proto = out

    local clock = os.clock()
    while true do
        async.onTick()
        self:onTick()

        local delta = os.clock() - clock
        clock = os.clock()
        updateTimer(delta)
        thread.sleep(0.001)
    end
end

return function ()
    local session = setmetatable({
        _file = {},
        _needCompile = {},
        _needDiagnostics = {},
        _clock = -100,
        _version = 0,
    }, mt)
    session.global = core.global(session)
    return session
end
