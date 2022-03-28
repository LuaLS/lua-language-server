---@class vm
local vm        = require 'vm.vm'
local util      = require 'utility'
local compiler  = require 'vm.compiler'
local guide     = require 'parser.guide'
local localID   = require 'vm.local-id'
local globalMgr = require 'vm.global-manager'
local nodeMgr   = require 'vm.node'
local files     = require 'files'

local simpleMap

local function searchGetLocal(source, node, pushResult)
    local key = guide.getKeyName(source)
    for _, ref in ipairs(node.node.ref) do
        if  ref.type == 'getlocal'
        and not guide.isSet(ref.next)
        and guide.getKeyName(ref.next) == key then
            pushResult(ref.next)
        end
    end
end

simpleMap = util.switch()
    : case 'local'
    : call(function (source, pushResult)
        pushResult(source)
        if source.ref then
            for _, ref in ipairs(source.ref) do
                if ref.type == 'setlocal'
                or ref.type == 'getlocal' then
                    pushResult(ref)
                end
            end
        end

        if source.dummy then
            for _, res in ipairs(vm.getDefs(source.method.node)) do
                pushResult(res)
            end
        end
    end)
    : case 'getlocal'
    : case 'setlocal'
    : call(function (source, pushResult)
        simpleMap['local'](source.node, pushResult)
    end)
    : case 'field'
    : call(function (source, pushResult)
        local parent = source.parent
        if parent.type ~= 'tablefield' then
            simpleMap[parent.type](parent, pushResult)
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
            simpleMap['label'](source.node, pushResult)
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
    : getMap()

local function searchField(source, pushResult)
    local key = guide.getKeyName(source)

    ---@param src parser.object
    local function checkDef(src)
        for _, def in ipairs(vm.getDefs(src)) do
            if def == source then
                pushResult(src)
                return
            end
        end
    end

    local pat   = '[:.]%s*' .. key

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
        guide.eachSourceType(state.ast, 'getfield', function (src)
            if src.field[1] == key then
                checkDef(src)
            end
        end)
        guide.eachSourceType(state.ast, 'getmethod', function (src)
            if src.method[1] == key then
                checkDef(src)
            end
        end)
        guide.eachSourceType(state.ast, 'getindex', function (src)
            if src.index.type == 'string' and src.index[1] == key then
                checkDef(src)
            end
        end)
    end

    for uri in files.eachFile(guide.getUri(source)) do
        if not vm.isMetaFile(uri) then
            findWord(uri)
        end
    end
end

local searchByParentNode
local nodeMap = util.switch()
    : case 'field'
    : case 'method'
    : call(function (source, pushResult)
        searchByParentNode(source.parent, pushResult)
    end)
    : case 'getfield'
    : case 'setfield'
    : case 'getmethod'
    : case 'setmethod'
    : case 'getindex'
    : case 'setindex'
    : call(function (source, pushResult)
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end

        local parentNode = compiler.compileNode(source.node)
        if not parentNode then
            return
        end

        searchField(source, pushResult)
    end)
    : case 'tablefield'
    : case 'tableindex'
    : call(function (source, pushResult)
        searchField(source, pushResult)
    end)
    : getMap()

---@param source  parser.object
---@param pushResult fun(src: parser.object)
local function searchBySimple(source, pushResult)
    local simple = simpleMap[source.type]
    if simple then
        simple(source, pushResult)
    end
end

---@param source  parser.object
---@param pushResult fun(src: parser.object)
local function searchByLocalID(source, pushResult)
    local idSources = localID.getSources(source)
    if not idSources then
        return
    end
    for _, src in ipairs(idSources) do
        if not guide.isSet(src) then
            pushResult(src)
        end
    end
end

---@param source  parser.object
---@param pushResult fun(src: parser.object)
function searchByParentNode(source, pushResult)
    local node = nodeMap[source.type]
    if node then
        node(source, pushResult)
    end
end

local function searchByNode(source, pushResult)
    local node = compiler.compileNode(source)
    if not node then
        return
    end
    for n in nodeMgr.eachNode(node) do
        if n.type == 'global' then
            for _, get in ipairs(n:getGets()) do
                pushResult(get)
            end
        else
            pushResult(n)
        end
    end
end

function vm.getRefs(source)
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
    searchByParentNode(source, pushResult)
    searchByNode(source, pushResult)

    return results
end
