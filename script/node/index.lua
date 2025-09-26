---@class Node.Index: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, head: Node, index: Node): Node.Index
local M = ls.node.register 'Node.Index'

M.kind = 'index'

---@param scope Scope
---@param head Node
---@param index Node
function M:__init(scope, head, index)
    self.scope = scope
    self.head  = head
    self.index = index
end

---@param self Node.Index
---@return Node
---@return true
M.__getter.value = function (self)
    return self.head:get(self.index), true
end

---@param self Node.Index
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    return self.head.hasGeneric or self.index.hasGeneric, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local head = self.head:resolveGeneric(map)
    local index = self.index:resolveGeneric(map)
    if head == self.head and index == self.index then
        return self
    end
    return self.scope.node.index(head, index)
end

function M:view(skipLevel)
    return string.format('%s[%s]', self.head:view(skipLevel), self.index:view(skipLevel and skipLevel + 1 or nil))
end
