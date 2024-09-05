---@class Node.Union: Node
---@overload fun(...: Node): Node.Union
local M = Class 'Node.Union'

---@param ... Node
function M:__init(...)
    self.value = {...}
end

---@param ... Node
---@return Node.Union
function ls.node.union(...)
    return New 'Node.Union' (...)
end
