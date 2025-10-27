---@class Node.Tuple: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, values?: Node[]): Node.Tuple
local M = ls.node.register 'Node.Tuple'

M.kind = 'tuple'

---@param scope Scope
---@param values? Node[]
function M:__init(scope, values)
    self.scope = scope
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
        keys[i] = self.scope.node.value(i)
    end
    return keys, true
end

---@param self Node.Tuple
---@return Node
---@return true
M.__getter.typeOfKey = function (self)
    return self.scope.node.union(self.keys), true
end

function M:get(key)
    if type(key) ~= 'table' then
        return self.values[key]
            or self.scope.node.NIL
    end
    local typeName = key.typeName
    if typeName == 'never'
    or typeName == 'nil' then
        return self.scope.node.NEVER
    end
    if typeName == 'any'
    or typeName == 'unknown'
    or typeName == 'truly' then
        if #self.values == 0 then
            return self.scope.node.NIL
        end
        return self.scope.node.union(self.values)
    end
    if key.kind == 'value' then
        return self.values[key.literal]
            or self.scope.node.NIL
    end
    if key.typeName == 'number'
    or key.typeName == 'integer' then
        if #self.values == 0 then
            return self.scope.node.NIL
        end
        return self.scope.node.union(self.values)
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
    return self.scope.node.NIL
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

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local values = {}
    for i, value in ipairs(self.values) do
        values[i] = value:resolveGeneric(map)
    end
    return self.scope.node.tuple(values)
end

function M:inferGeneric(other, result)
    if not self.hasGeneric then
        return
    end
    for i, v in ipairs(self.values) do
        v:inferGeneric(other:get(i), result)
    end
end

function M:onView(viewer, needParentheses)
    local buf = {}
    for _, v in ipairs(self.values) do
        buf[#buf+1] = viewer:view(v)
    end

    return '[' .. table.concat(buf, ', ') .. ']'
end
