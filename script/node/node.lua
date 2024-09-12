---@class Node: Class.Base
---@operator bor(Node?): Node
---@overload fun(): Node
local M = Class 'Node'

---@alias Node.Kind 'never' | 'nil' | 'any' | 'unknown' | 'type' | 'value' | 'table' | 'tuple' | 'array' | 'function' | 'union' | 'cross' | 'def'

---基础分类
---@type Node.Kind
M.kind = nil

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
    error('Not implemented')
end

function M:viewAsKey(skipLevel)
    return '[' .. self:view(skipLevel) .. ']'
end

---是否能转换为另一个节点
---@param node Node
---@return boolean
function M:isMatch(node)
    error('Not implemented')
end

---@class Node.Options
---@field supportUnion? boolean # 是否支持联合类型，默认为 true

---@generic T: Node
---@param nodeType `T`
---@param options? Node.Options
---@return T
function ls.node.register(nodeType, options)
    local child = Class(nodeType, 'Node')

    child.__bor = M.__bor

    if options then
        if options.supportUnion == false then
            child.__bor = nil
        end
    end

    return child
end

return M
