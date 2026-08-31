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

---@param visited? table<Node, true>
---@return Node
function M:simplify(visited)
    if self.value == self then
        return self
    end
    visited = visited or {}
    if visited[self] then
        return self
    end
    visited[self] = true
    return self.value:simplify(visited)
end

---@param self Node.Ternary
---@return Node
---@return true
M.__getter.value = function (self)
    self.cond:addRef(self)
    self.thenNode:addRef(self)
    self.elseNode:addRef(self)

    local rt = self.scope.rt

    if self.cond.truthy == rt.NEVER then
        return self.elseNode, true
    end
    if self.cond.falsy == rt.NEVER then
        return self.thenNode, true
    end

    return self.thenNode | self.elseNode, true
end

---@param self Node.Ternary
---@return string
---@return true
M.__getter.typeName = function (self)
    return self.value.typeName, true
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    return self.value:canCast(other)
end
