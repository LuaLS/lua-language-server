---@class Node.Number: Node
---@overload fun(v: number): Node.Number
local M = Class 'Node.Number'

---@param v number
function M:__init(v)
    self.value = v
end

---@param v number
---@return Node.Number
function ls.node.number(v)
    return New 'Node.Number' (v)
end
