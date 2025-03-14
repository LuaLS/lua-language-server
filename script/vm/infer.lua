local util     = require 'utility'
local config   = require 'config'
local guide    = require 'parser.guide'
---@class vm
local vm       = require 'vm.vm'

---@class vm.infer
---@field node vm.node
---@field views table<string, boolean>
---@field _drop table
---@field _lastView? string
---@field _lastViewUri? uri
---@field _lastViewDefault? any
---@field _subViews? string[]
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

local viewNodeSwitch;viewNodeSwitch = util.switch()
    : case 'nil'
    : case 'boolean'
    : case 'string'
    : case 'integer'
    : call(function (source, _infer)
        return source.type
    end)
    : case 'number'
    : call(function (source, _infer)
        return source.type
    end)
    : case 'table'
    : call(function (source, infer, uri)
        local docs = source.bindDocs
        if docs then
            for _, doc in ipairs(docs) do
                if doc.type == 'doc.enum' then
                    return 'enum ' .. doc.enum[1]
                end
            end
        end

        if #source == 1 and source[1].type == 'varargs' then
            local node = vm.getInfer(source[1]):view(uri)
            return ('%s[]'):format(node)
        end

        infer._hasTable = true
    end)
    : case 'function'
    : call(function (source, infer)
        local parent = source.parent
        if guide.isAssign(parent) then
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
    : case 'doc.type'
    : call(function (source, infer, uri)
        local buf = {}
        for _, tp in ipairs(source.types) do
            buf[#buf+1] = viewNodeSwitch(tp.type, tp, infer, uri)
        end
        return table.concat(buf, '|')
    end)
    : case 'doc.type.name'
    : call(function (source, _infer, uri)
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
    : call(function (source, _infer, uri)
        return vm.getInfer(source.proto):view(uri)
    end)
    : case 'doc.generic.name'
    : call(function (source, _infer, uri)
        local resolved = vm.getGenericResolved(source)
        if resolved then
            return vm.getInfer(resolved):view(uri)
        end
        if source.generic and source.generic.extends then
            return ('<%s:%s>'):format(source[1], vm.getInfer(source.generic.extends):view(uri))
        else
            return ('<%s>'):format(source[1])
        end
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
        local node = vm.compileNode(source)
        for c in node:eachObject() do
            if guide.isLiteral(c) then
                ---@cast c parser.object
                local view = vm.getInfer(c):view(uri)
                if view then
                    infer._drop[view] = true
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
        infer._hasClass = true
        local buf = {}
        buf[#buf+1] = source.isTuple and '[' or '{ '
        for i, field in ipairs(source.fields) do
            if i > 1 then
                buf[#buf+1] = ', '
            end
            if not source.isTuple then
                local key = field.name
                if key.type == 'doc.type' then
                    buf[#buf+1] = ('[%s]: '):format(vm.getInfer(key):view(uri))
                elseif type(key[1]) == 'string' then
                    buf[#buf+1] = key[1] .. ': '
                else
                    buf[#buf+1] = ('[%q]: '):format(key[1])
                end
            end
            buf[#buf+1] = vm.getInfer(field.extends):view(uri)
        end
        buf[#buf+1] = source.isTuple and ']' or ' }'
        return table.concat(buf)
    end)
    : case 'doc.type.string'
    : call(function (source, _infer)
        return util.viewString(source[1], source[2])
    end)
    : case 'doc.type.integer'
    : case 'doc.type.boolean'
    : call(function (source, _infer)
        return ('%q'):format(source[1])
    end)
    : case 'doc.type.code'
    : call(function (source, _infer)
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
    : case 'doc.field.name'
    : call(function (source, _infer, uri)
        return vm.viewKey(source, uri)
    end)

---@param node? vm.node
---@return vm.infer
local function createInfer(node)
    local infer = setmetatable({
        node  = node,
        _drop = {},
    }, mt)
    return infer
end

---@param source vm.node.object | vm.node
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
    local infer = createInfer(node)
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
function mt:_eraseAlias(uri)
    local count = 0
    for _ in pairs(self.views) do
        count = count + 1
    end
    if count <= 1 then
        return
    end
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
                        self._drop[n.name] = true
                        local newInfer = createInfer()
                        for _, ext in ipairs(set.extends.types) do
                            viewNodeSwitch(ext.type, ext, newInfer, uri)
                        end
                        if newInfer._hasTable then
                            self.views['table'] = true
                        end
                    else
                        for _, ext in ipairs(set.extends.types) do
                            local view = viewNodeSwitch(ext.type, ext, createInfer(), uri)
                            if view and view ~= n.name then
                                self._drop[view] = true
                            end
                        end
                    end
                end
            end
            LOCK[n.name] = nil
            ::CONTINUE::
        end
    end
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
        if not n.hideView then
            local view = viewNodeSwitch(n.type, n, self, uri)
            if view then
                self.views[view] = true
            end
        end
    end

    self:_trim()
end

---@param uri uri
---@param default? string
---@return string
function mt:view(uri, default)
    if  self._lastView
    and self._lastViewUri == uri
    and self._lastViewDefault == default then
        return self._lastView
    end
    self._lastViewUri = uri
    self._lastViewDefault = default

    self:_computeViews(uri)

    if self.views['any'] then
        self._lastView = 'any'
        return 'any'
    end

    if self._hasClass then
        self:_eraseAlias(uri)
    end

    local array = {}
    self._subViews = array
    for view in pairs(self.views) do
        if not self._drop[view] then
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
        if #array == 0 then
            view = 'nil'
        else
            if max > 1
            or view:find(guide.notNamePattern .. guide.namePattern .. '$') then
                view = '(' .. view .. ')?'
            else
                view = view .. '?'
            end
        end
    end

    -- do not truncate if exporting doc
    if not DOC and #view > 200 then
        view = view:sub(1, 180) .. '...(too long)...' .. view:sub(-10)
    end

    self._lastView = view
    return view
end

---@param uri uri
function mt:eachView(uri)
    self:_computeViews(uri)
    return next, self.views
end

---@param uri uri
---@return string[]
function mt:getSubViews(uri)
    self:view(uri)
    return self._subViews
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
            local literal
            if n.type == 'string' then
                literal = util.viewString(n[1], n[2])
            else
                literal = util.viewLiteral(n[1])
            end
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
    local infer = createInfer()
    return viewNodeSwitch(source.type, source, infer, uri)
end

---@param source parser.object
---@param uri uri
---@return string?
---@return string|number|boolean|nil
function vm.viewKey(source, uri)
    if source.type == 'doc.type' then
        if #source.types == 1 then
            return vm.viewKey(source.types[1], uri)
        else
            local key = vm.getInfer(source):view(uri)
            return '[' .. key .. ']', key
        end
    end
    if source.type == 'tableindex'
    or source.type == 'setindex'
    or source.type == 'getindex' then
        local index = source.index
        local name = vm.getInfer(index):viewLiterals()
        if not name then
            return nil
        end
        return ('[%s]'):format(name), name
    end
    if source.type == 'tableexp' then
        return ('[%d]'):format(source.tindex), source.tindex
    end
    if source.type == 'doc.field' then
        return vm.viewKey(source.field, uri)
    end
    if source.type == 'doc.type.field' then
        return vm.viewKey(source.name, uri)
    end
    if source.type == 'doc.type.name' then
        return '[' .. source[1] .. ']', source[1]
    end
    if source.type == 'doc.type.string' then
        local name = util.viewString(source[1], source[2])
        return ('[%s]'):format(name), name
    end
    local key = vm.getKeyName(source)
    if key == nil then
        return nil
    end
    if type(key) == 'string' then
        return key, key
    else
        return ('[%s]'):format(key), key
    end
end
