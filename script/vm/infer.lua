local util    = require 'utility'
local nodeMgr = require 'vm.node'

---@class vm.infer-manager
local m = {}

local viewNodeMap = util.switch()
    : case 'boolean'
    : case 'string'
    : case 'table'
    : case 'function'
    : case 'number'
    : case 'integer'
    : call(function (source)
        return source.type
    end)
    : case 'global'
    : call(function (source)
        if source.cate == 'type' then
            return source.name
        end
    end)
    : getMap()

---@param node vm.node
---@return string?
local function viewNode(node)
    if viewNodeMap[node.type] then
        return viewNodeMap[node.type](node)
    end
end

---@param source parser.object
function m.viewType(source)
    local compiler = require 'vm.compiler'
    local node = compiler.compileNode(source)
    local views = {}
    for n in nodeMgr.eachNode(node) do
        local view = viewNode(n)
        if view then
            views[view] = true
        end
    end
    if views['number'] then
        views['integer'] = nil
    end
    local array = {}
    for view in pairs(views) do
        array[#array+1] = view
    end
    if #array == 0 then
        return 'unknown'
    end
    table.sort(array)
    return table.concat(array, '|')
end

return m
