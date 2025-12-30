---@class Node.Field: Node
local M = ls.node.register 'Node.Field'

M.kind = 'field'

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
    self.value = value or scope.rt.UNKNOWN
    ---@type boolean?
    self.optional = optional
    if optional then
        self.value = self.value | scope.rt.NIL
    end
end

---@param location Node.Location
---@return Node.Field
function M:setLocation(location)
    ---@type Node.Location?
    self.location = location
    return self
end

---@return Node.Field
function M:setHideInView()
    ---@type boolean?
    self.hideInView = true
    return self
end

function M:simplify()
    return self.value:simplify()
end

---@param self Node.Field
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    self.key:addRef(self)
    self.value:addRef(self)
    return self.key.hasGeneric or self.value.hasGeneric, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local key = self.key:resolveGeneric(map)
    local value = self.value:resolveGeneric(map)
    local newField = self.scope.rt.field(key, value)
    newField.location = self.location
    newField.hideInView = self.hideInView
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
