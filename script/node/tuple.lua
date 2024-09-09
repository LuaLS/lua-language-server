---@class Node.Tuple: Node
---@operator bor(Node?): Node
---@overload fun(values?: Node[]): Node.Tuple
local M = ls.node.register 'Node.Tuple'

M.kind = 'tuple'

---@param values? Node[]
function M:__init(values)
    self.values = values or {}
end

---@param value Node
---@return Node.Tuple
function M:insert(value)
    table.insert(self.values, value)
    return self
end

function M:view(skipLevel)
    local buf = {}
    for _, v in ipairs(self.values) do
        buf[#buf+1] = v:view(skipLevel and skipLevel + 1 or nil)
    end

    return '[' .. table.concat(buf, ', ') .. ']'
end

---@param values? Node[]
---@return Node.Tuple
function ls.node.tuple(values)
    return New 'Node.Tuple' (values)
end
