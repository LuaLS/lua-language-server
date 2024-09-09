---@class Node.Value: Node
---@operator bor(Node): Node
---@overload fun(v: string | number | boolean, quo?: '"' | "'" | '[['): Node.Value
local M = ls.node.register 'Node.Value'

M.cate = 'value'

---@param v string | number | boolean
---@param quo? '"' | "'" | '[['
function M:__init(v, quo)
    local tp = type(v)
    if tp ~= 'string' and tp ~= 'number' and tp ~= 'boolean' then
        error('Invalid value type: ' .. tp)
    end
    self.value = v
    ---@type 'string' | 'number' | 'boolean'
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.valueType = tp
    self.quo = quo
end

function M:view(skipLevel)
    if self.valueType == 'string' then
        return ls.util.viewString(self.value, self.quo)
    else
        return ls.util.viewLiteral(self.value)
    end
end

---@overload fun(v: number): Node.Value
---@overload fun(v: boolean): Node.Value
---@overload fun(v: string, quo?: '"' | "'" | '[['): Node.Value
function ls.node.value(...)
    return New 'Node.Value' (...)
end
