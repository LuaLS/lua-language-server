---@class Node.Tuple: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, values?: Node[]): Node.Tuple
local M = ls.node.register 'Node.Tuple'

M.kind = 'tuple'

---@type Node[]?
M.raw = nil

---@type Node.List?
M.list = nil

---@param scope Scope
---@param values? Node[] | Node.List
function M:__init(scope, values)
    self.scope = scope
    if values and values.kind == 'list' then
        ---@cast values Node.List
        self.list = values
    else
        ---@cast values Node[]
        self.raw = values
    end
end

---@param value Node
---@return Node.Tuple
function M:insert(value)
    if self.list then
        error('Cannot insert into a static tuple')
    end
    if not self.raw then
        self.raw = {}
    end
    table.insert(self.raw, value)
    self:flushCache()
    return self
end

---@type Node.List
M.values = nil

---@param self Node.Tuple
---@return Node.List
---@return true
M.__getter.values = function (self)
    local rt = self.scope.rt
    if self.list then
        return self.list, true
    end
    if self.raw then
        for _, raw in ipairs(self.raw) do
            raw:addRef(self)
        end
        return rt.list(self.raw), true
    end
    return rt.list(), true
end

---@type Node.Value[]
M.keys = nil

---@param self Node.Tuple
---@return Node.Value[]
---@return true
M.__getter.keys = function (self)
    local keys = {}
    local rt = self.scope.rt
    local max = self.values.max
    for i = 1, math.min(max or 1000, 1000) do
        keys[i] = rt.value(i)
    end
    return keys, true
end

---@param self Node.Tuple
---@return Node
---@return true
M.__getter.typeOfKey = function (self)
    local max = self.values.max
    if not max or max > 1000 then
        return self.scope.rt.INTEGER, true
    end
    return self.scope.rt.union(self.keys), true
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:get(key)
    return self.values:select(key)
end

function M:keyOf(value)
    local rt = self.scope.rt
    local max = self.values.max
    if not max or max > 1000 then
        return rt.INTEGER, true
    end
    local results = {}
    for i, v in ipairs(self.values.values) do
        if v >> value or value >> v then
            results[#results+1] = rt.value(i)
        end
    end
    return rt.union(results)
end

---@param other Node
---@return boolean?
function M:onCanBeCast(other)
    if self == other then
        return true
    end
    if other.kind == 'tuple' then
        ---@cast other Node.Tuple
        return other.values:canCast(self.values)
    end
    if other.kind == 'array' then
        ---@cast other Node.Array
        -- 数组转元组特殊处理，可以无视元组的长度
        for _, v in ipairs(self.values.values) do
            if not other.head:canCast(v) then
                return false
            end
        end
        return true
    end
    -- 无穷多的值肯定不能被有限的值转换。
    if not self.values.max then
        return false
    end
    for i = 1, math.min(100, self.values.max) do
        local v = self.values:select(i)
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
        local arrayVararg = self.scope.rt.list({ other.head }, 0, false)
        return self.values:canCast(arrayVararg)
    end
    return false
end

---@param self Node.Tuple
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    return self.values.hasGeneric, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local values = self.values:resolveGeneric(map)
    return self.scope.rt.tuple(values)
end

function M:inferGeneric(other, result)
    if not self.hasGeneric then
        return
    end
    for i, v in ipairs(self.values.values) do
        v:inferGeneric(other:get(i), result)
    end
end

function M:onView(viewer, options)
    return '[' .. viewer:viewAsList(self.values) .. ']'
end
