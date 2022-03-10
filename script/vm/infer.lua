local util    = require 'utility'
local nodeMgr = require 'vm.node'

---@class vm.infer-manager
local m = {}

local inferSorted = {
    ['nil'] = 100,
}

local viewNodeMap = util.switch()
    : case 'nil'
    : case 'boolean'
    : case 'string'
    : case 'function'
    : case 'integer'
    : call(function (source, options)
        return source.type
    end)
    : case 'number'
    : call(function (source, options)
        options['hasNumber'] = true
        return source.type
    end)
    : case 'table'
    : call(function (source, options)
        options['hasTable'] = true
    end)
    : case 'global'
    : call(function (source, options)
        if source.cate == 'type' then
            options['hasClass'] = true
            return source.name
        end
    end)
    : case 'doc.type.array'
    : call(function (source, options)
        options['hasClass'] = true
        return m.viewType(source.node) .. '[]'
    end)
    : case 'doc.type.enum'
    : call(function (source, options)
        return source[1]
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
    if options['hasTable'] and not options['hasClass'] then
        views['table'] = true
    end
    local array = {}
    for view in pairs(views) do
        array[#array+1] = view
    end
    if #array == 0 then
        return 'unknown'
    end
    table.sort(array, function (a, b)
        local sa = inferSorted[a] or 0
        local sb = inferSorted[b] or 0
        if sa == sb then
            return a < b
        end
        return sa < sb
    end)
    return table.concat(array, '|')
end

return m
