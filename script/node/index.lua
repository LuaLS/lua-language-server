---@class Node.Index: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, head: Node, index: Node.Key): Node.Index
local M = ls.node.register 'Node.Index'

M.kind = 'index'

---@param scope Scope
---@param head Node
---@param index Node.Key
function M:__init(scope, head, index)
    self.scope = scope
    self.head  = head
    if type(index) ~= 'table' then
        ---@cast index -Node
        index = scope.rt.value(index)
    end
    self.index = index
end

---@param self Node.Index
---@return Node
---@return true
M.__getter.value = function (self)
    self.head:addRef(self)
    self.index:addRef(self)
    return self.head:get(self.index), true
end

---@param self Node.Index
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    self.head:addRef(self)
    self.index:addRef(self)
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
    return self.scope.rt.index(head, index)
end
