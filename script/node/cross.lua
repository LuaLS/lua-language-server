---@class Node.Cross: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(a: Node, b: Node): Node.Cross
local M = ls.node.register 'Node.Cross'

M.kind = 'cross'

---@param a Node
---@param b Node
function M:__init(a, b)
    ---@type Node[]
    local values = {}

    if a.kind == 'cross' then
        ---@cast a Node.Cross
        ls.util.arrayMerge(values, a.rawNodes)
    else
        values[#values+1] = a
    end
    if b.kind == 'cross' then
        ---@cast b Node.Cross
        ls.util.arrayMerge(values, b.rawNodes)
    else
        values[#values+1] = b
    end

    ls.util.arrayRemoveDuplicate(values)

    self.rawNodes = values
end

---@type Node[]
M.values = nil

---@param self Node.Cross
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
                return true, ls.node.NEVER
            end
            return true, ls.node.union(result)
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
                return true, ls.node.NEVER
            end
            return true, ls.node.union(result)
        end
        if x.kind == 'type' then
            ---@cast x Node.Type
            if x.isBasicType then
                return true, ls.node.NEVER
            end
        end
        if y.kind == 'type' then
            ---@cast y Node.Type
            if y.isBasicType then
                return true, ls.node.NEVER
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

        return true, ls.node.NEVER
    end

    local values = self.rawNodes
    local result = { values[1] }
    for i = 2, #values do
        local current = result[#result]
        local target = values[i]
        local suc, new = merge(current, target)
        if suc then
            ---@cast new Node
            if new == ls.node.NEVER then
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

---@param self Node.Cross
---@return Node
---@return true
M.__getter.value = function (self)
    local values = self.values

    if #values == 0 then
        return ls.node.NEVER, true
    end
    if #values == 1 then
        return values[1], true
    end

    return self, true
end

function M:view(skipLevel)
    if self.value == self then
        local elements = {}
        for _, v in ipairs(self.rawNodes) do
            local view = v:view(skipLevel)
            if v.kind == 'union' then
                view = '(' .. view .. ')'
            end
            elements[#elements+1] = view
        end
        return table.concat(elements, ' & ')
    else
        return self.value:view(skipLevel)
    end
end

---@param a Node
---@param b Node
---@return Node.Cross
function ls.node.cross(a, b)
    return New 'Node.Cross' (a, b)
end
