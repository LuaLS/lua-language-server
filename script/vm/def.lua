---@class vm
local vm        = require 'vm.vm'
local util      = require 'utility'
local guide     = require 'parser.guide'

local simpleSwitch

simpleSwitch = util.switch()
    : case 'goto'
    : call(function (source, pushResult)
        if source.node then
            pushResult(source.node)
        end
    end)
    : case 'doc.cast.name'
    : call(function (source, pushResult)
        local loc = guide.getLocal(source, source[1], source.start)
        if loc then
            pushResult(loc)
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
    ---@param obj vm.global
    ---@param key string
    : call(function (suri, obj, key, pushResult)
        if obj.cate == 'variable' then
            local newGlobal = vm.getGlobal('variable', obj.name, key)
            if newGlobal then
                for _, set in ipairs(newGlobal:getSets(suri)) do
                    pushResult(set)
                end
            end
        end
        if obj.cate == 'type' then
            vm.getClassFields(suri, obj, key, false, pushResult)
        end
    end)
    : case 'local'
    : call(function (suri, obj, key, pushResult)
        local sources = vm.getLocalSourcesSets(obj, key)
        if sources then
            for _, src in ipairs(sources) do
                pushResult(src)
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

local nodeSwitch;nodeSwitch = util.switch()
    : case 'field'
    : case 'method'
    : call(function (source, lastKey, pushResult)
        return nodeSwitch(source.parent.type, source.parent, lastKey, pushResult)
    end)
    : case 'getfield'
    : case 'setfield'
    : case 'getmethod'
    : case 'setmethod'
    : case 'getindex'
    : case 'setindex'
    : call(function (source, lastKey, pushResult)
        local parentNode = vm.compileNode(source.node)
        local uri = guide.getUri(source)
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        if lastKey then
            key = key .. vm.ID_SPLITE .. lastKey
        end
        for pn in parentNode:eachObject() do
            searchFieldSwitch(pn.type, uri, pn, key, pushResult)
        end
        return key, source.node
    end)
    : case 'tableindex'
    : case 'tablefield'
    : call(function (source, lastKey, pushResult)
        if lastKey then
            return
        end
        local key = guide.getKeyName(source)
        if type(key) ~= 'string' then
            return
        end
        local uri = guide.getUri(source)
        local parentNode = vm.compileNode(source.node)
        for pn in parentNode:eachObject() do
            searchFieldSwitch(pn.type, uri, pn, key, pushResult)
        end
    end)
    : case 'doc.see.field'
    : call(function (source, lastKey, pushResult)
        if lastKey then
            return
        end
        local parentNode = vm.compileNode(source.parent.name)
        local uri = guide.getUri(source)
        for pn in parentNode:eachObject() do
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
    local idSources = vm.getLocalSourcesSets(source)
    if not idSources then
        return
    end
    for _, src in ipairs(idSources) do
        pushResult(src)
    end
end

---@param source  parser.object
---@param pushResult fun(src: parser.object)
local function searchByParentNode(source, pushResult)
    local lastKey
    local src = source
    while true do
        local key, node = nodeSwitch(src.type, src, lastKey, pushResult)
        if not key then
            break
        end
        src = node
        if lastKey then
            lastKey = key .. vm.ID_SPLITE .. lastKey
        else
            lastKey = key
        end
    end
end

local function searchByNode(source, pushResult)
    local node = vm.compileNode(source)
    local suri = guide.getUri(source)
    for n in node:eachObject() do
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
        if src.type == 'local' then
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
