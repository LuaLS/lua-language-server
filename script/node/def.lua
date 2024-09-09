---@class Node.Def: Node
---@overload fun(name: string): Node.Def
local M = Class('Node.Def', 'Node')

M.kind = 'def'

---@param name string
function M:__init(name)
    self.name = name
end

---@param key Node.Value
---@param value Node
---@return GCNode
function M:insert(key, value)
    if not self.isClass then
        error('Node.Def:insert() only available for class')
    end
    if not self.fields then
        self.fields = {}
    end
    self.fields:insert(key, value)
    return ls.gc.node(function ()
        
    end)
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
