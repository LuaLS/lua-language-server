---@class vm
local vm        = require 'vm.vm'
local util      = require 'utility'
local compiler  = require 'vm.compiler'
local guide     = require 'parser.guide'

local searchByNodeSwitch = util.switch()
    : case 'global'
    ---@param global vm.global
    : call(function (suri, global, pushResult)
        for _, set in ipairs(global:getSets(suri)) do
            pushResult(set)
        end
    end)
    : default(function (suri, source, pushResult)
        pushResult(source)
    end)

local function searchByNode(source, pushResult)
    local uri = guide.getUri(source)
    compiler.compileByParentNode(source, nil, function (field)
        searchByNodeSwitch(field.type, uri, field, pushResult)
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

    searchByNode(source, pushResult)

    return results
end
