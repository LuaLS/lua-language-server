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
    : case 'doc.field'
    : call(function (source, pushResult)
        pushResult(source)
    end)

---@param source  parser.object
---@param pushResult fun(src: parser.object)
local function searchBySimple(source, pushResult)
    simpleSwitch(source.type, source, pushResult)
end

---@param source  parser.object
---@param pushResult fun(src: parser.object)
local function searchByLocalID(source, pushResult)
    local idSources = vm.getVariableSets(source)
    if not idSources then
        return
    end
    for _, src in ipairs(idSources) do
        pushResult(src)
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
            if  source.type ~= 'local'
            and source.type ~= 'getlocal'
            and source.type ~= 'setlocal'
            and source.type ~= 'doc.cast.name' then
                return
            end
        end
        if not mark[src] then
            mark[src] = true
            if guide.isAssign(src)
            or guide.isLiteral(src) then
                results[#results+1] = src
            end
        end
    end

    searchBySimple(source, pushResult)
    searchByLocalID(source, pushResult)
    vm.compileByNodeChain(source, pushResult)
    searchByNode(source, pushResult)

    return results
end
