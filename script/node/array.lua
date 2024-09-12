---@class Node.Array: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(value: Node): Node.Array
local M = ls.node.register 'Node.Array'

M.kind = 'array'

---@param value Node
function M:__init(value)
    self.value = value
end

function M:view(skipLevel)
    return self.value:view(skipLevel) .. '[]'
end

---@param value Node
---@return Node.Array
function ls.node.array(value)
    return New 'Node.Array' (value)
end
