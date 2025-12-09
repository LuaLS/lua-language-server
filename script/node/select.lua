---@class Node.Select: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, head: Node, key: Node.Key): Node.Select
local M = ls.node.register 'Node.Select'

M.kind = 'select'

---@param scope Scope
---@param head Node
---@param key Node.Key
---@param rest? boolean
function M:__init(scope, head, key, rest)
    self.scope = scope
    self.head  = head
    if type(key) ~= 'table' then
        ---@cast key -Node
        key = scope.rt.value(key)
    end
    ---@type Node
    self.key   = key
    self.rest  = rest
end

---@param self Node.Select
---@return Node
---@return true
M.__getter.value = function (self)
    self.head:addRef(self)
    self.key:addRef(self)
    if not self.rest then
        return self.head:select(self.key), true
    end
    local list = self.head:simplify()
    if list.kind ~= 'list' then
        return self.head:select(self.key), true
    end
    ---@cast list Node.List
    local n = self.key:simplify()
    if n.kind ~= 'value' then
        return self.head:select(self.key), true
    end
    local literal = n.literal
    if math.type(literal) ~= 'integer' or literal < 1 then
        return self.head:select(self.key), true
    end
    ---@cast literal integer
    return list:slice(literal), true
end

function M:simplify()
    if self.value == self then
        return self
    end
    return self.value:simplify()
end

---@param self Node.Select
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    self.head:addRef(self)
    self.key:addRef(self)
    return self.head.hasGeneric or self.key.hasGeneric, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local head = self.head:resolveGeneric(map)
    local key  = self.key:resolveGeneric(map)
    if head == self.head and key == self.key then
        return self
    end
    return self.scope.rt.select(head, key)
end
