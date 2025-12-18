---@class Node.List: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, values?: Node[], min?: integer, max?: integer): Node.List
local M = ls.node.register 'Node.List'

M.kind = 'list'

---@type integer
M.min = 0

---@type integer | false
M.max = false

---@param scope Scope
---@param values? Node[]
---@param min? integer
---@param max? integer | false
function M:__init(scope, values, min, max)
    self.scope = scope
    self.raw = values
    self.min = min or (values and #values) or 0
    if max ~= false then
        self.max = max or (values and #values) or 0
    end
end

---@type Node[]
M.values = nil

---每一项的值，保证不会嵌套 List
---@param self Node.List
---@return Node[]
---@return true
M.__getter.values = function (self)
    if not self.raw then
        return {}, true
    end
    self.values = {}
    local values = {}
    for i, raw in ipairs(self.raw) do
        raw:addRef(self)
        local value = raw:findValue(ls.node.kind['list']) or raw
        if value.kind == 'list' then
            ---@cast value Node.List
            values[i] = value.values[1]
        else
            values[i] = raw
        end
    end
    local n = #values
    local last = self.raw[n]
    local lastValue = last and last:findValue(ls.node.kind['list']) or last
    if lastValue and lastValue.kind == 'list' then
        ---@cast lastValue Node.List
        for i = 1, #lastValue.values do
            values[n + i] = lastValue.values[i + 1]
        end
        if lastValue.min > 0 then
            self.min = self.min - 1 + lastValue.min
        elseif self.min == #values then
            self.min = self.min - 1
        end
        if lastValue.max then
            local max = n + lastValue.max - 1
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

---@param start integer
---@return Node.List
function M:slice(start)
    local values = {}
    if start <= #self.values then
        for i = start, #self.values do
            values[i - start + 1] = self.values[i]
        end
    else
        values[1] = self.values[#self.values]
    end
    local new = self.scope.rt.list(values
        , self.min - start + 1
        , self.max and (self.max - start + 1) or false
    )
    self:addRef(new)
    return new
end

---@param self Node.List
---@return Node
---@return true
M.__getter.value = function (self)
    return self:select(1), true
end

function M:simplify()
    if self.value == self then
        return self
    end
    return self.value:simplify()
end

---@param self Node.List
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    local hasGeneric = false
    if not self.raw then
        return false, true
    end
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
    return self.scope.rt.list(values, self.min, self.max)
end

---@param other Node.List
---@param result table<Node.Generic, Node>
function M:inferGeneric(other, result)
    if not self.hasGeneric then
        return
    end
    if other.kind ~= 'list' then
        return
    end
    local rt = self.scope.rt
    ---@cast other Node.List
    if self.max then
        for i = 1, self.max do
            local a = self:select(i)
            local b, e = other:select(i)
            if not e then
                a:inferGeneric(rt.UNKNOWN, result)
                break
            end
            a:inferGeneric(b, result)
        end
    else
        for i = 1, #self.values - 1 do
            local a = self:select(i)
            local b, e = other:select(i)
            if not e then
                a:inferGeneric(rt.UNKNOWN, result)
                break
            end
            a:inferGeneric(b, result)
        end
        local lastV = self.values[#self.values]
        local ovalues = {}
        for i = #self.values, #other.values do
            ovalues[#ovalues+1] = other:select(i)
        end
        ---@type Node
        local onode = rt.UNKNOWN
        if #ovalues > 0 then
            onode = rt.union(ovalues)
        end
        lastV:inferGeneric(onode, result)
    end
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    if other.kind ~= 'list' then
        return self.value:onCanCast(other)
    end
    ---@cast other Node.List

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
        return false
    end

    -- 逐个对比(允许我的参数比对方多)
    for i = 1, math.max(#values, #ovalues) do
        if not isMatch(i) then
            return false
        end
    end

    return true
end

function M:onViewAsList(viewer, options)
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
        buf[#buf+1] = '...(+{})...' % { #values - maxLen + 1 }
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
        if #buf > 1 then
            view = '({})' % { view }
        end
    end

    return view
end
