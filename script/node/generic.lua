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
    ---@type Node
    self.extends = extends or scope.node.ANY
    self.default = default
end

---@param self Node.Generic
---@return Node
---@return true
M.__getter.value = function (self)
    return self.default or self.extends, true
end

function M:onCanBeCast(other)
    if self.extends.onCanBeCast then
        return self.extends:onCanBeCast(other)
    end
end

function M:onCanCast(other)
    if self.extends.onCanCast then
        return self.extends:onCanCast(other)
    end
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
