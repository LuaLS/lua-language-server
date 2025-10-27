---@class Node.Vararg: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, values?: Node[], min?: integer, max: integer): Node.Vararg
local M = ls.node.register 'Node.Vararg'

M.kind = 'vararg'

---@param scope Scope
---@param values? Node[]
---@param min? integer
---@param max? integer
function M:__init(scope, values, min, max)
    self.scope = scope
    self.values = values or {}
    self.min = min or #self.values
    self.max = max
end

---@type Node.Value[]
M.keys = nil

function M:get(key)
    if type(key) ~= 'table' then
        if math.type(key) ~= 'integer'
        or (self.min and self.min > key)
        or (self.max and self.max < key) then
            return self.scope.node.NIL
        end
        return self.values[key]
            or self.values[#self.values]
            or self.scope.node.ANY
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
        return self:get(key.literal)
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
    return false
end

---@param other Node
---@return boolean
function M:onCanCast(other)
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
    return self.scope.node.vararg(values)
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
    if #self.values == 0 then
        return '...'
    end
    for i, v in ipairs(self.values) do
        if self.min and i > self.min then
            break
        end
        buf[#buf+1] = viewer:view(v)
    end

    local view = table.concat(buf, ', ')

    if not self.max or self.max > #buf then
       view = view .. '...'
    end

    return view
end
