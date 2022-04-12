---@class vm
local vm        = require 'vm.vm'
local util      = require 'utility'
local compiler  = require 'vm.compiler'
local guide     = require 'parser.guide'
local localID   = require 'vm.local-id'
local globalMgr = require 'vm.global-manager'
local nodeMgr   = require 'vm.node'

local simpleSwitch

local function searchGetLocal(source, node, pushResult)
    local key = guide.getKeyName(source)
    for _, ref in ipairs(node.node.ref) do
        if  ref.type == 'getlocal'
        and ref.next
        and guide.isSet(ref.next)
        and guide.getKeyName(ref.next) == key then
            pushResult(ref.next)
        end
    end
end

simpleSwitch = util.switch()
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
            pushResult(source.node)
        end
    end)

local searchFieldSwitch = util.switch()
    : case 'table'
    : call(function (suri, obj, key, pushResult)
        for _, field in ipairs(obj) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                if guide.getKeyName(field) == key then
                    pushResult(field)
                end
            end
        end
    end)
    : case 'global'
    ---@param obj vm.object
    ---@param key string
    : call(function (suri, obj, key, pushResult)
        if obj.cate == 'variable' then
            local newGlobal = globalMgr.getGlobal('variable', obj.name, key)
            if newGlobal then
                for _, set in ipairs(newGlobal:getSets(suri)) do
                    pushResult(set)
                end
            end
        end
        if obj.cate == 'type' then
            compiler.getClassFields(suri, obj, key, pushResult)
        end
    end)
    : case 'local'
    : call(function (suri, obj, key, pushResult)
        local sources = localID.getSources(obj, key)
        if sources then
            for _, src in ipairs(sources) do
                if guide.isSet(src) then
                    pushResult(src)
                end
            end
        end
    end)
    : case 'doc.type.table'
    : call(function (suri, obj, key, pushResult)
        for _, field in ipairs(obj.fields) do
            local fieldKey = field.name
            if fieldKey.type == 'doc.field.name' then
                if fieldKey[1] == key then
                    pushResult(field)
                end
            end
        end
    end)

local searchByParentNode
local nodeSwitch = util.switch()
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
        local uri = guide.getUri(source)
        local key = guide.getKeyName(source)
        for pn in nodeMgr.eachObject(parentNode) do
            searchFieldSwitch(pn.type, uri, pn, key, pushResult)
        end
    end)
    : case 'tableindex'
    : case 'tablefield'
    : call(function (source, pushResult)
        local tbl = source.parent
        local uri = guide.getUri(source)
        searchFieldSwitch(tbl.type, uri, tbl, guide.getKeyName(source), pushResult)
    end)
    : case 'doc.see.field'
    : call(function (source, pushResult)
        local parentNode = compiler.compileNode(source.parent.name)
        if not parentNode then
            return
        end
        local uri = guide.getUri(source)
        for pn in nodeMgr.eachObject(parentNode) do
            searchFieldSwitch(pn.type, uri, pn, source[1], pushResult)
        end
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
        if guide.isSet(src) then
            pushResult(src)
        end
    end
end

---@param source  parser.object
---@param pushResult fun(src: parser.object)
function searchByParentNode(source, pushResult)
    nodeSwitch(source.type, source, pushResult)
end

local function searchByNode(source, pushResult)
    local node = compiler.compileNode(source)
    if not node then
        return
    end
    local suri = guide.getUri(source)
    for n in nodeMgr.eachObject(node) do
        if n.type == 'global' then
            for _, set in ipairs(n:getSets(suri)) do
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
