---@class vm
local vm        = require 'vm.vm'
local util      = require 'utility'
local compiler  = require 'vm.compiler'
local guide     = require 'parser.guide'
local localID   = require 'vm.local-id'
local globalMgr = require 'vm.global-manager'
local nodeMgr   = require 'vm.node'
local files     = require 'files'
local await     = require 'await'
local progress  = require 'progress'
local lang      = require 'language'

local simpleSwitch

local function searchGetLocal(source, node, pushResult)
    local key = guide.getKeyName(source)
    for _, ref in ipairs(node.node.ref) do
        if  ref.type == 'getlocal'
        and ref.next
        and guide.getKeyName(ref.next) == key then
            pushResult(ref.next)
        end
    end
end

simpleSwitch = util.switch()
    : case 'local'
    : call(function (source, pushResult)
        if source.ref then
            for _, ref in ipairs(source.ref) do
                if ref.type == 'setlocal'
                or ref.type == 'getlocal' then
                    pushResult(ref)
                end
            end
        end
    end)
    : case 'getlocal'
    : case 'setlocal'
    : call(function (source, pushResult)
        simpleSwitch('local', source.node, pushResult)
    end)
    : case 'field'
    : call(function (source, pushResult)
        local parent = source.parent
        if parent.type ~= 'tablefield' then
            simpleSwitch(parent.type, parent, pushResult)
        end
    end)
    : case 'setfield'
    : case 'getfield'
    : call(function (source, pushResult)
        local node = source.node
        if node.type == 'getlocal' then
            searchGetLocal(source, node, pushResult)
            return
        end
    end)
    : case 'getindex'
    : case 'setindex'
    : call(function (source, pushResult)
        local node = source.node
        if node.type == 'getlocal' then
            searchGetLocal(source, node, pushResult)
        end
    end)
    : case 'goto'
    : call(function (source, pushResult)
        if source.node then
            simpleSwitch('label', source.node, pushResult)
            pushResult(source.node)
        end
    end)
    : case 'label'
    : call(function (source, pushResult)
        pushResult(source)
        if source.ref then
            for _, ref in ipairs(source.ref) do
                pushResult(ref)
            end
        end
    end)

---@async
local function searchInAllFiles(suri, searcher, notify)
    searcher(suri)

    local uris = {}
    for uri in files.eachFile(suri) do
        if  not vm.isMetaFile(uri)
        and suri ~= uri then
            uris[#uris+1] = uri
        end
    end

    local loading <close> = progress.create(suri, lang.script.WINDOW_SEARCHING_IN_FILES, 1)
    local cancelled
    loading:onCancel(function ()
        cancelled = true
    end)
    for i, uri in ipairs(uris) do
        if notify then
            local continue = notify(uri)
            if continue == false then
                break
            end
        end
        loading:setMessage(('%03d/%03d'):format(i, #uris))
        loading:setPercentage(i / #uris * 100)
        await.delay()
        if cancelled then
            break
        end
        searcher(uri)
    end
end

---@async
local function searchField(source, pushResult, defMap, fileNotify)
    local key = guide.getKeyName(source)

    ---@param src parser.object
    local function checkDef(src)
        for _, def in ipairs(vm.getDefs(src)) do
            if defMap[def] then
                pushResult(src)
                return
            end
        end
    end

    local pat   = '[:.]%s*' .. key

    ---@async
    local function findWord(uri)
        local text = files.getText(uri)
        if not text then
            return
        end
        if not text:match(pat) then
            return
        end
        local state = files.getState(uri)
        if not state then
            return
        end
        ---@async
        guide.eachSourceType(state.ast, 'getfield', function (src)
            if src.field and src.field[1] == key then
                checkDef(src)
                await.delay()
            end
        end)
        ---@async
        guide.eachSourceType(state.ast, 'getmethod', function (src)
            if src.method and src.method[1] == key then
                checkDef(src)
                await.delay()
            end
        end)
        ---@async
        guide.eachSourceType(state.ast, 'getindex', function (src)
            if src.index and src.index.type == 'string' and src.index[1] == key then
                checkDef(src)
                await.delay()
            end
        end)
    end

    searchInAllFiles(guide.getUri(source), findWord, fileNotify)
end

---@async
local function searchFunction(source, pushResult, defMap, fileNotify)
    ---@param src parser.object
    local function checkDef(src)
        for _, def in ipairs(vm.getDefs(src)) do
            if defMap[def] then
                pushResult(src)
                return
            end
        end
    end

    ---@async
    local function findCall(uri)
        local state = files.getState(uri)
        if not state then
            return
        end
        ---@async
        guide.eachSourceType(state.ast, 'call', function (src)
            checkDef(src.node)
            await.delay()
        end)
    end

    searchInAllFiles(guide.getUri(source), findCall, fileNotify)
end

local searchByParentNode
local nodeSwitch = util.switch()
    : case 'field'
    : case 'method'
    ---@async
    : call(function (source, pushResult, defMap, fileNotify)
        searchByParentNode(source.parent, pushResult, defMap, fileNotify)
    end)
    : case 'getfield'
    : case 'setfield'
    : case 'getmethod'
    : case 'setmethod'
    : case 'getindex'
    : case 'setindex'
    ---@async
    : call(function (source, pushResult, defMap, fileNotify)
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end

        local parentNode = compiler.compileNode(source.node)
        if not parentNode then
            return
        end

        searchField(source, pushResult, defMap, fileNotify)
    end)
    : case 'tablefield'
    : case 'tableindex'
    ---@async
    : call(function (source, pushResult, defMap, fileNotify)
        searchField(source, pushResult, defMap, fileNotify)
    end)
    : case 'function'
    : case 'doc.type.function'
    ---@async
    : call(function (source, pushResult, defMap, fileNotify)
        searchFunction(source, pushResult, defMap, fileNotify)
    end)

---@param source  parser.object
---@param pushResult fun(src: parser.object)
local function searchBySimple(source, pushResult)
    simpleSwitch(source.type, source, pushResult)
end

---@param source  parser.object
---@param pushResult fun(src: parser.object)
local function searchByLocalID(source, pushResult)
    local idSources = localID.getSources(source)
    if not idSources then
        return
    end
    for _, src in ipairs(idSources) do
        pushResult(src)
    end
end

---@async
---@param source  parser.object
---@param pushResult fun(src: parser.object)
---@param fileNotify fun(uri: uri): boolean
function searchByParentNode(source, pushResult, defMap, fileNotify)
    nodeSwitch(source.type, source, pushResult, defMap, fileNotify)
end

local function searchByNode(source, pushResult)
    local node = compiler.compileNode(source)
    if not node then
        return
    end
    local uri = guide.getUri(source)
    for n in nodeMgr.eachObject(node) do
        if n.type == 'global' then
            for _, get in ipairs(n:getGets(uri)) do
                pushResult(get)
            end
        end
    end
end

local function searchByDef(source, pushResult)
    local defMap = {}
    if source.type == 'function'
    or source.type == 'doc.type.function' then
        defMap[source] = true
        return defMap
    end
    local defs = vm.getDefs(source)
    for _, def in ipairs(defs) do
        pushResult(def)
        defMap[def] = true
    end
    return defMap
end

---@async
---@param source parser.object
---@param fileNotify fun(uri: uri): boolean
function vm.getRefs(source, fileNotify)
    local results = {}
    local mark    = {}

    local hasLocal
    local function pushResult(src)
        if src.type == 'local' and not src.dummy then
            if hasLocal then
                return
            end
            hasLocal = true
        end
        if not mark[src] then
            mark[src] = true
            results[#results+1] = src
        end
    end

    searchBySimple(source, pushResult)
    searchByLocalID(source, pushResult)
    searchByNode(source, pushResult)
    local defMap = searchByDef(source, pushResult)
    searchByParentNode(source, pushResult, defMap, fileNotify)

    return results
end
