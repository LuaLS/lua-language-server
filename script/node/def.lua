---@class Node.Def: Node
---@overload fun(name: string): Node.Def
local M = ls.node.register('Node.Def', {
    supportUnion = false,
})

M.kind = 'def'

---@param name string
function M:__init(name)
    self.name = name
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
        return 'class ' .. self.name
    end
    if self:isAlias() then
        return 'alias ' .. self.name
    end
    if self:isEnum() then
        return 'enum ' .. self.name
    end
    return self.name
end

---@param name string
---@return Node.Def
function ls.node.def(name)
    return New 'Node.Def' (name)
end
