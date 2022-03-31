---@class vm
local vm        = require 'vm.vm'
local util      = require 'utility'
local compiler  = require 'vm.compiler'
local guide     = require 'parser.guide'
local localID   = require 'vm.local-id'
local globalMgr = require 'vm.global-manager'
local nodeMgr   = require 'vm.node'

local searchNodeSwitch = util.switch()
    : case 'table'
    : call(function (node, pushResult)
        for _, field in ipairs(node) do
            if field.type == 'tablefield'
            or field.type == 'tableindex' then
                pushResult(field)
            end
        end
    end)

local function searchByNode(source, pushResult)
    local node = compiler.compileNode(source)
    if not node then
        return
    end

    for n in nodeMgr.eachNode(node) do
        searchNodeSwitch(n.type, n, pushResult)
    end
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
