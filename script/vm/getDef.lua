---@class vm
local vm       = require 'vm.vm'
local util     = require 'utility'
local compiler = require 'vm.node.compiler'
local guide    = require 'parser.guide'
local localID  = require 'vm.local-id'

local simpleMap

local function searchGetLocal(source, node, results)
    local key = guide.getKeyName(source)
    for _, ref in ipairs(node.node.ref) do
        if  ref.type == 'getlocal'
        and guide.isSet(ref.next)
        and guide.getKeyName(ref.next) == key then
            results[#results+1] = ref.next
        end
    end
end

simpleMap = util.switch()
    : case 'local'
    : call(function (source, results)
        results[#results+1] = source
        if source.ref then
            for _, ref in ipairs(source.ref) do
                if ref.type == 'setlocal' then
                    results[#results+1] = ref
                end
            end
        end

        if source.dummy then
            for _, res in ipairs(vm.getDefs(source.method.node)) do
                results[#results+1] = res
            end
        end
    end)
    : case 'getlocal'
    : case 'setlocal'
    : call(function (source, results)
        simpleMap['local'](source.node, results)
    end)
    : case 'field'
    : call(function (source, results)
        local parent = source.parent
        simpleMap[parent.type](parent, results)
    end)
    : case 'setfield'
    : case 'getfield'
    : call(function (source, results)
        local node = source.node
        if node.type == 'getlocal' then
            searchGetLocal(source, node, results)
            return
        end
    end)
    : case 'getindex'
    : case 'setindex'
    : call(function (source, results)
        local node = source.node
        if node.type == 'getlocal' then
            searchGetLocal(source, node, results)
        end
    end)
    : getMap()

local searchFieldMap = util.switch()
    : case 'table'
    : call(function (node, key, results)
        for _, field in ipairs(node) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                if guide.getKeyName(field) == key then
                    results[#results+1] = field
                end
            end
        end
    end)
    : getMap()

local nodeMap;nodeMap = util.switch()
    : case 'field'
    : call(function (source, results)
        local parent = source.parent
        nodeMap[parent.type](parent, results)
    end)
    : case 'getfield'
    : case 'setfield'
    : call(function (source, results)
        local node = compiler.compileNode(guide.getUri(source.node), source.node)
        if not node then
            return
        end
        if searchFieldMap[node.type] then
            searchFieldMap[node.type](node, guide.getKeyName(source), results)
        end
    end)
    : getMap()

---@param source  parser.object
---@param results parser.object[]
local function searchBySimple(source, results)
    local simple = simpleMap[source.type]
    if simple then
        simple(source, results)
    end
end

---@param source  parser.object
---@param results parser.object[]
local function searchByGlobal(source, results)
    if source.type == 'field' then
        source = source.parent
    end
    local global = source._globalID
    if not global then
        return
    end
    for _, src in ipairs(global:getSets()) do
        results[#results+1] = src
    end
end

local function searchByID(source, results)
    local idSources = localID.getSources(source)
    if not idSources then
        return
    end
end

---@param source  parser.object
---@param results parser.object[]
local function searchByNode(source, results)
    local node = nodeMap[source.type]
    if node then
        node(source, results)
    end
end

---@param source parser.object
---@return       parser.object[]
function vm.getDefs(source)
    local results = {}

    searchBySimple(source, results)
    searchByGlobal(source, results)
    --searchByID(source, results)
    searchByNode(source, results)

    return results
end

---@param source parser.object
---@return       parser.object[]
function vm.getAllDefs(source)
    return vm.getDefs(source)
end
