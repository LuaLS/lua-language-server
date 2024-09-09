---@class Node: Class.Base
---@operator bor(Node?): Node
---@overload fun(): Node
local M = Class 'Node'

---基础分类
---@type 'never' | 'any' | 'unknown' | 'type' | 'value' | 'table' | 'tuple' | 'array' | 'function' | 'union' | 'cross' | 'def'
M.kind = 'never'

---@param a Node
---@param b Node
---@return Node?
local function makeUnion(a, b)
    if a == nil then
        return b
    end
    if a.kind == 'never' then
        return b
    end
    if a.kind == 'any' then
        return a
    end
end

function M.__bor(a, b)
    return makeUnion(a, b)
        or makeUnion(b, a)
        or ls.node.union(a, b)
end

---展示节点内容
---@param skipLevel? integer
---@return string?
function M:view(skipLevel)
    return 'never'
end

function M:viewAsKey(skipLevel)
    return '[' .. self:view(skipLevel) .. ']'
end

ls.node.NEVER = New 'Node' ()

---@return Node
function ls.node.create()
    return ls.node.NEVER
end

function ls.node.register(nodeType)
    local child = Class(nodeType, 'Node')

    child.__bor = M.__bor

    return child
end

return M
