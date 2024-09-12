---@class Node.Union: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(...: Node): Node.Union
local M = ls.node.register 'Node.Union'

M.kind = 'union'

---@param ... Node
function M:__init(...)
    ---@package
    self._value = {...}
end

---@type Node[]
M.value = nil

function M.__getter:value()
    ---@cast self Node.Union

    local hasUnion = false
    for _, v in ipairs(self._value) do
        if v.kind == 'union' then
            hasUnion = true
            break
        end
    end

    if not hasUnion then
        return self._value, true
    end

    local value = {}
    for _, v in ipairs(self._value) do
        if v.kind == 'union' then
            ---@cast v Node.Union
            for _, vv in ipairs(v.value) do
                value[#value+1] = vv
            end
        else
            value[#value+1] = v
        end
    end

    return value, true
end

function M:view(skipLevel)
    local view = {}
    local mark = {}
    for _, v in ipairs(self.value) do
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

---@param ... Node
---@return Node
function ls.node.union(...)
    return New 'Node.Union' (...)
end
