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

ls.node.registerView('value', function (viewer, node, needParentheses)
    ---@cast node Node.Value
    if node.typeName == 'string' then
        return ls.util.viewString(node.literal, node.quo)
    else
        return ls.util.viewLiteral(node.literal) or ''
    end
end)

ls.node.registerViewAsKey('value', function (viewer, node)
    ---@cast node Node.Value
    local literal = node.literal
    if type(literal) == 'string' and literal:match '^[%a_][%w_]*$' then
        return literal
    else
        return '[' .. viewer:view(node) .. ']'
    end
end)
