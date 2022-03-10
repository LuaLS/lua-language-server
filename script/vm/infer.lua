local util      = require 'utility'
local nodeMgr   = require 'vm.node'
local config    = require 'config'
local guide     = require 'parser.guide'

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
    : case 'doc.type.integer'
    : call(function (source, options)
        return ('%d'):format(source[1])
    end)
    : case 'doc.type.name'
    : call(function (source, options)
        return source[1]
    end)
    : case 'doc.type.array'
    : call(function (source, options)
        options['hasClass'] = true
        return m.viewType(source.node) .. '[]'
    end)
    : case 'doc.type.enum'
    : call(function (source, options)
        return ('%q'):format(source[1])
    end)
    : getMap()

---@param node vm.node
---@return string?
local function viewNode(node, options)
    if viewNodeMap[node.type] then
        return viewNodeMap[node.type](node, options)
    end
end

local function eraseAlias(node, viewMap, options)
    for n in nodeMgr.eachNode(node) do
        if n.type == 'global' and n.cate == 'type' then
            for _, set in ipairs(n:getSets()) do
                if set.type == 'doc.alias' then
                    if options['expandAlias'] then
                        viewMap[n.name] = nil
                    else
                        for _, ext in ipairs(set.extends.types) do
                            local view = viewNode(ext, {})
                            if view and view ~= n.name then
                                viewMap[view] = nil
                            end
                        end
                    end
                end
            end
        end
    end
end

---@param source parser.object
---@return table<string, boolean>
function m.getViews(source)
    local compiler = require 'vm.compiler'
    local node     = compiler.compileNode(source)
    if node.type == 'union' and node.lastViews then
        return node.lastViews
    end
    local views   = {}
    local options = {}
    options['expandAlias'] = config.get(guide.getUri(source), 'Lua.hover.expandAlias')
    if node.type == 'union' then
        node.lastViews = views
    end
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
    if options['hasClass'] then
        eraseAlias(node, views, options)
    end
    return views
end

---@param source parser.object
---@return string
function m.viewType(source)
    local views = m.getViews(source)
    if not next(views) then
        return 'unknown'
    end

    local array = {}
    for view in pairs(views) do
        array[#array+1] = view
    end

    table.sort(array, function (a, b)
        local sa = inferSorted[a] or 0
        local sb = inferSorted[b] or 0
        if sa == sb then
            return a < b
        end
        return sa < sb
    end)
    local view = table.concat(array, '|')

    return view
end

return m
