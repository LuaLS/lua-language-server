---@class Node.Tuple: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
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

---@type Node.Value[]
M.keys = nil

---@param self Node.Tuple
---@return Node.Value[]
---@return true
M.__getter.keys = function (self)
    local keys = {}
    for i = 1, #self.values do
        keys[i] = ls.node.value(i)
    end
    return keys, true
end

function M:get(key)
    if key == ls.node.NEVER then
        return ls.node.NEVER
    end
    if key == ls.node.ANY
    or key == ls.node.UNKNOWN
    or key == ls.node.TRULY then
        return ls.node.union(self.values):getValue(ls.node.NIL)
    end
    if key == ls.node.NIL then
        return ls.node.NIL
    end
    if type(key) ~= 'table' then
        return self.values[key]
            or ls.node.NIL
    end
    if key.kind == 'value' then
        return self.values[key.literal]
            or ls.node.NIL
    end
    if key.typeName == 'number'
    or key.typeName == 'integer' then
        return ls.node.union(self.values):getValue(ls.node.NIL)
    end
    if key.kind == 'union' then
        ---@cast key Node.Union
        ---@type Node
        local result
        for _, v in ipairs(key.values) do
            local r = self:get(v)
            result = result | r
        end
        return result
    end
    return ls.node.NIL
end

function M:view(skipLevel)
    local buf = {}
    for _, v in ipairs(self.values) do
        buf[#buf+1] = v:view(skipLevel and skipLevel + 1 or nil)
    end

    return '[' .. table.concat(buf, ', ') .. ']'
end

---@param other Node
---@return boolean
function M:onCanBeCast(other)
    if self == other then
        return true
    end
    for i, v in ipairs(self.values) do
        local value = other:get(i)
        if not value:canCast(v) then
            return false
        end
    end
    return true
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    if other.kind == 'array' then
        ---@cast other Node.Array
        for i, v in ipairs(self.values) do
            if i > other.len then
                break
            end
            if not v:canCast(other.head) then
                return false
            end
        end
        return true
    end
    return false
end

---@param self Node.Tuple
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    for _, v in ipairs(self.values) do
        if v.hasGeneric then
            return true, true
        end
    end
    return false, true
end

function M:resolveGeneric(pack, keepGeneric)
    if not self.hasGeneric then
        return self
    end
    local values = {}
    for i, value in ipairs(self.values) do
        if value.hasGeneric then
            values[i] = value:resolveGeneric(pack, keepGeneric)
        else
            values[i] = value
        end
    end
    return ls.node.tuple(values)
end


---@param values? Node[]
---@return Node.Tuple
function ls.node.tuple(values)
    return New 'Node.Tuple' (values)
end
