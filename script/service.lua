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
local chainMgr   = require 'vm.chain'
local functionMgr= require 'vm.function'
local listMgr    = require 'vm.list'
local emmyMgr    = require 'emmy.manager'
local config     = require 'config'
local task       = require 'task'
local files      = require 'files'
local uric       = require 'uri'
local capability = require 'capability'
local plugin     = require 'plugin'
local workspace  = require 'workspace'
local fn         = require 'filename'
local json       = require 'json'

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

---@class LSP
local mt = {}
mt.__index = mt
---@type files
mt._files = nil

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
    rpc:response(id, {
        error  = err and err or nil,
        result = response and response or json.null,
    })
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
    log.debug('clearDiagnostics', uri)
end

---@param uri uri
---@param compiled table
---@param mode string
---@return boolean
function mt:needCompile(uri, compiled, mode)
    self._needDiagnostics[uri] = true
    if self._needCompile[uri] then
        return false
    end
    if not compiled then
        compiled = {}
    end
    if compiled[uri] then
        return false
    end
    self._needCompile[uri] = compiled
    if mode == 'child' then
        table.insert(self._needCompile, uri)
    else
        table.insert(self._needCompile, 1, uri)
    end
    return true
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

---@param uri uri
---@param version integer
---@param text string
function mt:saveText(uri, version, text)
    self._lastLoadedVM = uri
    self._files:save(uri, text, version)
    self:needCompile(uri)
end

---@param uri uri
function mt:isDeadText(uri)
    return self._files:isDead(uri)
end

---@param name string
---@param uri uri
function mt:addWorkspace(name, uri)
    log.info("Add workspace", name, uri)
    for _, ws in ipairs(self.workspaces) do
        if ws.name == name and ws.uri == uri then
            return
        end
    end
    local ws = workspace(self, name)
    ws:init(uri)
    table.insert(self.workspaces, ws)
    return ws
end

---@param name string
---@param uri uri
function mt:removeWorkspace(name, uri)
    log.info("Remove workspace", name, uri)
    local index
    for i, ws in ipairs(self.workspaces) do
        if ws.name == name and ws.uri == uri then
            index = i
            break
        end
    end
    if index then
        table.remove(self.workspaces, index)
    end
end

---@param uri uri
---@return Workspace
function mt:findWorkspaceFor(uri)
    if #self.workspaces == 0 then
        return nil
    end
    local path = uric.decode(uri)
    if not path then
        return nil
    end
    for _, ws in ipairs(self.workspaces) do
        if not ws:relativePathByUri(uri):string():match("^%.%.") then
            return ws
        end
    end
    log.info("No workspace for", uri)
    return nil
end

---@param uri uri
---@return boolean
function mt:isLua(uri)
    if fn.isLuaFile(uric.decode(uri)) then
        return true
    end
    return false
end

function mt:isIgnored(uri)
    local ws = self:findWorkspaceFor(uri)
    if not ws then
        return true
    end
    if not ws.gitignore then
        return true
    end
    local path = ws:relativePathByUri(uri)
    if not path then
        return true
    end
    if ws.gitignore(path:string()) then
        return true
    end
    return false
end

---@param uri uri
---@param version integer
---@param text string
function mt:open(uri, version, text)
    if not self:isLua(uri) then
        return
    end
    self:saveText(uri, version, text)
    self._files:open(uri, text)
end

---@param uri uri
function mt:close(uri)
    self._files:close(uri)
    if self._files:isLibrary(uri) then
        return
    end
    if not self:isLua(uri) or self:isIgnored(uri) then
        self:removeText(uri)
    end
end

---@param uri uri
---@return boolean
function mt:isOpen(uri)
    return self._files:isOpen(uri)
end

function mt:eachOpened()
    return self._files:eachOpened()
end

function mt:eachFile()
    return self._files:eachFile()
end

---@param uri uri
---@param path path
---@param text string
function mt:checkReadFile(uri, path, text)
    if not text then
        log.debug('No file: ', path)
        return false
    end
    local size = #text / 1000.0
    if size > config.config.workspace.preloadFileSize then
        log.info(('Skip large file, size: %.3f KB: %s'):format(size, uri))
        return false
    end
    if self:getCachedFileCount() >= config.config.workspace.maxPreload then
        if not self._hasShowHitMaxPreload then
            self._hasShowHitMaxPreload = true
            rpc:notify('window/showMessage', {
                type = 3,
                message = lang.script('MWS_MAX_PRELOAD', config.config.workspace.maxPreload),
            })
        end
        return false
    end
    return true
end

---@param ws Workspace
---@param uri uri
---@param path path
---@param buf string
---@param compiled table
function mt:readText(ws, uri, path, buf, compiled)
    if self:findWorkspaceFor(uri) ~= ws then
        log.debug('Read failed due to different workspace:', uri, debug.traceback())
        return
    end
    if self._files:get(uri) then
        log.debug('Read failed due to duplicate:', uri)
        return
    end
    if not self:isLua(uri) then
        log.debug('Read failed due to not lua:', uri)
        return
    end
    if not self._files:isOpen(uri) and self:isIgnored(uri) then
        log.debug('Read failed due to ignored:', uri)
        return
    end
    local text = buf or io.load(path)
    if not self._files:isOpen(uri) and not self:checkReadFile(uri, path, text) then
        log.debug('Read failed due to check failed:', uri)
        return
    end
    self._files:save(uri, text, 0)
    self:needCompile(uri, compiled)
end

---@param ws Workspace
---@param uri uri
---@param path path
---@param buf string
---@param compiled table
function mt:readLibrary(ws, uri, path, buf, compiled)
    if not self:isLua(uri) then
        return
    end
    if not self:checkReadFile(uri, path, buf) then
        return
    end
    self._files:save(uri, buf, 0, ws)
    self._files:setLibrary(uri)
    self:needCompile(uri, compiled)
    self:clearDiagnostics(uri)
end

---@param uri uri
function mt:removeText(uri)
    self._files:remove(uri)
    self:compileVM(uri)
    self:clearDiagnostics(uri)
end

function mt:getCachedFileCount()
    return self._files:count()
end

function mt:reCompile()
    if self.global then
        self.global:remove()
    end
    if self.chain then
        self.chain:remove()
    end
    if self.emmy then
        self.emmy:remove()
    end

    local compiled = {}
    self._files:clearVM()

    for _, obj in pairs(listMgr.list) do
        if obj.type == 'source' or obj.type == 'function' then
            obj:kill()
        end
    end

    self.global = core.global(self)
    self.chain  = chainMgr()
    self.emmy   = emmyMgr()
    self.globalValue = nil
    if self._compileTask then
        self._compileTask:remove()
    end
    self._needCompile = {}
    local n = 0
    for uri in self._files:eachFile() do
        self:needCompile(uri, compiled)
        n = n + 1
    end
    log.debug('reCompile:', n, self._files:count())

    self:_testMemory('skip')
end

function mt:reDiagnostic()
    for uri in self._files:eachFile() do
        self:clearDiagnostics(uri)
        self._needDiagnostics[uri] = true
    end
end

function mt:clearAllFiles()
    for uri in self._files:eachFile() do
        self:clearDiagnostics(uri)
    end
    self._files:clear()
end

---@param uri uri
function mt:loadVM(uri)
    local file = self._files:get(uri)
    if not file then
        return nil
    end
    if uri ~= self._lastLoadedVM then
        self:needCompile(uri)
    end
    if self._compileTask
        and not self._compileTask:isRemoved()
        and self._compileTask:get 'uri' == uri
    then
        self._compileTask:fastForward()
    else
        self:compileVM(uri)
    end
    if file:getVM() then
        self._lastLoadedVM = uri
    end
    return file:getVM(), file:getLines()
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

---@param file file
---@return table
function mt:compileAst(file)
    local ast, err, comments = parser:parse(file:getText(), 'lua', config.config.runtime.version)
    file.comments = comments
    if ast then
        file:setAstErr(err)
    else
        if type(err) == 'string' then
            local message = lang.script('PARSER_CRASH', err)
            log.debug(message)
            rpc:notify('window/showMessage', {
                type = 3,
                message = lang.script('PARSER_CRASH', err:match '%.lua%:%d+%:(.+)' or err),
            })
            if message:find 'not enough memory' then
                self:restartDueToMemoryLeak()
            end
        end
    end
    return ast
end

---@param file file
---@param uri uri
function mt:_clearChainNode(file, uri)
    for pUri in file:eachParent() do
        local parent = self._files:get(pUri)
        if parent then
            parent:removeChild(uri)
        end
    end
end

---@param file file
---@param compiled table
function mt:_compileChain(file, compiled)
    if not compiled then
        compiled = {}
    end
    for uri in file:eachChild() do
        self:needCompile(uri, compiled, 'child')
    end
    for uri in file:eachParent() do
        self:needCompile(uri, compiled, 'parent')
    end
end

function mt:_compileGlobal(compiled)
    local uris = self.global:getAllUris()
    for _, uri in ipairs(uris) do
        self:needCompile(uri, compiled, 'global')
    end
end

function mt:_clearGlobal(uri)
    self.global:clearGlobal(uri)
end

function mt:_hasSetGlobal(uri)
    return self.global:hasSetGlobal(uri)
end

---@param uri uri
function mt:compileVM(uri)
    local file = self._files:get(uri)
    if not file then
        self:_markCompiled(uri)
        return nil
    end
    local compiled = self._needCompile[uri]
    if not compiled then
        return nil
    end
    file:removeVM()

    local clock = os.clock()
    local ast = self:compileAst(file)
    local version = file:getVersion()
    local astCost = os.clock() - clock
    if astCost > 0.1 then
        log.warn(('Compile Ast[%s] takes [%.3f] sec, size [%.3f]kb'):format(uri, astCost, #file:getText() / 1000))
    end
    file:clearOldText()

    self:_clearChainNode(file, uri)
    self:_clearGlobal(uri)

    local clock = os.clock()
    local vm, err = buildVM(ast, self, uri, file:getText())
    if vm then
        CachedVM[vm] = true
    end
    if self:isDeadText(uri)
        or file:isRemoved()
        or version ~= file:getVersion()
    then
        if vm then
            vm:remove()
        end
        return nil
    end
    if self._needCompile[uri] then
        self:_markCompiled(uri, compiled)
        self._needDiagnostics[uri] = true
    else
        if vm then
            vm:remove()
        end
        return nil
    end
    file:saveVM(vm, version, os.clock() - clock)

    local clock = os.clock()
    local lines = parser:lines(file:getText(), 'utf8')
    local lineCost = os.clock() - clock
    file:saveLines(lines, lineCost)

    if file:getVMCost() > 0.2 then
        log.debug(('Compile VM[%s] takes: %.3f sec'):format(uri, file:getVMCost()))
    end
    if not vm then
        error(err)
    end

    self:_compileChain(file, compiled)
    if self:_hasSetGlobal(uri) then
        self:_compileGlobal(compiled)
    end

    return file
end

---@param uri uri
function mt:doDiagnostics(uri)
    if not config.config.diagnostics.enable then
        self._needDiagnostics[uri] = nil
        return
    end
    if not self._needDiagnostics[uri] then
        return
    end
    local name = 'textDocument/publishDiagnostics'
    local file = self._files:get(uri)
    if not file
        or file:isRemoved()
        or not file:getVM()
        or file:getVM():isRemoved()
        or self._files:isLibrary(uri)
    then
        self._needDiagnostics[uri] = nil
        self:clearDiagnostics(uri)
        return
    end
    local data = {
        uri   = uri,
        vm    = file:getVM(),
        lines = file:getLines(),
        version = file:getVM():getVersion(),
    }
    local res = self:_callMethod(name, data)
    if self:isDeadText(uri) then
        return
    end
    if file:getVM():getVersion() ~= data.version then
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

---@param uri uri
---@return file
function mt:getFile(uri)
    return self._files:get(uri)
end

---@param uri uri
---@return VM
---@return table
---@return string
function mt:getVM(uri)
    local file = self._files:get(uri)
    if not file then
        return nil
    end
    return file:getVM(), file:getLines(), file:getText()
end

---@param uri uri
---@return string
---@return string
function mt:getText(uri)
    local file = self._files:get(uri)
    if not file then
        return nil
    end
    return file:getText(), file:getOldText()
end

function mt:getComments(uri)
    local file = self._files:get(uri)
    if not file then
        return nil
    end
    return file:getComments()
end

---@param uri uri
---@return table
function mt:getAstErrors(uri)
    local file = self._files:get(uri)
    if not file then
        return nil
    end
    return file:getAstErr()
end

---@param child uri
---@param parent uri
function mt:compileChain(child, parent)
    local parentFile = self._files:get(parent)
    local childFile = self._files:get(child)

    if not parentFile or not childFile then
        return
    end
    if parentFile == childFile then
        return
    end

    parentFile:addChild(child)
    childFile:addParent(parent)
end

function mt:checkWorkSpaceComplete()
    if self._hasCheckedWorkSpaceComplete then
        return
    end
    self._hasCheckedWorkSpaceComplete = true
    for _, ws in ipairs(self.workspaces) do
        if ws:isComplete() then
            return
        end
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
    end
    self._compileTask = task(function ()
        self:doDiagnostics(self._lastLoadedVM)
        local uri = self._needCompile[1]
        if uri then
            self._compileTask:set('uri', uri)
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
    if not self._compileTask or self._compileTask:isRemoved() then
        self:_createCompileTask()
    end
    while true do
        local res = self._compileTask:step()
        if res == 'stop' then
            self._compileTask:remove()
            break
        end
        if self._compileTask:isRemoved() then
            break
        end
    end
    self:_loadProto()
end

function mt:_loadProto()
    while true do
        local ok, protoStream = self._proto:pop()
        if not ok then
            break
        end
        local suc, proto = xpcall(json.decode, log.error, protoStream)
        if not suc then
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

function mt:reScanFiles()
    log.debug('reScanFiles')
    self:clearAllFiles()
    for _, ws in ipairs(self.workspaces) do
        ws:scanFiles()
    end
    for uri, text in self:eachOpened() do
        self:open(uri, 0, text)
    end
end

function mt:onUpdateConfig(updated, other)
    local oldConfig = table.deepCopy(config.config)
    local oldOther  = table.deepCopy(config.other)
    config:setConfig(updated, other)
    local newConfig = config.config
    local newOther  = config.other
    if not table.equal(oldConfig.runtime, newConfig.runtime) then
        local library = require 'core.library'
        library.reload()
        self:reCompile()
    end
    if not table.equal(oldConfig.diagnostics, newConfig.diagnostics) then
        log.debug('reDiagnostic')
        self:reDiagnostic()
    end
    if newConfig.completion.enable then
        capability.completion.enable(self)
    else
        capability.completion.disable(self)
    end
    if newConfig.color.mode == 'Semantic' then
        capability.semantic.enable(self)
    else
        capability.semantic.disable()
    end
    if not table.equal(oldConfig.plugin, newConfig.plugin) then
        for _, ws in ipairs(self.workspaces) do
            plugin.load(ws)
        end
    end
    if not table.equal(oldConfig.workspace, newConfig.workspace)
    or not table.equal(oldConfig.plugin, newConfig.plugin)
    or not table.equal(oldOther.associations, newOther.associations)
    or not table.equal(oldOther.exclude, newOther.exclude)
    then
        self:reScanFiles()
    end
end

function mt:_testMemory(skipDead)
    local clock = os.clock()
    collectgarbage()
    log.debug('collectgarbage: ', ('%.3f'):format(os.clock() - clock))

    local clock = os.clock()
    local cachedVM = 0
    local cachedSource = 0
    local cachedFunction = 0
    for _, file in self._files:eachFile() do
        local vm = file:getVM()
        if vm and not vm:isRemoved() then
            cachedVM = cachedVM + 1
            cachedSource = cachedSource + #vm.sources
            cachedFunction = cachedFunction + #vm.funcs
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
        if listMgr.get(id) then
            alivedSource = alivedSource + 1
        else
            deadSource = deadSource + 1
        end
    end

    local alivedFunction = 0
    local deadFunction = 0
    for _, id in pairs(functionMgr.watch) do
        if listMgr.get(id) then
            alivedFunction = alivedFunction + 1
        else
            deadFunction = deadFunction + 1
        end
    end

    local totalLocal = 0
    for _ in pairs(localMgr.watch) do
        totalLocal = totalLocal + 1
    end

    local totalValue = 0
    local deadValue = 0
    for value in pairs(valueMgr.watch) do
        totalValue = totalValue + 1
        if not value:getSource() then
            deadValue = deadValue + 1
        end
    end

    local totalEmmy = self.emmy:count()

    local mem = collectgarbage 'count'
    local threadInfo = async.info
    local threadBuf = {}
    for i, count in ipairs(threadInfo) do
        if count then
            threadBuf[i] = ('#%03d Mem:  [%.3f]kb'):format(i, count)
        else
            threadBuf[i] = ('#%03d Mem:  <Unknown>'):format(i)
        end
    end

    log.debug(('\n\z
    State\n\z
    Main Mem:  [%.3f]kb\n\z
    %s\n\z
-------------------\n\z
    CachedVM:  [%d]\n\z
    AlivedVM:  [%d]\n\z
    DeadVM:    [%d]\n\z
-------------------\n\z
    CachedSrc: [%d]\n\z
    AlivedSrc: [%d]\n\z
    DeadSrc:   [%d]\n\z
-------------------\n\z
    CachedFunc:[%d]\n\z
    AlivedFunc:[%d]\n\z
    DeadFunc:  [%d]\n\z
-------------------\n\z
    TotalVal:  [%d]\n\z
    DeadVal:   [%d]\n\z
-------------------\n\z
    TotalLoc:  [%d]\n\z
    TotalEmmy: [%d]\n\z'):format(
        mem,
        table.concat(threadBuf, '\n'),

        cachedVM,
        aliveVM,
        deadVM,

        cachedSource,
        alivedSource,
        deadSource,

        cachedFunction,
        alivedFunction,
        deadFunction,

        totalValue,
        deadValue,
        totalLocal,
        totalEmmy
    ))
    log.debug('test memory: ', ('%.3f'):format(os.clock() - clock))

    if deadValue / totalValue >= 0.5 and not skipDead then
        self:_testFindDeadValues()
    end
end

function mt:_testFindDeadValues()
    if self._testHasFoundDeadValues then
        return
    end
    self._testHasFoundDeadValues = true

    log.debug('Start find dead values, may takes few seconds...')

    local mark = {}
    local stack = {}
    local count = 0
    local clock = os.clock()
    local function push(info)
        stack[#stack+1] = info
    end
    local function pop()
        stack[#stack] = nil
    end
    local function showStack(uri)
        count = count + 1
        log.debug(uri, table.concat(stack, '->'))
    end
    local function scan(name, tbl)
        if count > 100 or os.clock() - clock > 5.0 then
            return
        end
        if type(tbl) ~= 'table' then
            return
        end
        if mark[tbl] then
            return
        end
        mark[tbl] = true
        if tbl.type then
            push(('%s<%s>'):format(name, tbl.type))
        else
            push(name)
        end
        if tbl.type == 'value' then
            if not tbl:getSource() then
                showStack(tbl.uri)
            end
        elseif tbl.type == 'files' then
            for k, v in tbl:eachFile() do
                scan(k, v)
            end
        else
            for k, v in pairs(tbl) do
                scan(k, v)
            end
        end
        pop()
    end
    scan('root', self._files)
    log.debug('Finish...')
end

function mt:onTick()
    self:_loadProto()
    self:_doCompileTask()
    if (os.clock() - self._clock >= 60 and not self:isWaitingCompile())
    or (os.clock() - self._clock >= 300)
    then
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

    local timerClock = 0.0
    while true do
        local startClock = os.clock()
        async.onTick()
        self:onTick()

        local delta = os.clock() - timerClock
        local suc, err = xpcall(updateTimer, log.error, delta)
        if not suc then
            io.stderr:write(err)
            io.stderr:flush()
        end
        timerClock = os.clock()

        local passedClock = os.clock() - startClock
        if passedClock > 0.1 then
            thread.sleep(0.0)
        else
            thread.sleep(0.001)
        end
    end
end

--- @return LSP
return function ()
    local session = setmetatable({
        _needCompile = {},
        _needDiagnostics = {},
        _clock = -100,
        _version = 0,
        _files = files(),
    }, mt)
    session.global = core.global(session)
    session.chain  = chainMgr()
    session.emmy   = emmyMgr()
    ---@type Workspace[]
    session.workspaces = {}
    return session
end
