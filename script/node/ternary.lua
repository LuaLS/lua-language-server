---@class Node.Ternary: Node
---@field cond Node
---@field thenNode Node
---@field elseNode Node
local M = ls.node.register 'Node.Ternary'

M.kind = 'ternary'

---@param scope Scope
---@param cond Node
---@param thenNode Node
---@param elseNode Node
function M:__init(scope, cond, thenNode, elseNode)
    self.scope    = scope
    self.cond     = cond
    self.thenNode = thenNode
    self.elseNode = elseNode
end

function M:simplify()
    if self.value == self then
        return self
    end
    return self.value:simplify()
end

---@param self Node.Ternary
---@return Node
---@return true
M.__getter.value = function (self)
    self.cond:addRef(self)
    self.thenNode:addRef(self)
    self.elseNode:addRef(self)

    local rt = self.scope.rt

    if self.cond.truly == rt.NEVER then
        return self.elseNode, true
    end
    if self.cond.falsy == rt.NEVER then
        return self.thenNode, true
    end

    return self.thenNode | self.elseNode, true
end
