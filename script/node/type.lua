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

---@param extends Node.Type | Node.Table
---@return self
function M:addExtends(extends)
    if not self.extends then
        self.extends = ls.linkedTable.create()
    end
    self.extends:pushTail(extends)
    return self
end

---@param extends Node.Type | Node.Table
---@return self
function M:removeExtends(extends)
    if not self.extends then
        return self
    end
    self.extends:pop(extends)
    return self
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
    if self:isClass() then
        return 'class ' .. self.typeName
    end
    if self:isAlias() then
        return 'alias ' .. self.typeName
    end
    if self:isEnum() then
        return 'enum ' .. self.typeName
    end
    return self.typeName
end

function M:isMatch(other)
    if other.kind == 'type' then
        ---@cast other Node.Type
        return self.typeName == other.typeName
    end
    return false
end

---@type { never: Node, nil: Node.Nil, any: Node.Any, unknown: Node.Unknown, [string]: Node.Type}
ls.node.TYPE = setmetatable({}, {
    __mode = 'v',
    __index = function (t, k)
        local v
        if k == 'never' then
            v = ls.node.NEVER
        elseif k == 'nil' then
            v = ls.node.NIL
        elseif k == 'any' then
            v = ls.node.ANY
        elseif k == 'unknown' then
            v = ls.node.UNKNOWN
        else
            v = New 'Node.Type' (k)
        end
        t[k] = v
        return v
    end,
})

---@overload fun(name: 'never'): Node
---@overload fun(name: 'nil'): Node.Nil
---@overload fun(name: 'any'): Node.Any
---@overload fun(name: 'unknown'): Node.Unknown
---@overload fun(name: string): Node.Type
function ls.node.type(name)
    return ls.node.TYPE[name]
end
