---@class Node.String: Node
---@operator bor(Node): Node
---@overload fun(v: string, quo?: '"' | "'" | string): Node.String
local M = Class('Node.String', 'Node')

M.cate = 'literal'

M.__bor = ls.node.bor

---@param v string
---@param quo? '"' | "'" | string
function M:__init(v, quo)
    self.value = v
    self.quo = quo
end

function M:view(skipLevel)
    return ls.util.viewString(self.value, self.quo)
end

---@param v string
---@param quo? '"' | "'" | string
---@return Node.String
function ls.node.string(v, quo)
    return New 'Node.String' (v, quo)
end
