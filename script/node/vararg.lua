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
    self.raw = values
    self.min = min or (values and #values) or 0
    self.max = max
end

---@type Node[]
M.values = nil

---@param self Node.Vararg
---@return Node[]
---@return true
M.__getter.values = function (self)
    if not self.raw then
        return {}, true
    end
    local values = {}
    for i, raw in ipairs(self.raw) do
        raw:addRef(self)
        if raw.kind == 'vararg' then
            ---@cast raw Node.Vararg
            values[i] = raw.values[1]
        else
            values[i] = raw
        end
    end
    local n = #values
    local last = self.raw[n]
    if last and last.kind == 'vararg' then
        ---@cast last Node.Vararg
        for i = 1, #last.values do
            values[n + i] = last.values[i + 1]
        end
        if last.min > 0 then
            self.min = self.min - 1 + last.min
        elseif self.min == #values then
            self.min = self.min - 1
        end
        if last.max then
            local max = n + last.max - 1
            if not self.max then
                self.max = max
            elseif max > self.max then
                self.max = max
            end
        else
            self.max = nil
        end
    end
    return values, true
end

---@type Node.Value[]
M.keys = nil

---@param key Node.Key
---@return Node
---@return boolean exists
function M:select(key)
    if type(key) ~= 'table' then
        if math.type(key) ~= 'integer'
        or (self.max and self.max < key) then
            return self.scope.rt.NIL, false
        end
        local v = self.values[key]
            or self.values[#self.values]
            or self.scope.rt.NIL
        if key > self.min then
            return v | self.scope.rt.NIL, true
        end
        return v, true
    end
    local typeName = key.typeName
    if typeName == 'never'
    or typeName == 'nil' then
        return self.scope.rt.NEVER, false
    end
    if typeName == 'any'
    or typeName == 'unknown'
    or typeName == 'truly' then
        if #self.values == 0 then
            return self.scope.rt.NIL, false
        end
        return self.scope.rt.union(self.values), true
    end
    if key.kind == 'value' then
        return self:select(key.literal)
    end
    if key.typeName == 'number'
    or key.typeName == 'integer' then
        if #self.values == 0 then
            return self.scope.rt.NIL, false
        end
        return self.scope.rt.union(self.values), true
    end
    if key.kind == 'union' then
        ---@cast key Node.Union
        ---@type Node
        local result
        local existsOnce = false
        for _, v in ipairs(key.values) do
            local r, e = self:select(v)
            result = result | r
            if e then
                existsOnce = true
            end
        end
        return result or self.scope.rt.NIL, existsOnce
    end
    return self.scope.rt.NIL, false
end

---@return Node
---@return boolean exists
function M:getLastValue()
    if #self.values == 0 then
        return self.scope.rt.NIL, false
    end
    return self:select(#self.values)
end

---@param self Node.Vararg
---@return Node
---@return true
M.__getter.value = function (self)
    return self:select(1), true
end

---@param self Node.Vararg
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    local hasGeneric = false
    for _, v in ipairs(self.raw) do
        v:addRef(self)
        if v.hasGeneric then
            hasGeneric = true
        end
    end
    return hasGeneric, true
end

function M:resolveGeneric(map)
    if not self.hasGeneric then
        return self
    end
    local values = {}
    for i, value in ipairs(self.raw) do
        values[i] = value:resolveGeneric(map)
    end
    return self.scope.rt.vararg(values, self.min, self.max)
end

---@param other Node.Vararg
---@param result table<Node.Generic, Node>
function M:inferGeneric(other, result)
    if not self.hasGeneric then
        return
    end
    if other.kind ~= 'vararg' then
        return
    end
    ---@cast other Node.Vararg
    for i = 1, math.max(#self.values, #other.values) do
        local v = self:select(i)
        v:inferGeneric(other:select(i), result)
    end
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    if other.kind ~= 'vararg' then
        return self.value:onCanCast(other)
    end
    ---@cast other Node.Vararg

    local rt = self.scope.rt

    local lastValueB = other:getLastValue()

    -- 先快速检长度
    if self.min < other.min then
        if not rt.NIL:canCast(lastValueB) then
            return false
        end
    end

    local values = self.values
    local ovalues = other.values

    local function isMatch(i)
        -- 多余的参数，直接通过
        if other.max and i > other.max then
            return true
        end
        local a = self:select(i)
        local b = other:select(i)
        -- 类型匹配
        if a:canCast(b) then
            return true
        end
    end

    -- 逐个对比(允许我的参数比对方多)
    for i = 1, math.max(#values, #ovalues) do
        if not isMatch(i) then
            return false
        end
    end

    return true
end

function M:onViewAsVararg(viewer, options)
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
            buf[#buf+1] = viewer:view(v, {
                needParentheses = true,
            }) .. '?'
        else
            buf[#buf+1] = viewer:view(v)
        end
        if i == #values then
            return true
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
        elseif self.max > #values then
            tail = '...(+{})' % { self.max - #values }
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

    if options.needParentheses then
        view = '({})' % { view }
    end

    return view
end
