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
    : call(function (source, options)
        if source.type == 'number' then
            options['hasNumber'] = true
        end
        return source.type
    end)
    : case 'global'
    : call(function (source, options)
        if source.cate == 'type' then
            options['hasClass'] = true
            return source.name
        end
    end)
    : getMap()

---@param node vm.node
---@return string?
local function viewNode(node, options)
    if viewNodeMap[node.type] then
        return viewNodeMap[node.type](node, options)
    end
end

---@param source parser.object
function m.viewType(source)
    local compiler = require 'vm.compiler'
    local node     = compiler.compileNode(source)
    local views    = {}
    local options  = {}
    for n in nodeMgr.eachNode(node) do
        local view = viewNode(n, options)
        if view then
            views[view] = true
        end
    end
    if options['hasNumber'] then
        views['integer'] = nil
    end
    if options['hasClass'] then
        views['table'] = nil
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
