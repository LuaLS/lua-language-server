---@class Node.Value: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(v: string | number | boolean, quo?: '"' | "'" | '[['): Node.Value
local M = ls.node.register 'Node.Value'

M.kind = 'value'

---@param scope Scope
---@param v string | number | boolean
---@param quo? '"' | "'" | '[['
function M:__init(scope, v, quo)
    local tp = type(v)
    if tp ~= 'string' and tp ~= 'number' and tp ~= 'boolean' then
        error('Invalid value type: ' .. tp)
    end
    ---@cast tp 'string' | 'number' | 'boolean'
    self.literal = v
    ---@type 'string' | 'number' | 'integer' | 'boolean'
    self.typeName = tp
    if tp == 'number' and math.type(v) == 'integer' then
        self.typeName = 'integer'
    end
    self.quo = quo
    self.scope = scope
end

function M:onCanCast(other)
    if other.kind == 'value' then
        ---@cast other Node.Value
        return self.literal == other.literal
    end
    if other.kind == 'type' then
        ---@cast other Node.Type
        return self.nodeType:canCast(other)
    end
    return false
end

---@type Node.Type
M.nodeType = nil
M.__getter.nodeType = function (self)
    return self.scope.node.type(self.typeName), true
end

function M:onView(viewer, needParentheses)
    if self.typeName == 'string' then
        return ls.util.viewString(self.literal, self.quo)
    else
        return ls.util.viewLiteral(self.literal) or ''
    end
end

function M:onViewAsKey(viewer)
    local literal = self.literal
    if type(literal) == 'string' and literal:match '^[%a_][%w_]*$' then
        return literal
    else
        return '[' .. viewer:view(self) .. ']'
    end
end
