local util     = require 'utility'
local nodeMgr  = require 'vm.node'
local config   = require 'config'
local guide    = require 'parser.guide'
local compiler = require 'vm.compiler'

---@class vm.infer-manager
local m = {}

---@class vm.infer
---@field views table<string, boolean>
---@field source? parser.object
---@field cachedView? string
local mt = {}
mt.__index = mt
mt.hasNumber      = false
mt.hasTable       = false
mt.hasClass       = false
mt.isParam        = false
mt.isLocal        = false
mt.hasDocFunction = false
mt.expandAlias    = false

local nullInfer = setmetatable({ views = {} }, mt)

local inferSorted = {
    ['boolean']  = - 100,
    ['string']   = - 99,
    ['number']   = - 98,
    ['integer']  = - 97,
    ['function'] = - 96,
    ['table']    = - 95,
    ['nil']      = 100,
}

local viewNodeSwitch = util.switch()
    : case 'nil'
    : case 'boolean'
    : case 'string'
    : case 'function'
    : case 'integer'
    : call(function (source, infer)
        return source.type
    end)
    : case 'number'
    : call(function (source, infer)
        infer.hasNumber = true
        return source.type
    end)
    : case 'table'
    : call(function (source, infer)
        infer.hasTable = true
    end)
    : case 'local'
    : call(function (source, infer)
        if source.parent == 'funcargs' then
            infer.isParam = true
        else
            infer.isLocal = true
        end
    end)
    : case 'global'
    : call(function (source, infer)
        if source.cate == 'type' then
            infer.hasClass = true
            return source.name
        end
    end)
    : case 'doc.type.integer'
    : call(function (source, infer)
        return ('%d'):format(source[1])
    end)
    : case 'doc.type.name'
    : call(function (source, infer)
        infer.hasClass = true
        if source.signs then
            local buf = {}
            for i, sign in ipairs(source.signs) do
                buf[i] = m.getInfer(sign):view()
            end
            return ('%s<%s>'):format(source[1], table.concat(buf, ', '))
        else
            return source[1]
        end
    end)
    : case 'doc.generic.name'
    : call(function (source, infer)
        return ('<%s>'):format(source[1])
    end)
    : case 'doc.type.array'
    : call(function (source, infer)
        infer.hasClass = true
        return m.getInfer(source.node):view() .. '[]'
    end)
    : case 'doc.type.table'
    : call(function (source, infer)
        infer.hasTable = true
    end)
    : case 'doc.type.string'
    : call(function (source, infer)
        return ('%q'):format(source[1])
    end)
    : case 'doc.type.function'
    : call(function (source, infer)
        infer.hasDocFunction = true
        local args = {}
        local rets = {}
        local argView = ''
        local regView = ''
        for i, arg in ipairs(source.args) do
            args[i] = string.format('%s%s: %s'
                , arg.name[1]
                , arg.optional and '?' or ''
                , m.getInfer(arg):view()
            )
        end
        if #args > 0 then
            argView = table.concat(args, ', ')
        end
        for i, ret in ipairs(source.returns) do
            rets[i] = string.format('%s%s'
                , m.getInfer(ret):view()
                , ret.optional and '?' or ''
            )
        end
        if #rets > 0 then
            regView = ':' .. table.concat(rets, ', ')
        end
        return ('fun(%s)%s'):format(argView, regView)
    end)

---@param infer vm.infer
local function eraseAlias(infer)
    local node = compiler.compileNode(infer.source)
    for n in nodeMgr.eachNode(node) do
        if n.type == 'global' and n.cate == 'type' then
            for _, set in ipairs(n:getSets()) do
                if set.type == 'doc.alias' then
                    if infer.expandAlias then
                        infer.views[n.name] = nil
                    else
                        for _, ext in ipairs(set.extends.types) do
                            local view = viewNodeSwitch(ext.type, ext, {})
                            if view and view ~= n.name then
                                infer.views[view] = nil
                            end
                        end
                    end
                end
            end
        end
    end
end

---@param source parser.object
---@return vm.infer
function m.getInfer(source)
    local node = compiler.compileNode(source)
    if not node then
        return nullInfer
    end
    if node.type == 'union' and node.lastInfer then
        return node.lastInfer
    end
    local infer = setmetatable({
        source = source,
        views  = {}
    }, mt)
    infer.expandAlias = config.get(guide.getUri(source), 'Lua.hover.expandAlias')
    if node.type == 'union' then
        node.lastInfer = infer
    end
    for n in nodeMgr.eachNode(node) do
        local view = viewNodeSwitch(n.type, n, infer)
        if view then
            infer.views[view] = true
        end
    end
    if infer.hasNumber then
        infer.views['integer'] = nil
    end
    if infer.hasDocFunction then
        infer.views['function'] = nil
    end
    if infer.hasTable and not infer.hasClass then
        infer.views['table'] = true
    end
    if infer.hasClass then
        eraseAlias(infer)
    end
    return infer
end

---@param tp string
---@return boolean
function mt:hasType(tp)
    return self.views[tp] == true
end

---@param default? string
---@return string
function mt:view(default)
    if self.views['any'] then
        return 'any'
    end

    if not next(self.views) then
        return default or 'unknown'
    end

    if self.cachedView then
        return self.cachedView
    end

    local array = {}
    for view in pairs(self.views) do
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
    local limit = config.get(guide.getUri(self.source), 'Lua.hover.enumsLimit')

    if max > limit then
        local view = string.format('%s...(+%d)'
            , table.concat(array, '|', 1, limit)
            , max - limit
        )

        self.cachedView = view

        return view
    else
        local view = table.concat(array, '|')

        self.cachedView = view

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
        or n.type == 'number'
        or n.type == 'integer' then
            literals[#literals+1] = util.viewLiteral(n[1])
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
