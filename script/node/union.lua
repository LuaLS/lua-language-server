---@class Node.Union: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(nodes?: Node[]): Node.Union
local M = ls.node.register 'Node.Union'

M.kind = 'union'

---@param nodes? Node[]
function M:__init(nodes)
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

function M.__getter:values()
    ---@cast self Node.Union

    local hasUnion = false
    for _, v in ipairs(self.rawNodes) do
        if v.kind == 'union' then
            hasUnion = true
            break
        end
    end

    if not hasUnion then
        return self.rawNodes, true
    end

    local values = {}
    for _, v in ipairs(self.rawNodes) do
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
    end

    return values, true
end

M.sortScore = {
    ['nil'] = -1000,
}

function M:view(skipLevel)
    ---@type string[]
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
    ls.util.sortByScore(view, {
        function (v)
            return self.sortScore[v] or 0
        end,
        ls.util.sortCallbackOfIndex(view),
    })
    return table.concat(view, '|')
end

function M:get(key)
    local value
    for _, v in ipairs(self.values) do
        local thisValue = v:get(key)
        value = value | thisValue
    end
    return value
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
