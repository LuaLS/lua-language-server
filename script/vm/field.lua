---@class vm
local vm        = require 'vm.vm'
local util      = require 'utility'
local compiler  = require 'vm.compiler'
local guide     = require 'parser.guide'
local localID   = require 'vm.local-id'
local globalMgr = require 'vm.global-manager'
local nodeMgr   = require 'vm.node'

local searchByNodeSwitch = util.switch()
    : case 'global'
    ---@param global vm.node.global
    : call(function (global, pushResult)
        for _, set in ipairs(global:getSets()) do
            pushResult(set)
        end
    end)
    : default(function (source, pushResult)
        pushResult(source)
    end)

local function searchByNode(source, pushResult)
    compiler.compileByParentNode(source, nil, function (field)
        searchByNodeSwitch(field.type, field, pushResult)
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
