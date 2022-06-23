---@class vm
local vm        = require 'vm.vm'
local util      = require 'utility'
local guide     = require 'parser.guide'
local files     = require 'files'
local await     = require 'await'
local progress  = require 'progress'
local lang      = require 'language'

local simpleSwitch

simpleSwitch = util.switch()
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
        guide.eachSourceTypes(state.ast, {'getfield', 'setfield'}, function (src)
            if src.field and src.field[1] == key then
                checkDef(src)
                await.delay()
            end
        end)
        ---@async
        guide.eachSourceTypes(state.ast, {'getmethod', 'setmethod'}, function (src)
            if src.method and src.method[1] == key then
                checkDef(src)
                await.delay()
            end
        end)
        ---@async
        guide.eachSourceTypes(state.ast, {'getindex', 'setindex'}, function (src)
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
    local sourceSets = vm.getLocalSourcesSets(source)
    if sourceSets then
        for _, src in ipairs(sourceSets) do
            pushResult(src)
        end
    end
    local sourceGets = vm.getLocalSourcesGets(source)
    if sourceGets then
        for _, src in ipairs(sourceGets) do
            pushResult(src)
        end
    end
end

---@async
---@param source  parser.object
---@param pushResult fun(src: parser.object)
---@param fileNotify? fun(uri: uri): boolean
function searchByParentNode(source, pushResult, defMap, fileNotify)
    nodeSwitch(source.type, source, pushResult, defMap, fileNotify)
end

local function searchByNode(source, pushResult)
    local node = vm.compileNode(source)
    if not node then
        return
    end
    local uri = guide.getUri(source)
    for n in node:eachObject() do
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
    if source.type == 'field'
    or source.type == 'method' then
        source = source.parent
    end
    defMap[source] = true
    if guide.isSet(source) then
        local defs = vm.getDefs(source)
        for _, def in ipairs(defs) do
            pushResult(def)
        end
    else
        local defs = vm.getDefs(source)
        for _, def in ipairs(defs) do
            pushResult(def)
            defMap[def] = true
        end
    end
    return defMap
end

---@async
---@param source parser.object
---@param fileNotify? fun(uri: uri): boolean
function vm.getRefs(source, fileNotify)
    local results = {}
    local mark    = {}

    local hasLocal
    local function pushResult(src)
        if src.type == 'local' then
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
