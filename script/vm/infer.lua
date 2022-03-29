local util     = require 'utility'
local nodeMgr  = require 'vm.node'
local config   = require 'config'
local guide    = require 'parser.guide'
local compiler = require 'vm.compiler'

---@class vm.infer-manager
local m = {}

local inferSorted = {
    ['boolean']  = - 100,
    ['string']   = - 99,
    ['number']   = - 98,
    ['integer']  = - 97,
    ['function'] = - 96,
    ['table']    = - 95,
    ['nil']      = 100,
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
    : case 'local'
    : call(function (source, options)
        if source.parent == 'funcargs' then
            options['isParam'] = true
        else
            options['isLocal'] = true
        end
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
        options['hasClass'] = true
        if source.signs then
            local buf = {}
            for i, sign in ipairs(source.signs) do
                buf[i] = m.viewType(sign)
            end
            return ('%s<%s>'):format(source[1], table.concat(buf, ', '))
        else
            return source[1]
        end
    end)
    : case 'doc.generic.name'
    : call(function (source, options)
        return ('<%s>'):format(source[1])
    end)
    : case 'doc.type.array'
    : call(function (source, options)
        options['hasClass'] = true
        return m.viewType(source.node) .. '[]'
    end)
    : case 'doc.type.table'
    : call(function (source, options)
        options['hasTable'] = true
    end)
    : case 'doc.type.enum'
    : call(function (source, options)
        return ('%q'):format(source[1])
    end)
    : case 'doc.type.function'
    : call(function (source, options)
        options['hasDocFunction'] = true
        local args = {}
        local rets = {}
        local argView = ''
        local regView = ''
        for i, arg in ipairs(source.args) do
            args[i] = string.format('%s%s: %s'
                , arg.name[1]
                , arg.optional and '?' or ''
                , m.viewType(arg)
            )
        end
        if #args > 0 then
            argView = table.concat(args, ', ')
        end
        for i, ret in ipairs(source.returns) do
            rets[i] = string.format('%s%s'
                , m.viewType(ret)
                , ret.optional and '?' or ''
            )
        end
        if #rets > 0 then
            regView = ':' .. table.concat(rets, ', ')
        end
        return ('fun(%s)%s'):format(argView, regView)
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
---@return table<string, boolean>
function m.getViews(source)
    local node = compiler.compileNode(source)
    if not node then
        return {}
    end
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
    if options['hasDocFunction'] then
        views['function'] = nil
    end
    if options['hasTable'] and not options['hasClass'] then
        views['table'] = true
    end
    if options['hasClass'] then
        eraseAlias(node, views, options)
    end
    return views, options
end

---@param source parser.object
---@param tp string
---@return boolean
function m.hasType(source, tp)
    local views = m.getViews(source)

    if views[source] then
        return true
    end

    return false
end

---@param source parser.object
---@return string
function m.viewType(source)
    local views = m.getViews(source)

    if views['any'] then
        return 'any'
    end

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

    local max   = #array
    local limit = config.get(guide.getUri(source), 'Lua.hover.enumsLimit')

    if max > limit then
        local view = string.format('%s...(+%d)'
            , table.concat(array, '|', 1, limit)
            , max - limit
        )

        return view
    else
        local view = table.concat(array, '|')

        return view
    end

end

---@param source parser.object
---@return string?
function m.viewLiterals(source)
    local node = compiler.compileNode(source)
    if not node then
        return nil
    end
    local literals = {}
    for n in nodeMgr.eachNode(node) do
        if n.type == 'string'
        or n.type == 'number' then
            literals[#literals+1] = util.viewLiteral(n)
        end
    end
    if #literals == 0 then
        return nil
    end
    table.sort(literals)
    return table.concat(literals, '|')
end

---@param source parser.object
---@return string?
function m.viewClass(source)
    local node = compiler.compileNode(source)
    if not node then
        return nil
    end
    local class = {}
    for n in nodeMgr.eachNode(node) do
        if n.type == 'global' and n.cate == 'type' then
            class[#class+1] = n.name
        end
    end
    if #class == 0 then
        return nil
    end
    table.sort(class)
    return table.concat(class, '|')
end

return m
