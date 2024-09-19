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
    ---@package
    self.nodeA = a
    ---@package
    self.nodeB = b
end

---@type Node
M.value = nil

---@param self Node.Cross
---@return Node
---@return true
M.__getter.value = function (self)
    local a = self.nodeA
    local b = self.nodeB
    if a.kind == 'union'
    or a.kind == 'cross' then
        ---@cast a Node.Union | Node.Cross
        a = a.value
    end
    if b.kind == 'union'
    or b.kind == 'cross' then
        ---@cast b Node.Union | Node.Cross
        b = b.value
    end
    if a >> b then
        return a, true
    end
    if b >> a then
        return b, true
    end
    if a.kind == 'union' then
        ---@cast a Node.Union
        local values = {}
        for _, v in ipairs(a.values) do
            local vv = v & b
            if vv ~= ls.node.NEVER then
                values[#values+1] = vv
            end
        end
        if #values == 0 then
            return ls.node.NEVER, true
        end
        return ls.node.union(values), true
    end
    if b.kind == 'union' then
        ---@cast b Node.Union
        local values = {}
        for _, v in ipairs(b.values) do
            local vv = a & v
            if vv ~= ls.node.NEVER then
                values[#values+1] = vv
            end
        end
        if #values == 0 then
            return ls.node.NEVER, true
        end
        return ls.node.union(values), true
    end
    if a.kind == 'type' then
        ---@cast a Node.Type
        if a.isBasicType then
            return ls.node.NEVER, true
        end
    end
    if b.kind == 'type' then
        ---@cast b Node.Type
        if b.isBasicType then
            return ls.node.NEVER, true
        end
    end
    if a.kind == 'table'
    or a.kind == 'cross'
    or a.kind == 'type'
    or b.kind == 'table'
    or b.kind == 'cross'
    or b.kind == 'type' then
        return self, true
    end
    return ls.node.NEVER, true
end

function M:view(skipLevel)
    if self.value == self then
        return string.format('%s & %s'
            , self.nodeA:view(skipLevel)
            , self.nodeB:view(skipLevel)
        )
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
