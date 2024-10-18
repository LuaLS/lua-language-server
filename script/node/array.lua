---@class Node.Array: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(value: Node, len?: integer): Node.Array
local M = ls.node.register 'Node.Array'

M.kind = 'array'

---@param value Node
---@param len? number
function M:__init(value, len)
    self.head = value
    self.len = len or math.huge
end

function M:get(key)
    if key == ls.node.NEVER then
        return ls.node.NEVER
    end
    if key == ls.node.ANY
    or key == ls.node.UNKNOWN
    or key == ls.node.TRULY then
        return self.head
    end
    if key == ls.node.NIL then
        return ls.node.NIL
    end
    if type(key) == 'table' and key.kind == 'value' then
        key = key.literal
    end
    if type(key) ~= 'table' then
        if  type(key) == 'number'
        and key >= 1
        and key <= self.len
        and key % 1 == 0 then
            return self.head
        else
            return ls.node.NIL
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
    return ls.node.NIL
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    if other.kind == 'array' then
        ---@cast other Node.Array
        if self.len < other.len then
            return false
        end
        return self.head:canCast(other.head)
    end
    return false
end

function M:view(skipLevel)
    return self.head:view(skipLevel) .. '[]'
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
    return ls.node.array(newHead, self.len)
end

function M:inferGeneric(other, map)
    if not self.hasGeneric then
        return
    end
    local value = other:get(ls.node.INTEGER)
    if value == ls.node.NEVER
    or value == ls.node.NIL then
        return
    end
    self.head:inferGeneric(value, map)
end

---@param value Node
---@param len? number
---@return Node.Array
function ls.node.array(value, len)
    return New 'Node.Array' (value, len)
end
