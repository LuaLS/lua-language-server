---@class Node.Union: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, nodes?: Node[]): Node.Union
local M = ls.node.register 'Node.Union'

M.kind = 'union'
M.typeName = 'union'

---@param scope Scope
---@param nodes? Node[]
function M:__init(scope, nodes)
    self.scope = scope
    ---@package
    self.rawNodes = nodes or {}
    for _, v in ipairs(self.rawNodes) do
        assert(type(v) == 'table')
    end
end

---@param other Node
---@return boolean?
function M:onCanBeCast(other)
    if other.typeName == 'never' then
        return false
    end
    if other.typeName == 'any' then
        return true
    end
    other = other.value
    if other.kind == 'union' then
        return nil
    end
    for _, v in ipairs(self.values) do
        if other:canCast(v) then
            return true
        end
    end
    return false
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    -- any 是 top 类型（吸收其他成员），含有 any 的 union 可赋值给任意类型
    for _, v in ipairs(self.values) do
        local t = v.kind == 'variable' and v.value or v
        if t.typeName == 'any' then
            return other.typeName ~= 'never'
        end
    end
    for _, v in ipairs(self.values) do
        if not v:canCast(other) then
            return false
        end
    end
    return true
end

---@type Node[]
M.values = nil

---@param self Node.Union
---@return Node[]
---@return true
M.__getter.values = function (self)
    self.values = {}
    ---@type Node[]
    local values = {}

    ---@param v Node
    local function insertValue(v)
        if #values >= 1000 then
            return
        end
        local nv = v:findValue(ls.node.kind['union'] | ls.node.kind['type'] | ls.node.kind['generic'])
                or v:simplify()
        if nv.kind == 'union' then
            ---@cast nv Node.Union
            for _, vv in ipairs(nv.values) do
                insertValue(vv)
            end
            return
        end
        if nv.typeName == 'never' then
            return
        end
        values[#values+1] = nv
    end
    for _, v in ipairs(self.rawNodes) do
        v:addRef(self)
        insertValue(v)
    end

    ls.util.arrayRemoveDuplicate(values)

    local rt = self.scope.rt
    local hasTrue, hasFalse, hasBoolean
    for _, v in ipairs(values) do
        if v == rt.TRUE then
            hasTrue = true
        elseif v == rt.FALSE then
            hasFalse = true
        elseif v == rt.BOOLEAN then
            hasBoolean = true
        end
    end
    if (hasTrue and hasFalse) or (hasBoolean and (hasTrue or hasFalse)) then
        local merged = {}
        for _, v in ipairs(values) do
            if v ~= rt.TRUE and v ~= rt.FALSE then
                merged[#merged+1] = v
            end
        end
        if not hasBoolean then
            merged[#merged+1] = rt.BOOLEAN
        end
        values = merged
    end

    return values, true
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:get(key)
    local value
    local existsOnce = false
    for _, v in ipairs(self.values) do
        local thisValue, exists = v:get(key)
        value = value | thisValue
        if exists then
            existsOnce = true
        end
    end
    return value or self.scope.rt.NIL, existsOnce
end

---@type Node
M.value = nil

---@param self Node.Union
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = self.scope.rt.NEVER
    if #self.values == 0 then
        return self.scope.rt.NEVER, true
    end
    if #self.values == 1 then
        return self.values[1], true
    end
    return self, true
end

---@param self Node.Union
---@return Node
---@return true
M.__getter.truthy = function (self)
    local rt = self.scope.rt
    local result = {}
    local changed = false
    for _, v in ipairs(self.values) do
        if v ~= v.truthy then
            changed = true
        end
        if v.truthy ~= rt.NEVER then
            result[#result+1] = v.truthy
        end
    end
    if not changed then
        return self, true
    end
    return rt.union(result), true
end

---@param self Node.Union
---@return Node
---@return true
M.__getter.falsy = function (self)
    local rt = self.scope.rt
    local result = {}
    local changed = false
    for _, v in ipairs(self.values) do
        if v ~= v.falsy then
            changed = true
        end
        if v.falsy ~= rt.NEVER then
            result[#result+1] = v.falsy
        end
    end
    if not changed then
        return self, true
    end
    return rt.union(result), true
end

function M:narrow(other)
    local result = {}
    local others = {}
    for _, v in ipairs(self.values) do
        if v:canCast(other) then
            result[#result+1] = v
        else
            others[#others+1] = v
        end
    end
    local rt = self.scope.rt
    return rt.union(result), rt.union(others)
end

function M:narrowByField(key, value)
    local result = {}
    local others = {}
    for _, v in ipairs(self.values) do
        if v:get(key):canCast(value) then
            result[#result+1] = v
        else
            others[#others+1] = v
        end
    end
    local rt = self.scope.rt
    return rt.union(result), rt.union(others)
end

function M:narrowEqual(other)
    local rt = self.scope.rt
    if other == rt.TRUTHY then
        return self.truthy, self.falsy
    end
    if other == rt.FALSY then
        return self.falsy, self.truthy
    end
    local matched = {}
    for _, v in ipairs(self.values) do
        local l = v:findValue(ls.node.kind['value'] | ls.node.kind['type'])
        if l and l:narrowEqual(other) ~= rt.NEVER then
            matched[#matched+1] = v
        end
    end
    if #matched == 0 then
        return rt.NEVER, self
    end
    if #matched == #self.values then
        return self, rt.NEVER
    end
    return rt.union(matched), rt.union(ls.util.arrayDiff(self.values, matched))
end

---@param self Node.Union
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    local hasGeneric = false
    for _, v in ipairs(self.rawNodes) do
        v:addRef(self)
        if v.hasGeneric then
            hasGeneric = true
        end
    end
    return hasGeneric, true
end

---@param map table<Node.Generic, Node>
---@param ctx? Node.ResolveContext
---@return Node
function M:resolveGeneric(map, ctx)
    if self.value ~= self then
        return self.value:resolveGeneric(map, ctx)
    end
    if not self.hasGeneric then
        return self
    end
    ctx = ctx or ls.node.resolveContext()
    if ctx.visited[self] then
        return ctx.visited[self]
    end
    local newValues = {}
    ctx.visited[self] = self
    for _, v in ipairs(self.rawNodes) do
        newValues[#newValues+1] = v:resolveGeneric(map, ctx)
    end
    local newUnion = self.scope.rt.union(newValues)
    ctx.visited[self] = newUnion
    return newUnion
end

function M:inferGeneric(other, result)
    for _, v in ipairs(self.values) do
        v:inferGeneric(other, result)
    end
end

function M:each(kind, callback, visited)
    visited = ls.util.visited(self, visited)
    if not visited then
        return
    end
    local values = self.values
    for _, v in ipairs(values) do
        v:each(kind, callback, visited)
    end
end

function M:every(callback, visited)
    visited = ls.util.visited(self, visited)
    if not visited then
        return self
    end
    local newValues = {}
    for _, v in ipairs(self.values) do
        newValues[#newValues+1] = callback(v)
    end
    return self.scope.rt.union(newValues)
end

function M:onView(viewer, options)
    local values = self.values
    if #values == 0 then
        return 'never'
    end
    -- any 是 top 类型（包含其他所有成员），union 里只显示 any
    for _, value in ipairs(values) do
        local v = value
        if v.kind == 'variable' then
            v = v.value
        end
        if v.typeName == 'any' then
            return viewer:view(v, {
                skipLevel = 0,
                needParentheses = options.needParentheses,
            })
        end
    end
    if #values == 1 then
        return viewer:view(values[1], {
            skipLevel = 0,
            needParentheses = options.needParentheses,
        })
    end
    ---@type string[]
    local view = {}
    for _, value in ipairs(values) do
        local v = value
        if v.kind == 'variable' then
            v = v.value
        end
        if v.hideInUnionView then
            goto continue
        end
        local thisView = viewer:view(v, {
            needParentheses = true,
        })
        if not thisView then
            goto continue
        end
        view[#view+1] = thisView
        ::continue::
    end
    ls.util.arrayRemoveDuplicate(view)
    ls.util.sortByScore(view, {
        function (v)
            if tonumber(v) then
                return 100
            end
            if v == 'true' then
                return 99
            end
            if v == 'false' then
                return 98
            end
            if v == 'nil' then
                return -1
            end
            local firstChar = v:sub(1,1)
            if firstChar == '"' or firstChar == "'" then
                return 97
            end
            if firstChar == '{' or firstChar == '[' then
                return 96
            end
            return 0
        end,
        function (v)
            local num = tonumber(v)
            if num then
                return -num
            end
            return 0
        end,
        ls.util.sortCallbackOfIndex(view),
    })
    local result = table.concat(view, ' | ')
    if options.needParentheses then
        return '(' .. result .. ')'
    end
    return result
end
