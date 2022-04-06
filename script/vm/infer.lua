local util     = require 'utility'
local nodeMgr  = require 'vm.node'
local config   = require 'config'
local guide    = require 'parser.guide'
local compiler = require 'vm.compiler'
local union    = require 'vm.union'

---@class vm.infer-manager
local m = {}

---@class vm.infer
---@field views table<string, boolean>
---@field cachedView? string
---@field node? vm.node
---@field uri? uri
local mt = {}
mt.__index = mt
mt._hasNumber      = false
mt._hasTable       = false
mt._hasClass       = false
mt._hasFunctionDef = false
mt._hasDocFunction = false
mt._isParam        = false
mt._isLocal        = false

m.NULL = setmetatable({}, mt)

local inferSorted = {
    ['boolean']  = - 100,
    ['string']   = - 99,
    ['number']   = - 98,
    ['integer']  = - 97,
    ['function'] = - 96,
    ['table']    = - 95,
    ['true']     = 1,
    ['false']    = 2,
    ['nil']      = 100,
}

local viewNodeSwitch = util.switch()
    : case 'nil'
    : case 'boolean'
    : case 'string'
    : case 'integer'
    : call(function (source, infer)
        return source.type
    end)
    : case 'number'
    : call(function (source, infer)
        infer._hasNumber = true
        return source.type
    end)
    : case 'table'
    : call(function (source, infer)
        if source.type == 'table' then
            if #source == 1 and source[1].type == 'varargs' then
                local node = m.getInfer(source[1]):view()
                return ('%s[]'):format(node)
            end
        end

        infer._hasTable = true
    end)
    : case 'function'
    : call(function (source, infer)
        local parent = source.parent
        if guide.isSet(parent) then
            infer._hasFunctionDef = true
        end
        return source.type
    end)
    : case 'local'
    : call(function (source, infer)
        if source.parent == 'funcargs' then
            infer._isParam = true
        else
            infer._isLocal = true
        end
    end)
    : case 'global'
    : call(function (source, infer)
        if source.cate == 'type' then
            infer._hasClass = true
            if source.name == 'number' then
                infer._hasNumber = true
            end
            return source.name
        end
    end)
    : case 'doc.type.name'
    : call(function (source, infer)
        infer._hasClass = true
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
    : case 'generic'
    : call(function (source, infer)
        return ('<%s>'):format(source.proto[1])
    end)
    : case 'doc.generic.name'
    : call(function (source, infer)
        return ('<%s>'):format(source[1])
    end)
    : case 'doc.type.array'
    : call(function (source, infer)
        infer._hasClass = true
        return m.getInfer(source.node):view() .. '[]'
    end)
    : case 'doc.type.table'
    : call(function (source, infer)
        infer._hasTable = true
    end)
    : case 'doc.type.string'
    : case 'doc.type.integer'
    : case 'doc.type.boolean'
    : call(function (source, infer)
        return ('%q'):format(source[1])
    end)
    : case 'doc.type.function'
    : call(function (source, infer)
        infer._hasDocFunction = true
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

---@param source parser.object
---@return vm.infer
function m.getInfer(source)
    local node = compiler.compileNode(source)
    if not node then
        return m.NULL
    end
    -- TODO: more cache?
    if node.type == 'union' and node.lastInfer then
        return node.lastInfer
    end
    local infer = setmetatable({
        node  = node,
        uri   = guide.getUri(source),
    }, mt)
    if node.type == 'union' then
        node.lastInfer = infer
    end

    return infer
end

function mt:_trim()
    if self._hasNumber then
        self.views['integer'] = nil
    end
    if self._hasDocFunction then
        if self._hasFunctionDef then
            for view in pairs(self.views) do
                if view:sub(1, 4) == 'fun(' then
                    self.views[view] = nil
                end
            end
        else
            self.views['function'] = nil
        end
    end
    if self._hasTable and not self._hasClass then
        self.views['table'] = true
    end
    if self._hasClass then
        self:_eraseAlias()
    end
end

function mt:_eraseAlias()
    local expandAlias = config.get(self.uri, 'Lua.hover.expandAlias')
    for n in nodeMgr.eachNode(self.node) do
        if n.type == 'global' and n.cate == 'type' then
            for _, set in ipairs(n:getSets()) do
                if set.type == 'doc.alias' then
                    if expandAlias then
                        self.views[n.name] = nil
                    else
                        for _, ext in ipairs(set.extends.types) do
                            local view = viewNodeSwitch(ext.type, ext, {})
                            if view and view ~= n.name then
                                self.views[view] = nil
                            end
                        end
                    end
                end
            end
        end
    end
end

---@param tp string
---@return boolean
function mt:hasType(tp)
    self:_computeViews()
    return self.views[tp] == true
end

---@return boolean
function mt:hasClass()
    self:_computeViews()
    return self._hasClass == true
end

---@return boolean
function mt:hasFunction()
    self:_computeViews()
    return self.views['function'] == true
        or self._hasDocFunction   == true
end

function mt:_computeViews()
    if self.views then
        return
    end

    self.views = {}

    for n in nodeMgr.eachNode(self.node) do
        local view = viewNodeSwitch(n.type, n, self)
        if view then
            self.views[view] = true
        end
    end

    self:_trim()
end

---@param default? string
---@param uri? uri
---@return string
function mt:view(default, uri)
    self:_computeViews()

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
    local limit = config.get(uri or self.uri, 'Lua.hover.enumsLimit')

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

---@param other vm.infer
---@return vm.infer
function mt:merge(other)
    if self == m.NULL then
        return other
    end
    if other == m.NULL then
        return self
    end

    local infer = setmetatable({
        node  = union(self.node, other.node),
        uri   = self.uri,
    }, mt)

    return infer
end

---@return string?
function mt:viewLiterals()
    if not self.node then
        return nil
    end
    local mark     = {}
    local literals = {}
    for n in nodeMgr.eachNode(self.node) do
        if n.type == 'string'
        or n.type == 'number'
        or n.type == 'integer'
        or n.type == 'boolean' then
            local literal = util.viewLiteral(n[1])
            if not mark[literal] then
                literals[#literals+1] = literal
                mark[literal] = true
            end
        end
    end
    if #literals == 0 then
        return nil
    end
    table.sort(literals)
    return table.concat(literals, '|')
end

---@return string?
function mt:viewClass()
    if not self.node then
        return nil
    end
    local mark  = {}
    local class = {}
    for n in nodeMgr.eachNode(self.node) do
        if n.type == 'global' and n.cate == 'type' then
            local name = n.name
            if not mark[name] then
                class[#class+1] = name
                mark[name] = true
            end
        end
    end
    if #class == 0 then
        return nil
    end
    table.sort(class)
    return table.concat(class, '|')
end

return m
