---@class Node.Type: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(name: string): Node.Type
local M = ls.node.register 'Node.Type'

M.kind = 'type'

---@param name string
function M:__init(name)
    self.typeName = name
end

---@param field Node.Field
---@return self
function M:addField(field)
    if not self.table then
        self.table = ls.node.table()
    end
    self.table:addField(field)
    return self
end

---@param field Node.Field
---@return self
function M:removeField(field)
    if not self.table then
        return self
    end
    self.table:removeField(field)
    return self
end

---@param extends Node
---@return self
function M:addExtends(extends)
    if not self.extends then
        self.extends = ls.linkedTable.create()
    end
    self.extends:pushTail(extends)

    self.fullExtends = nil
    return self
end

---@param extends Node
---@return self
function M:removeExtends(extends)
    if not self.extends then
        return self
    end
    self.extends:pop(extends)

    self.fullExtends = nil
    return self
end

---@type Node[]
M.fullExtends = nil

---@param self Node.Type
---@return Node[]
---@return true
M.__getter.fullExtends = function (self)
    local result = {}
    local mark = {}

    ---@param t Node.Type
    local function pushExtends(t)
        if not t.extends then
            return
        end
        ---@param v Node
        for v in t.extends:pairsFast() do
            if mark[v] then
                goto continue
            end
            mark[v] = true
            result[#result+1] = v
            if v.kind == 'type' then
                pushExtends(v)
            end
            ::continue::
        end
    end

    pushExtends(self)

    return result, true
end

---@private
M._asClass = 0

---@return GCNode
function M:asClass()
    self._asClass = self._asClass + 1
    return ls.gc.node(function ()
        self._asClass = self._asClass - 1
    end)
end

function M:isClass()
    return self._asClass > 0
end

---@private
M._asAlias = 0

---@return GCNode
function M:asAlias()
    self._asAlias = self._asAlias + 1
    return ls.gc.node(function ()
        self._asAlias = self._asAlias - 1
    end)
end

function M:isAlias()
    return self._asAlias > 0
end

---@private
M._asEnum = 0

---@return GCNode
function M:asEnum()
    self._asEnum = self._asEnum + 1
    return ls.gc.node(function ()
        self._asEnum = self._asEnum - 1
    end)
end

function M:isEnum()
    return self._asEnum > 0
end

function M:view()
    return self.typeName
end

---@type fun(self: Node.Type, other: Node): boolean?
M._onCanCast = nil

---@type fun(self: Node.Type, other: Node): boolean?
M._onCanBeCast = nil

---@overload fun(self, key: 'onCanCast', value: fun(self: Node.Type, other: Node): boolean?): Node.Type
---@overload fun(self, key: 'onCanBeCast', value: fun(self: Node.Type, other: Node): boolean?): Node.Type
function M:setConfig(key, value)
    self['_' .. key] = value
    return self
end

---@param other Node
---@return boolean?
function M:onCanBeCast(other)
    if other.kind == 'never' then
        return false
    end
    if self._onCanBeCast then
        ---@cast other Node.Type
        local res = self._onCanBeCast(self, other)
        if res ~= nil then
            return res
        end
    end
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    if other.kind == 'never' then
        return false
    end
    if self._onCanCast then
        local res = self._onCanCast(self, other)
        if res then
            return res
        end
    end
    if other.kind == 'type' then
        ---@cast other Node.Type
        if self.typeName == other.typeName then
            return true
        end
        for _, v in ipairs(self.fullExtends) do
            if v.kind == 'type' then
                ---@cast v Node.Type
                if v.typeName == other.typeName then
                    return true
                end
                if v._onCanCast then
                    local res = v._onCanCast(v, other)
                    if res then
                        return res
                    end
                end
            end
        end
    end
    return false
end

---@type { never: nil, [string]: Node.Type}
ls.node.TYPE = setmetatable({}, {
    __mode = 'v',
    __index = function (t, k)
        local v
        if k == 'never' then
            error('Can not use "never" as a type name.')
        else
            v = New 'Node.Type' (k)
        end
        t[k] = v
        return v
    end,
})

---@overload fun(name: 'never'): Node
---@overload fun(name: string): Node.Type
function ls.node.type(name)
    return ls.node.TYPE[name]
end
