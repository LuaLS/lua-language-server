---@class Node: Class.Base
---@field onCanCast? fun(self: Node, other: Node): boolean # 能否转换为另一个节点
---@field onCanBeCast? fun(self: Node, other: Node): boolean? # 另一个节点是否能转换为自己，用于双向检查的反向检查
---@field typeName? string
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(): Node
local M = Class 'Node'

---@alias Node.Kind 'never' | 'nil' | 'any' | 'unknown' | 'type' | 'value' | 'table' | 'tuple' | 'array' | 'function' | 'union' | 'cross'

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
        or ls.node.union {a, b}
end

function M:__shr(other)
    return self:canCast(other)
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

---@param key string|number|boolean|Node
---@return Node?
function M:get(key)
    return ls.node.NEVER
end

---@alias Node.CastResult 'yes' | 'no' | 'unknown'

function M:refreshCastCache()
    ---@type table<Node, Node.CastResult>
    self._castCache = nil
end

---是否能转换为另一个节点(双向检查)
---@param other Node
---@return boolean
function M:canCast(other)
    if not self._castCache then
        self._castCache = setmetatable({}, ls.util.MODE_K)
    end
    if self._castCache[other] then
        return self._castCache[other] == 'yes'
    end
    self._castCache[other] = 'unknown'
    if other.onCanBeCast then
        local result = other:onCanBeCast(self)
        if result == true then
            self._castCache[other] = 'yes'
            return true
        elseif result == false then
            self._castCache[other] = 'no'
            return false
        end
    end
    if self == other then
        self._castCache[other] = 'yes'
        return true
    end
    if self.onCanCast then
        if self:onCanCast(other) then
            self._castCache[other] = 'yes'
            return true
        end
    end
    self._castCache[other] = 'no'
    return false
end

---@generic T: Node
---@param nodeType `T`
---@return T
function ls.node.register(nodeType)
    local child = Class(nodeType, 'Node')

    child.__bor = M.__bor
    child.__shr = M.__shr

    return child
end

return M
