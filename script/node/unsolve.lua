---@alias Node.Unsolve.Callback<T> fun(unsolve: Node.Unsolve, context: T): Node

---@class Node.Unsolve: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, baseNode: Node, context: any, onResolve: Node.Unsolve.Callback): Node.Unsolve
local M = ls.node.register 'Node.Unsolve'

M.kind = 'unsolve'

---@param scope Scope
---@param baseNode Node
---@param context any
---@param onResolve Node.Unsolve.Callback
function M:__init(scope, baseNode, context, onResolve)
    self.scope = scope
    self.baseNode = baseNode
    self.context = context
    self.onResolve = onResolve
end

---@param self Node.Unsolve
---@return Node
---@return true
M.__getter.solve = function (self)
    self.value = self.baseNode
    local value = self:onResolve(self.context)
    return value.solve, true
end

function M:view(skipLevel)
    local view = self.solve:view(skipLevel)
    return view
end
