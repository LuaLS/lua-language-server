---@class Node.Generic: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, name: string, extends?: Node, default?: Node): Node.Generic
local M = ls.node.register 'Node.Generic'

M.kind = 'generic'

M.hasGeneric = true

---@param scope Scope
---@param name string
---@param extends? Node
---@param default? Node
function M:__init(scope, name, extends, default)
    self.scope = scope
    self.name = name
    self.extends = extends or scope.node.ANY
    self.default = default
end

---@param self Node.Generic
---@return Node
---@return true
M.__getter.value = function (self)
    return self.default or self.extends, true
end

function M:resolveGeneric(map)
    return map[self] or self
end

function M:inferGeneric(other, result)
    if result[self] then
        return
    end
    result[self] = other
end

function M:onView(viewer, needParentheses)
    return '<' .. self.name .. '>'
end
