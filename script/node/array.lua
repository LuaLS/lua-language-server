---@class Node.Array: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(value: Node): Node.Array
local M = ls.node.register 'Node.Array'

M.kind = 'array'

---@param value Node
function M:__init(value)
    self.head = value
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

function M:view(skipLevel)
    return self.head:view(skipLevel) .. '[]'
end

---@param value Node
---@return Node.Array
function ls.node.array(value)
    return New 'Node.Array' (value)
end
