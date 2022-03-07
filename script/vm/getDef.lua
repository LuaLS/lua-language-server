---@class vm
local vm        = require 'vm.vm'
local util      = require 'utility'
local compiler  = require 'vm.compiler'
local guide     = require 'parser.guide'
local localID   = require 'vm.local-id'
local globalMgr = require 'vm.global-manager'
local nodeMgr   = require 'vm.node'

local simpleMap

local function searchGetLocal(source, node, pushResult)
    local key = guide.getKeyName(source)
    for _, ref in ipairs(node.node.ref) do
        if  ref.type == 'getlocal'
        and guide.isSet(ref.next)
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
                if ref.type == 'setlocal' then
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
        simpleMap[parent.type](parent, pushResult)
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
            pushResult(source.node)
        end
    end)
    : getMap()

local searchFieldMap = util.switch()
    : case 'table'
    : call(function (node, key, pushResult)
        for _, field in ipairs(node) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                if guide.getKeyName(field) == key then
                    pushResult(field)
                end
            end
        end
    end)
    : case 'global'
    ---@param node vm.node
    ---@param key string
    : call(function (node, key, pushResult)
        if node.cate == 'variable' then
            local newGlobal = globalMgr.getGlobal('variable', node.name, key)
            if newGlobal then
                for _, set in ipairs(newGlobal:getSets()) do
                    pushResult(set)
                end
            end
        end
        if node.cate == 'type' then
            compiler.getClassFields(node, key, pushResult)
        end
    end)
    : case 'local'
    : call(function (node, key, pushResult)
        local sources = localID.getSources(node, key)
        if sources then
            for _, src in ipairs(sources) do
                if guide.isSet(src) then
                    pushResult(src)
                end
            end
        end
    end)
    : case 'doc.type.table'
    : call(function (node, key, pushResult)
        for _, field in ipairs(node.fields) do
            local fieldKey = field.name
            if fieldKey.type == 'doc.field.name' then
                if fieldKey[1] == key then
                    pushResult(fieldKey)
                end
            end
        end
    end)
    : getMap()

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
        local parentNode = compiler.compileNode(source.node)
        if not parentNode then
            return
        end
        local key = guide.getKeyName(source)
        for pn in nodeMgr.eachNode(parentNode) do
            if searchFieldMap[pn.type] then
                searchFieldMap[pn.type](pn, key, pushResult)
            end
        end
    end)
    : case 'doc.see.field'
    : call(function (source, pushResult)
        local parentNode = compiler.compileNode(source.parent.name)
        if not parentNode then
            return
        end
        for pn in nodeMgr.eachNode(parentNode) do
            if searchFieldMap[pn.type] then
                searchFieldMap[pn.type](pn, source[1], pushResult)
            end
        end
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
        if guide.isSet(src) then
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
        if n.type == 'global' and n.cate == 'type' then
            for _, set in ipairs(n:getSets()) do
                pushResult(set)
            end
        else
            pushResult(n)
        end
    end
end

---@param source parser.object
---@return       parser.object[]
function vm.getDefs(source)
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
            if src.type == 'global' then
                for _, set in ipairs(src:getSets()) do
                    pushResult(set)
                end
                return
            end
            if guide.isSet(src)
            or guide.isLiteral(src) then
                results[#results+1] = src
            end
        end
    end

    searchBySimple(source, pushResult)
    searchByLocalID(source, pushResult)
    searchByParentNode(source, pushResult)
    searchByNode(source, pushResult)

    return results
end

---@param source parser.object
---@return       parser.object[]
function vm.getAllDefs(source)
    return vm.getDefs(source)
end
