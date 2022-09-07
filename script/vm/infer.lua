local util     = require 'utility'
local config   = require 'config'
local guide    = require 'parser.guide'
---@class vm
local vm       = require 'vm.vm'

---@class vm.infer
---@field views table<string, boolean>
---@field cachedView? string
---@field node? vm.node
---@field _drop table
local mt = {}
mt.__index = mt
mt._hasTable       = false
mt._hasClass       = false
mt._hasFunctionDef = false
mt._hasDocFunction = false
mt._isParam        = false
mt._isLocal        = false

vm.NULL = setmetatable({}, mt)

local LOCK = {}

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
        return source.type
    end)
    : case 'table'
    : call(function (source, infer, uri)
        if source.type == 'table' then
            if #source == 1 and source[1].type == 'varargs' then
                local node = vm.getInfer(source[1]):view(uri)
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
            if not guide.isBasicType(source.name) then
                infer._hasClass = true
            end
            return source.name
        end
    end)
    : case 'doc.type.name'
    : call(function (source, infer, uri)
        if source.signs then
            local buf = {}
            for i, sign in ipairs(source.signs) do
                buf[i] = vm.getInfer(sign):view(uri)
            end
            return ('%s<%s>'):format(source[1], table.concat(buf, ', '))
        else
            return source[1]
        end
    end)
    : case 'generic'
    : call(function (source, infer, uri)
        return vm.getInfer(source.proto):view(uri)
    end)
    : case 'doc.generic.name'
    : call(function (source, infer)
        return ('<%s>'):format(source[1])
    end)
    : case 'doc.type.array'
    : call(function (source, infer, uri)
        infer._hasClass = true
        local view = vm.getInfer(source.node):view(uri)
        if source.node.type == 'doc.type' then
            view = '(' .. view .. ')'
        end
        return view .. '[]'
    end)
    : case 'doc.type.sign'
    : call(function (source, infer, uri)
        infer._hasClass = true
        local buf = {}
        for i, sign in ipairs(source.signs) do
            buf[i] = vm.getInfer(sign):view(uri)
        end
        if infer._drop then
            local node = vm.compileNode(source)
            for c in node:eachObject() do
                if guide.isLiteral(c) then
                    infer._drop[c] = true
                end
            end
        end
        return ('%s<%s>'):format(source.node[1], table.concat(buf, ', '))
    end)
    : case 'doc.type.table'
    : call(function (source, infer, uri)
        if #source.fields == 0 then
            infer._hasTable = true
            return
        end
        if infer._drop and infer._drop[source] then
            infer._hasTable = true
            return
        end
        infer._hasClass = true
        local buf = {}
        buf[#buf+1] = '{ '
        for i, field in ipairs(source.fields) do
            if i > 1 then
                buf[#buf+1] = ', '
            end
            local key = field.name
            if key.type == 'doc.type' then
                buf[#buf+1] = ('[%s]: '):format(vm.getInfer(key):view(uri))
            elseif type(key[1]) == 'string' then
                buf[#buf+1] = key[1] .. ': '
            else
                buf[#buf+1] = ('[%q]: '):format(key[1])
            end
            buf[#buf+1] = vm.getInfer(field.extends):view(uri)
        end
        buf[#buf+1] = ' }'
        return table.concat(buf)
    end)
    : case 'doc.type.string'
    : call(function (source, infer)
        return util.viewString(source[1], source[2])
    end)
    : case 'doc.type.integer'
    : case 'doc.type.boolean'
    : call(function (source, infer)
        return ('%q'):format(source[1])
    end)
    : case 'doc.type.code'
    : call(function (source, infer)
        return ('`%s`'):format(source[1])
    end)
    : case 'doc.type.function'
    : call(function (source, infer, uri)
        infer._hasDocFunction = true
        local args = {}
        local rets = {}
        local argView = ''
        local regView = ''
        for i, arg in ipairs(source.args) do
            local argNode = vm.compileNode(arg)
            local isOptional = argNode:isOptional()
            if isOptional then
                argNode = argNode:copy()
                argNode:removeOptional()
            end
            args[i] = string.format('%s%s%s%s'
                , arg.name[1]
                , isOptional and '?' or ''
                , arg.name[1] == '...' and '' or ': '
                , vm.getInfer(argNode):view(uri)
            )
        end
        if #args > 0 then
            argView = table.concat(args, ', ')
        end
        local needReturnParen
        for i, ret in ipairs(source.returns) do
            local retType = vm.getInfer(ret):view(uri)
            if ret.name then
                if ret.name[1] == '...' then
                    rets[i] = ('%s%s'):format(ret.name[1], retType)
                else
                    needReturnParen = true
                    rets[i] = ('%s: %s'):format(ret.name[1], retType)
                end
            else
                rets[i] = retType
            end
        end
        if #rets > 0 then
            if needReturnParen then
                regView = (':(%s)'):format(table.concat(rets, ', '))
            else
                regView = (':%s'):format(table.concat(rets, ', '))
            end
        end
        return ('fun(%s)%s'):format(argView, regView)
    end)

---@class vm.node
---@field lastInfer? vm.infer

---@param source vm.object | vm.node
---@return vm.infer
function vm.getInfer(source)
    ---@type vm.node
    local node
    if source.type == 'vm.node' then
        ---@cast source vm.node
        node = source
    else
        ---@cast source vm.object
        node = vm.compileNode(source)
    end
    if node.lastInfer then
        return node.lastInfer
    end
    local infer = setmetatable({
        node  = node,
        _drop = {},
    }, mt)
    node.lastInfer = infer

    return infer
end

function mt:_trim()
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
    if self.views['number'] then
        self.views['integer'] = nil
    end
    if self.views['boolean'] then
        self.views['true'] = nil
        self.views['false'] = nil
    end
end

---@param uri uri
---@return table<string, true>
function mt:_eraseAlias(uri)
    local drop = {}
    local expandAlias = config.get(uri, 'Lua.hover.expandAlias')
    for n in self.node:eachObject() do
        if n.type == 'global' and n.cate == 'type' then
            if LOCK[n.name] then
                goto CONTINUE
            end
            LOCK[n.name] = true
            for _, set in ipairs(n:getSets(uri)) do
                if set.type == 'doc.alias' then
                    if expandAlias then
                        drop[n.name] = true
                        local newInfer = {}
                        for _, ext in ipairs(set.extends.types) do
                            viewNodeSwitch(ext.type, ext, newInfer, uri)
                        end
                        if newInfer._hasTable then
                            self.views['table'] = true
                        end
                    else
                        for _, ext in ipairs(set.extends.types) do
                            local view = viewNodeSwitch(ext.type, ext, {}, uri)
                            if view and view ~= n.name then
                                drop[view] = true
                            end
                        end
                    end
                end
            end
            LOCK[n.name] = nil
            ::CONTINUE::
        end
    end
    return drop
end

---@param uri uri
---@param tp string
---@return boolean
function mt:hasType(uri, tp)
    self:_computeViews(uri)
    return self.views[tp] == true
end

---@param uri uri
function mt:hasUnknown(uri)
    self:_computeViews(uri)
    return not next(self.views)
        or self.views['unknown'] == true
end

---@param uri uri
function mt:hasAny(uri)
    self:_computeViews(uri)
    return self.views['any'] == true
end

---@param uri uri
---@return boolean
function mt:hasClass(uri)
    self:_computeViews(uri)
    return self._hasClass == true
end

---@param uri uri
---@return boolean
function mt:hasFunction(uri)
    self:_computeViews(uri)
    return self.views['function'] == true
        or self._hasDocFunction   == true
end

---@param uri uri
function mt:_computeViews(uri)
    if self.views then
        return
    end

    self.views = {}

    for n in self.node:eachObject() do
        local view = viewNodeSwitch(n.type, n, self, uri)
        if view then
            self.views[view] = true
        end
    end

    self:_trim()
end

---@param uri uri
---@param default? string
---@return string
function mt:view(uri, default)
    self:_computeViews(uri)

    if self.views['any'] then
        return 'any'
    end

    local drop
    if self._hasClass then
        drop = self:_eraseAlias(uri)
    end

    local array = {}
    for view in pairs(self.views) do
        if not drop or not drop[view] then
            array[#array+1] = view
        end
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
    local limit = config.get(uri, 'Lua.hover.enumsLimit')

    local view
    if #array == 0 then
        view = default or 'unknown'
    else
        if max > limit then
            view = string.format('%s...(+%d)'
                , table.concat(array, '|', 1, limit)
                , max - limit
            )
        else
            view = table.concat(array, '|')
        end
    end

    if self.node:isOptional() then
        if max > 1 then
            view = '(' .. view .. ')?'
        else
            view = view .. '?'
        end
    end

    return view
end

---@param uri uri
function mt:eachView(uri)
    self:_computeViews(uri)
    return next, self.views
end

---@param other vm.infer
---@return vm.infer
function mt:merge(other)
    if self == vm.NULL then
        return other
    end
    if other == vm.NULL then
        return self
    end

    local infer = setmetatable({
        node  = vm.createNode(self.node, other.node),
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
    for n in self.node:eachObject() do
        if n.type == 'string'
        or n.type == 'number'
        or n.type == 'integer'
        or n.type == 'boolean' then
            local literal = util.viewLiteral(n[1])
            if literal and not mark[literal] then
                literals[#literals+1] = literal
                mark[literal] = true
            end
        end
    end
    if #literals == 0 then
        return nil
    end
    table.sort(literals, function (a, b)
        local sa = inferSorted[a] or 0
        local sb = inferSorted[b] or 0
        if sa == sb then
            return a < b
        end
        return sa < sb
    end)
    return table.concat(literals, '|')
end

---@return string?
function mt:viewClass()
    if not self.node then
        return nil
    end
    local mark  = {}
    local class = {}
    for n in self.node:eachObject() do
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

---@param source vm.node.object
---@param uri uri
---@return string?
function vm.viewObject(source, uri)
    return viewNodeSwitch(source.type, source, {}, uri)
end
