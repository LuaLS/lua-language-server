---@class Node.Vararg: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, values?: Node[], min?: integer, max: integer): Node.Vararg
local M = ls.node.register 'Node.Vararg'

M.kind = 'vararg'

---@type integer
M.min = 0

---@type integer?
M.max = nil

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
        or (self.max and self.max < key) then
            return self.scope.node.NIL
        end
        local v = self.values[key]
            or self.values[#self.values]
            or self.scope.node.ANY
        if key > self.min then
            return v | self.scope.node.NIL
        end
        return v
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

---@return Node
function M:getLastValue()
    if #self.values == 0 then
        return self.scope.node.NIL
    end
    return self:get(#self.values)
end

---@param self Node.Vararg
---@return Node
---@return true
M.__getter.value = function (self)
    return self:get(1), true
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
    local values = self.values
    if #values == 0 then
        return 'nil'
    end
    local maxLen = 8
    local buf = {}

    local function push(i)
        local v = values[i]
        if self.max then
            if i > self.max then
                return true
            end
            if not v then
                v = values[#values]
            end
        else
            if not v then
                return true
            end
        end
        if i > self.min then
            buf[#buf+1] = viewer:view(v, 1, true) .. '?'
        else
            buf[#buf+1] = viewer:view(v)
        end
    end

    local tail
    if #values <= maxLen then
        for i = 1, maxLen do
            if push(i) then
                break
            end
        end

        if not self.max then
            tail = '...'
        elseif self.max > maxLen then
            tail = '...(+{})' % { self.max - maxLen + 1 }
        end
    else
        for i = 1, maxLen // 2 do
            if push(i) then
                break
            end
        end
        buf[#buf+1] = '...(+{})' % { #values - maxLen + 1 }
        for i = #values - maxLen // 2 + 2, #values do
            if push(i) then
                break
            end
        end

        if not self.max then
            tail = '...'
        elseif self.max > #values then
            tail = '...(+{})' % { self.max - #values }
        end
    end

    local view = table.concat(buf, ', ')

    if tail then
        view = view .. tail
    end

    if needParentheses then
        view = '({})' % { view }
    end

    return view
end
