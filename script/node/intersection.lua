---@class Node.Intersection: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, nodes?: Node[]): Node.Intersection
local M = ls.node.register 'Node.Intersection'

M.kind = 'intersection'

---@param scope Scope
---@param nodes? Node[]
function M:__init(scope, nodes)
    self.scope = scope
    ---@type Node[]
    local values = {}

    if nodes then
        for _, v in ipairs(nodes) do
            if v.kind == 'intersection' then
                ---@cast v Node.Intersection
                ls.util.arrayMerge(values, v.rawNodes)
            else
                values[#values+1] = v
            end
        end

        ls.util.arrayRemoveDuplicate(values)
    end

    self.rawNodes = values

    for _, v in ipairs(values) do
        v:registerFlushChain(self)
    end
end

---@type Node[]
M.values = nil

---@param self Node.Intersection
---@return Node[]
---@return true
M.__getter.values = function (self)

    ---@param n Node
    ---@return boolean
    local function canMerge(n)
        if n.kind == 'value' then
            return true
        end
        if  n.kind == 'type' then
            ---@cast n Node.Type
            return n.isBasicType
        end
        return false
    end

    ---@param x Node
    ---@param y Node
    ---@return boolean
    ---@return Node?
    local function merge(x, y)
        if x.kind == 'union' then
            ---@cast x Node.Union
            x = x.value
        end
        if y.kind == 'union' then
            ---@cast y Node.Union
            y = y.value
        end
        if x.kind == 'generic'
        or y.kind == 'generic' then
            return false
        end
        if x.kind == 'variable'
        or y.kind == 'variable' then
            return false
        end
        if x >> y then
            return true, x
        end
        if y >> x then
            return true, y
        end
        if  x.kind == 'union'
        and canMerge(y) then
            local result = {}
            ---@cast x Node.Union
            for i, v in ipairs(x.values) do
                result[i] = v & y
            end
            if #result == 1 then
                return true, result[1]
            end
            if #result == 0 then
                return true, self.scope.node.NEVER
            end
            return true, self.scope.node.union(result)
        end
        if  y.kind == 'union'
        and canMerge(x) then
            local result = {}
            ---@cast y Node.Union
            for i, v in ipairs(y.values) do
                result[i] = x & v
            end
            if #result == 1 then
                return true, result[1]
            end
            if #result == 0 then
                return true, self.scope.node.NEVER
            end
            return true, self.scope.node.union(result)
        end
        if x.kind == 'type' then
            ---@cast x Node.Type
            if x.isBasicType then
                return true, self.scope.node.NEVER
            end
        end
        if y.kind == 'type' then
            ---@cast y Node.Type
            if y.isBasicType then
                return true, self.scope.node.NEVER
            end
        end
        if x.kind == 'table'
        or x.kind == 'type'
        or x.kind == 'union'
        or y.kind == 'table'
        or y.kind == 'type'
        or y.kind == 'union' then
            return false
        end

        return true, self.scope.node.NEVER
    end

    local values = self.rawNodes
    local result = { values[1] }
    for i = 2, #values do
        local current = result[#result]
        local target = values[i]
        local suc, new = merge(current, target)
        if suc then
            ---@cast new Node
            if new.typeName == 'never' then
                return {}, true
            end
            result[#result] = new
        else
            result[#result+1] = target
        end
    end

    return result, true
end

---@type Node
M.value = nil

---@param self Node.Intersection
---@return Node
---@return true
M.__getter.value = function (self)
    self.value = self.scope.node.NEVER
    local values = self.values

    if #values == 0 then
        return self.scope.node.NEVER, true
    end
    if #values == 1 then
        return values[1], true
    end

    for _, value in ipairs(values) do
        if value.kind == 'generic' then
            return self, true
        end
    end

    local valueMap = {}
    ---@type Node.Union[]
    local unionParts = {}
    for _, value in ipairs(values) do
        if value.kind == 'union' then
            ---@cast value Node.Union
            unionParts[#unionParts+1] = value
            goto continue
        end
        if value.kind == 'table' then
            ---@cast value Node.Table
            for k, v in pairs(value.valueMap) do
                if valueMap[k] then
                    valueMap[k] = valueMap[k] & v
                else
                    valueMap[k] = v
                end
            end
        end
        ::continue::
    end
    local table = self.scope.node.table(valueMap)

    if #unionParts == 0 then
        return table, true
    end

    local unionValue = self.scope.node.union(unionParts)

    if unionValue.kind ~= 'union' then
        local result = table & unionValue
        return result.value, true
    end

    local results = {}
    ---@cast unionValue Node.Union
    for i, n in ipairs(unionValue.values) do
        results[i] = table & n
    end

    return self.scope.node.union(results), true
end

---@param self Node.Intersection
---@return Node
---@return true
M.__getter.truly = function (self)
    return self.value.truly, true
end

---@param self Node.Intersection
---@return Node
---@return true
M.__getter.falsy = function (self)
    return self.value.falsy, true
end

function M:onCanBeCast(other)
    return other.value:canCast(self.value)
end

function M:onCanCast(other)
    return self.value:canCast(other.value)
end

---@param self Node.Intersection
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    if self.value == self then
        for _, v in ipairs(self.rawNodes) do
            if v.hasGeneric then
                return true, true
            end
        end
        return false, true
    else
        return self.value.hasGeneric, true
    end
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
    return self.scope.node.intersection(newValues)
end

function M:inferGeneric(other, result)
    for _, v in ipairs(self.values) do
        v:inferGeneric(other, result)
    end
end

ls.node.registerView('intersection', function(viewer, node, needParentheses)
    ---@cast node Node.Intersection
    local values = node.values
    if #values == 0 then
        return 'never'
    end
    if #values == 1 then
        return viewer:view(values[1], 0, needParentheses)
    end
    local elements = {}
    for _, v in ipairs(node.rawNodes) do
        if v.hideInUnionView then
            goto continue
        end
        local view = viewer:view(v, 1, true)
        elements[#elements+1] = view
        ::continue::
    end
    local result = table.concat(elements, ' & ')
    if needParentheses then
        return '(' .. result .. ')'
    end
    return result
end)
