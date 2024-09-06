---@class Node.Number: Node
---@operator bor(Node): Node
---@overload fun(v: number): Node.Number
local M = Class('Node.Number', 'Node')

M.cate = 'literal'

M.__bor = ls.node.bor

---@param v number
function M:__init(v)
    self.value = v
end

function M:view(skipLevel)
    return ls.util.viewLiteral(self.value)
end

---@param v number
---@return Node.Number
function ls.node.number(v)
    return New 'Node.Number' (v)
end
