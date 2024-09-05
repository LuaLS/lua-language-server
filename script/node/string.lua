---@class Node.String: Node
---@overload fun(v: string): Node.String
local M = Class 'Node.String'

---@param v string
function M:__init(v)
    self.value = v
end

---@param v string
---@return Node.String
function ls.node.string(v)
    return New 'Node.String' (v)
end
