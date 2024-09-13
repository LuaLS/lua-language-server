---@class Node.Value: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(v: string | number | boolean, quo?: '"' | "'" | '[['): Node.Value
local M = ls.node.register 'Node.Value'

M.kind = 'value'

---@param v string | number | boolean
---@param quo? '"' | "'" | '[['
function M:__init(v, quo)
    local tp = type(v)
    if tp ~= 'string' and tp ~= 'number' and tp ~= 'boolean' then
        error('Invalid value type: ' .. tp)
    end
    ---@cast tp 'string' | 'number' | 'boolean'
    self.value = v
    ---@type 'string' | 'number' | 'integer' | 'boolean'
    self.typeName = tp
    if tp == 'number' and math.type(v) == 'integer' then
        self.typeName = 'integer'
    end
    self.quo = quo
end

function M:view(skipLevel)
    if self.typeName == 'string' then
        return ls.util.viewString(self.value, self.quo)
    else
        return ls.util.viewLiteral(self.value)
    end
end

function M:viewAsKey(skipLevel)
    if self.typeName == 'string' then
        return self.value
    else
        return '[' .. self:view(skipLevel) .. ']'
    end
end

function M:isMatch(other)
    if other.kind == 'value' then
        ---@cast other Node.Value
        return self.value == other.value
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
    return ls.node.type(self.typeName), true
end

---@type { [string | number | boolean]: Node.Value }
ls.node.VALUE = setmetatable({}, {
    __mode = 'v',
    __index = function (t, k)
        local v = New 'Node.Value' (k)
        t[k] = v
        return v
    end,
})

---@type { string: Node.Value }
ls.node.VALUE_STR2 = setmetatable({}, {
    __mode = 'v',
    __index = function (t, k)
        local v = New 'Node.Value' (k, "'")
        t[k] = v
        return v
    end,
})

---@type { string: Node.Value }
ls.node.VALUE_STR3 = setmetatable({}, {
    __mode = 'v',
    __index = function (t, k)
        local v = New 'Node.Value' (k, '[[')
        t[k] = v
        return v
    end,
})

---@overload fun(v: number): Node.Value
---@overload fun(v: boolean): Node.Value
---@overload fun(v: string, quo?: '"' | "'" | '[['): Node.Value
function ls.node.value(v, quo)
    if quo == "'" then
        return ls.node.VALUE_STR2[v]
    end
    if quo == '[[' then
        return ls.node.VALUE_STR3[v]
    end
    return ls.node.VALUE[v]
end
