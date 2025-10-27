---@class Node.Tuple: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, values?: Node[]): Node.Tuple
local M = ls.node.register 'Node.Tuple'

M.kind = 'tuple'

---@type Node[]?
M.raw = nil

---@type Node.Vararg?
M.vararg = nil

---@param scope Scope
---@param values? Node[] | Node.Vararg
function M:__init(scope, values)
    self.scope = scope
    if values and values.kind == 'vararg' then
        ---@cast values Node.Vararg
        self.vararg = values
    else
        ---@cast values Node[]
        self.raw = values
    end
end

---@param value Node
---@return Node.Tuple
function M:insert(value)
    if self.vararg then
        error('Cannot insert into a static tuple')
    end
    if not self.raw then
        self.raw = {}
    end
    table.insert(self.raw, value)
    self:flushCache()
    return self
end

---@type Node.Vararg
M.values = nil

---@param self Node.Tuple
---@return Node.Vararg
---@return true
M.__getter.values = function (self)
    local node = self.scope.node
    if self.vararg then
        return self.vararg, true
    end
    return node.vararg(self.raw, #self.raw, #self.raw), true
end

---@type Node.Value[]
M.keys = nil

---@param self Node.Tuple
---@return Node.Value[]
---@return true
M.__getter.keys = function (self)
    local keys = {}
    local node = self.scope.node
    local max = self.values.max
    for i = 1, math.min(max or 1000, 1000) do
        keys[i] = node.value(i)
    end
    return keys, true
end

---@param self Node.Tuple
---@return Node
---@return true
M.__getter.typeOfKey = function (self)
    local max = self.values.max
    if not max or max > 1000 then
        return self.scope.node.INTEGER, true
    end
    return self.scope.node.union(self.keys), true
end

function M:get(key)
    return self.values:select(key)
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

function M:onView(viewer, options)
    return '[' .. viewer:viewAsVararg(self.values) .. ']'
end
