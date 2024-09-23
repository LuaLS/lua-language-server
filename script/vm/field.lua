---@class vm
local vm        = require 'vm.vm'
local util      = require 'utility'
local guide     = require 'parser.guide'

local searchByNodeSwitch = util.switch()
    : case 'global'
    ---@param global vm.global
    : call(function (suri, global, pushResult)
        for _, set in ipairs(global:getSets(suri)) do
            pushResult(set)
        end
    end)
    : default(function (_suri, source, pushResult)
        pushResult(source)
    end)

local function searchByLocalID(source, pushResult)
    local fields = vm.getVariableFields(source, true)
    if fields then
        for _, field in ipairs(fields) do
            pushResult(field)
        end
    end
end

local function searchByNode(source, pushResult, mark)
    mark = mark or {}
    if mark[source] then
        return
    end
    mark[source] = true
    local uri = guide.getUri(source)
    vm.compileByParentNode(source, vm.ANY, function (field)
        searchByNodeSwitch(field.type, uri, field, pushResult)
    end)
    vm.compileByNodeChain(source, function (src)
        searchByNode(src, pushResult, mark)
    end)
end

---@param source parser.object
---@return       parser.object[]
function vm.getFields(source)
    local results = {}
    local mark    = {}

    local function pushResult(src)
        if not mark[src] then
            mark[src] = true
            results[#results+1] = src
        end
    end

    searchByLocalID(source, pushResult)
    searchByNode(source, pushResult)

    return results
end
