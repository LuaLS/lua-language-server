---@class Node.Union: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(nodes?: Node[]): Node.Union
local M = ls.node.register 'Node.Union'

M.kind = 'union'

---@param nodes? Node[]
function M:__init(nodes)
    ---@package
    self._values = nodes or {}
end

---@param other Node
---@return boolean?
function M:onCanBeCast(other)
    if other.kind == 'union' then
        return nil
    end
    if other.kind == 'never' then
        return false
    end
    if other.kind == 'any' then
        return true
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
    if other.kind == 'union' then
        for _, v in ipairs(self.values) do
            if not v:canCast(other) then
                return false
            end
        end
        return true
    end
    return false
end

---@type Node[]
M.values = nil

function M.__getter:values()
    ---@cast self Node.Union

    local hasUnion = false
    for _, v in ipairs(self._values) do
        if v.kind == 'union' then
            hasUnion = true
            break
        end
    end

    if not hasUnion then
        return self._values, true
    end

    local values = {}
    for _, v in ipairs(self._values) do
        if v.kind == 'union' then
            ---@cast v Node.Union
            for _, vv in ipairs(v.values) do
                values[#values+1] = vv
            end
        else
            values[#values+1] = v
        end
    end

    return values, true
end

function M:view(skipLevel)
    local view = {}
    local mark = {}
    for _, v in ipairs(self.values) do
        local thisView = v:view(skipLevel and skipLevel + 1 or nil)
        if not thisView or mark[thisView] then
            goto continue
        end
        mark[thisView] = true
        view[#view+1] = thisView
        ::continue::
    end
    return table.concat(view, '|')
end

---@return Node?
function M:simplify()
    if #self.values == 0 then
        return nil
    end
    if #self.values == 1 then
        return self.values[1]
    end
    return self
end

---@param nodes? Node[]
---@return Node.Union
function ls.node.union(nodes)
    return New 'Node.Union' (nodes)
end
