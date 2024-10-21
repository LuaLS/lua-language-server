---@alias Node.Unsolve.Callback fun(Node.Unsolve): Node

---@class Node.Unsolve: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, baseNode: Node, onResolve: Node.Unsolve.Callback): Node.Unsolve
local M = ls.node.register 'Node.Unsolve'

M.kind = 'unsolve'

---@param scope Scope
---@param baseNode Node
---@param onResolve Node.Unsolve.Callback
function M:__init(scope, baseNode, onResolve)
    self.scope = scope
    self.baseNode = baseNode
    self.onResolve = onResolve
end

---@param self Node.Unsolve
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = self.baseNode
    local value = self:onResolve()
    return value, true
end