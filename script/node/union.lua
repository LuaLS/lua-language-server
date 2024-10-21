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
    local values = {}
    for _, v in ipairs(self.rawNodes) do
        if v == self.scope.node.NEVER then
            goto continue
        end
        if v.kind == 'union' then
            ---@cast v Node.Union
            for _, vv in ipairs(v.values) do
                values[#values+1] = vv
                if #values >= 1000 then
                    return values, true
                end
            end
        else
            values[#values+1] = v
            if #values >= 1000 then
                return values, true
            end
        end
        ::continue::
    end

    ls.util.arrayRemoveDuplicate(values)
    return values, true
end

M.sortScore = {
    ['nil'] = -1000,
}

function M:view(skipLevel)
    ---@type string[]
    local view = {}
    for _, v in ipairs(self.values) do
        local thisView = v:view(skipLevel and skipLevel + 1 or nil)
        if not thisView then
            goto continue
        end
        if v.kind == 'intersection' then
            thisView = '(' .. thisView .. ')'
        end
        view[#view+1] = thisView
        ::continue::
    end
    ls.util.sortByScore(view, {
        function (v)
            return self.sortScore[v] or 0
        end,
        ls.util.sortCallbackOfIndex(view),
    })
    return table.concat(view, ' | ')
end

function M:get(key)
    local value
    for _, v in ipairs(self.values) do
        local thisValue = v:get(key)
        value = value | thisValue
    end
    return value
end

---@type Node
M.value = nil

---@param self Node.Union
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = self.scope.node.NEVER
    if #self.values == 0 then
        return self.scope.node.NEVER, true
    end
    if #self.values == 1 then
        return self.values[1], true
    end
    return self, true
end

---@param default Node
---@return Node
function M:getValue(default)
    if #self.values == 0 then
        return default
    end
    return self.value
end

---@param self Node.Union
---@return Node
---@return true
M.__getter.truly = function (self)
    local result = {}
    for _, v in ipairs(self.values) do
        result[#result+1] = v.truly
    end
    return self.scope.node.union(result).value, true
end

---@param self Node.Union
---@return Node
---@return true
M.__getter.falsy = function (self)
    local result = {}
    for _, v in ipairs(self.values) do
        result[#result+1] = v.falsy
    end
    return self.scope.node.union(result).value, true
end

function M:narrow(other)
    return self.scope.node.union(self.values, function (v)
        return v:canCast(other)
    end)
end

function M:narrowByField(key, value)
    return self.scope.node.union(self.values, function (v)
        return v:get(key):canCast(value)
    end)
end

---@param self Node.Union
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    for _, v in ipairs(self.rawNodes) do
        if v.hasGeneric then
            return true, true
        end
    end
    return false, true
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
    return self.scope.node.union(newValues)
end

function M:inferGeneric(other, result)
    for _, v in ipairs(self.values) do
        v:inferGeneric(other, result)
    end
end
