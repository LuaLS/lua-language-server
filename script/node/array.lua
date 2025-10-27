---@class Node.Array: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(value: Node): Node.Array
local M = ls.node.register 'Node.Array'

M.kind = 'array'

---@param scope Scope
---@param value Node
function M:__init(scope, value)
    self.scope = scope
    self.head = value
end

function M:get(key)
    if type(key) == 'table' then
        local typeName = key.typeName
        if typeName == 'never'
        or typeName == 'nil' then
            return key
        end
        if typeName == 'any'
        or typeName == 'unknown'
        or typeName == 'truly' then
            return self.head
        end
        if key.kind == 'value' then
            key = key.literal
        end
    end
    if type(key) ~= 'table' then
        if  type(key) == 'number'
        and key >= 1
        and key % 1 == 0 then
            return self.head
        else
            return self.scope.node.NIL
        end
    end
    if key.typeName == 'number'
    or key.typeName == 'integer' then
        return self.head
    end
    if key.kind == 'union' then
        ---@cast key Node.Union
        ---@type Node
        local result
        for _, v in ipairs(key.values) do
            local r = self:get(v)
            result = result | r
        end
        return result
    end
    return self.scope.node.NIL
end

---@param self Node.Array
---@return Node
---@return true
M.__getter.typeOfKey = function (self)
    return self.scope.node.INTEGER, true
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    if other.kind == 'array' then
        ---@cast other Node.Array
        return self.head:canCast(other.head)
    end
    return false
end

---@param self Node.Array
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    return self.head.hasGeneric, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local newHead = self.head:resolveGeneric(map)
    if newHead == self.head then
        return self
    end
    return self.scope.node.array(newHead)
end

function M:inferGeneric(other, result)
    if not self.hasGeneric then
        return
    end
    local value = other:get(self.scope.node.INTEGER)
    if value.typeName == 'never'
    or value.typeName == 'nil' then
        return
    end
    self.head:inferGeneric(value, result)
end

function M:onView(viewer, options)
    return viewer:format('%s[]', self.head, {
        needParentheses = true,
    })
end
