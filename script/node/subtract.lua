---@class Node.Subtract: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, a: Node, b: Node): Node.Subtract
local M = ls.node.register 'Node.Subtract'

M.kind = 'subtract'

---@param scope Scope
---@param a Node
---@param b Node
function M:__init(scope, a, b)
    self.scope = scope
    self.a = a
    self.b = b
end

---@type Node
M.value = nil

---@param self Node.Subtract
---@return Node
---@return true
M.__getter.value = function (self)
    local rt = self.scope.rt
    local a = self.a:simplify()
    local b = self.b:simplify()

    local members
    if a.kind == 'union' then
        ---@cast a Node.Union
        members = a.values
    else
        members = { a }
    end

    local remain = {}
    for _, m in ipairs(members) do
        if  m.kind == 'generic'
        or (m.kind == 'type' and (m.typeName == 'any' or m.typeName == 'unknown')) then
            remain[#remain+1] = m
        elseif not m:canCast(b) then
            remain[#remain+1] = m
        end
    end

    if #remain == 0 then
        return rt.NEVER, true
    end
    if #remain == 1 then
        return remain[1], true
    end
    return rt.union(remain), true
end

---@param self Node.Subtract
---@return string
---@return true
M.__getter.typeName = function (self)
    return self.value.typeName, true
end

---@param self Node.Subtract
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    return self.a.hasGeneric or self.b.hasGeneric, true
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    return self.value:canCast(other)
end

---@param other Node
---@return boolean
function M:onCanBeCast(other)
    return other:canCast(self.value)
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

function M:resolveGeneric(map, ctx)
    local newA = self.a:resolveGeneric(map, ctx)
    local newB = self.b:resolveGeneric(map, ctx)
    if newA == self.a and newB == self.b then
        return self
    end
    return self.scope.rt.subtract(newA, newB)
end

---@param key Node.Key
---@return Node
---@return boolean
function M:get(key)
    return self.value:get(key)
end

---@param key Node.Key
---@return Node
---@return boolean
function M:getExpect(key)
    return self.value:getExpect(key)
end

---@param key Node.Key
---@return Node
function M:select(key)
    return (self.value:select(key))
end
