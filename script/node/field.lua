---@class Node.Field: Node
local M = ls.node.register 'Node.Field'

M.kind = 'field'
M.typeName = 'field'

---@param scope Scope
---@param key Node.Key
---@param value? Node
---@param optional? boolean
function M:__init(scope, key, value, optional)
    self.scope = scope
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = scope.rt.value(key)
    end
    ---@type Node
    self.key = key
    ---@type Node
    self.fvalue = value or scope.rt.UNKNOWN
    ---@type boolean?
    self.optional = optional
    if optional then
        self.fvalue = self.fvalue | scope.rt.NIL
    end
end

---@param location Node.Location
---@return Node.Field
function M:setLocation(location)
    ---@type Node.Location?
    self.location = location
    return self
end

---@param visibleType 'private' | 'public' | 'package' | 'protected'
---@return Node.Field
function M:setVisibleType(visibleType)
    ---@type string?
    self.visibleType = visibleType
    return self
end

---@return Node.Field
function M:setHideInView()
    ---@type boolean?
    self.hideInView = true
    return self
end

---@return Node.Field
function M:setBracketKey()
    ---@type boolean?
    self.bracketKey = true
    return self
end

---@param visited? table<Node, true>
---@return Node
function M:simplify(visited)
    if self.value == self then
        return self
    end
    visited = visited or {}
    if visited[self] then
        return self
    end
    visited[self] = true
    local result = self.value:simplify(visited)
    return result
end

M.__getter.value = function (self)
    return self.fvalue, true
end

---@param self Node.Field
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    self.hasGeneric = false
    self.key:addRef(self)
    self.value:addRef(self)
    return self.key.hasGeneric or self.value.hasGeneric, true
end

---@param map table<Node.Generic, Node>
---@param ctx? Node.ResolveContext
---@return Node
function M:resolveGeneric(map, ctx)
    if not self.hasGeneric then
        return self
    end
    ctx = ctx or ls.node.resolveContext()
    if ctx.visited[self] then
        return ctx.visited[self]
    end
    local key = self.key:resolveGeneric(map, ctx)
    local value = self.value:resolveGeneric(map, ctx)
    local newField = self.scope.rt.field(key, value)
    ctx.visited[self] = newField
    newField.location = self.location
    newField.hideInView = self.hideInView
    newField.visibleType = self.visibleType
    return newField
end

function M:onCanBeCast(other)
    return other:canCast(self.value)
end

function M:onCanCast(other)
    if self == other then
        return true
    end
    return self.value:canCast(other)
end
