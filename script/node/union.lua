---@class Node.Union: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, nodes?: Node[]): Node.Union
local M = ls.node.register 'Node.Union'

M.kind = 'union'

---@param scope Scope
---@param nodes? Node[]
function M:__init(scope, nodes)
    self.scope = scope
    ---@package
    self.rawNodes = nodes or {}
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
    ---@type Node[]
    local values = {}
    for _, v in ipairs(self.rawNodes) do
        v:addRef(self)
        if v.typeName == 'never' then
            goto continue
        end
        if v.kind == 'union' then
            ---@cast v Node.Union
            for _, vv in ipairs(v.values) do
                values[#values+1] = vv:findValue { 'type', 'generic' } or vv:finalValue()
                if #values >= 1000 then
                    return values, true
                end
            end
        else
            values[#values+1] = v:findValue { 'type', 'generic' } or v:finalValue()
            if #values >= 1000 then
                return values, true
            end
        end
        ::continue::
    end

    ls.util.arrayRemoveDuplicate(values)
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
M.__getter.truly = function (self)
    local result = {}
    for _, v in ipairs(self.values) do
        result[#result+1] = v.truly
    end
    return self.scope.rt.union(result), true
end

---@param self Node.Union
---@return Node
---@return true
M.__getter.falsy = function (self)
    local result = {}
    for _, v in ipairs(self.values) do
        result[#result+1] = v.falsy
    end
    return self.scope.rt.union(result), true
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

function M:resolveGeneric(map)
    if self.value ~= self then
        return self.value:resolveGeneric(map)
    end
    if not self.hasGeneric then
        return self
    end
    local newValues = {}
    for _, v in ipairs(self.rawNodes) do
        newValues[#newValues+1] = v:resolveGeneric(map)
    end
    return self.scope.rt.union(newValues)
end

function M:inferGeneric(other, result)
    for _, v in ipairs(self.values) do
        v:inferGeneric(other, result)
    end
end

function M:each(kind, callback)
    local values = self.values
    for _, v in ipairs(values) do
        v:each(kind, callback)
    end
end

local sortScore = {
    ['nil'] = -1000,
}

function M:onView(viewer, options)
    local values = self.values
    if #values == 0 then
        return 'never'
    end
    if #values == 1 then
        return viewer:view(values[1], {
            skipLevel = 0,
            needParentheses = options.needParentheses,
        })
    end
    ---@type string[]
    local view = {}
    for _, v in ipairs(values) do
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
            return sortScore[v] or 0
        end,
        ls.util.sortCallbackOfIndex(view),
    })
    local result = table.concat(view, ' | ')
    if options.needParentheses then
        return '(' .. result .. ')'
    end
    return result
end
