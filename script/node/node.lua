---@class Node: Node.CacheModule
---@field onCanCast? fun(self: Node, other: Node): boolean # 能否转换为另一个节点
---@field onCanBeCast? fun(self: Node, other: Node): boolean? # 另一个节点是否能转换为自己，用于双向检查的反向检查
---@field typeName? string
---@field hideInUnionView? boolean
---@field scope Scope
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
local M = Class 'Node'

Extends('Node', 'Node.CacheModule')

---@alias Node.Kind 'type' | 'value' | 'table' | 'tuple' | 'array' | 'index' | 'function' | 'union' | 'intersection' | 'unsolve' | 'generic' | 'call' | 'template' | 'vararg' | 'variable' | 'class' | 'alias'

---@class Node.Location
---@field uri Uri
---@field offset integer
---@field length? integer

---基础分类
---@type Node.Kind
M.kind = nil

---@param a Node
---@param b Node
---@return Node?
local function makeUnion(a, b)
    if a == b then
        return a
    end
    if a == nil then
        return b
    end
    if b == nil then
        return a
    end
end

function M.__bor(a, b)
    return makeUnion(a, b)
        or a.scope.node.union {a, b}
end

---@param a Node
---@param b Node
---@return Node?
local function makeIntersection(a, b)
    if a == b then
        return a
    end
    if a == nil or b == nil then
        return (a or b).scope.node.NEVER
    end
end

---@param a Node
---@param b Node
---@return Node?
function M.__band(a, b)
    return makeIntersection(a, b)
        or a.scope.node.intersection {a, b}
end

---@param other Node
---@return boolean
function M:__shr(other)
    return self:canCast(other)
end

---展示节点内容
---@param skipLevel? integer
---@return string
function M:view(skipLevel)
    ---@type Node.Viewer
    local viewer = New 'Node.Viewer' (skipLevel)
    return viewer:view(self)
end

function M:viewAsKey(skipLevel)
    ---@type Node.Viewer
    local viewer = New 'Node.Viewer' (skipLevel)
    return viewer:viewAsKey(self)
end

---@param key string|number|boolean|Node
---@return Node
function M:get(key)
    local value = self.value
    if value == self then
        return self.scope.node.NEVER
    end
    return value:get(key)
end

---@type Node
M.typeOfKey = nil

---@param self Node
---@return Node
---@return true
M.__getter.typeOfKey = function (self)
    return self.scope.node.NEVER, true
end

---@alias Node.CastResult 'yes' | 'no' | 'unknown'

function M:refreshCastCache()
    ---@type table<Node, Node.CastResult>
    self._castCache = nil
end

---是否能转换为另一个节点(双向检查)
---@param other string | number | boolean | Node
---@return boolean
function M:canCast(other)
    if type(other) ~= 'table' then
        ---@cast other -Node
        other = self.scope.node.value(other)
    end
    local castCache = self.scope.node.castCache
    local path = { self, other }
    local res = castCache:get(path)
    if res then
        return res == 'yes'
    end
    castCache:set(path, 'unknown')
    if other.onCanBeCast then
        local result = other:onCanBeCast(self)
        if result == true then
            castCache:set(path, 'yes')
            return true
        elseif result == false then
            castCache:set(path, 'no')
            return false
        end
    end
    if self == other then
        castCache:set(path, 'yes')
        return true
    end
    if self.onCanCast then
        if self:onCanCast(other) then
            castCache:set(path, 'yes')
            return true
        end
    end
    castCache:set(path, 'no')
    return false
end

---@return Node
function M:finalValue()
    local value = self
    while value ~= value.value do
        value = value.value
    end
    return value
end

---@type Node
M.value = nil

---@param self Node
---@return Node
---@return true
M.__getter.value = function (self)
    return self.solve, true
end

---@type Node
M.solve = nil

M.__getter.solve = function (self)
    return self, true
end

---@type Node
M.truly = nil

M.__getter.truly = function (self)
    return self
end

---@type Node
M.falsy = nil

M.__getter.falsy = function (self)
    return self.scope.node.NEVER
end

---@type boolean | number | string | nil
M.literal = nil

---@param other Node
---@return Node narrowed
---@return Node otherHand
function M:narrow(other)
    if self:canCast(other) then
        return self, self.scope.node.NEVER
    end
    return self.scope.node.NEVER, self
end

---@param key string | number | boolean | Node
---@param value string | number | boolean | Node
---@return Node narrowed
---@return Node otherHand
function M:narrowByField(key, value)
    local myValue = self:get(key)
    if myValue:canCast(value) then
        return self, self.scope.node.NEVER
    end
    return self.scope.node.NEVER, self
end

---@type boolean
M.hasGeneric = nil

---@param self Node
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    if self.value == self then
        return false, true
    end
    return self.value.hasGeneric, true
end

---@param map table<Node.Generic, Node>
---@return Node
function M:resolveGeneric(map)
    if self.value == self then
        return self
    end
    return self.value:resolveGeneric(map)
end

---@param other Node
---@param result table<Node.Generic, Node>
function M:inferGeneric(other, result)
    if not self.hasGeneric or self.value == self then
        return
    end
    self.value:inferGeneric(other, result)
end

---@param kind string
---@return fun(...): Node?
function M:each(kind)
    if self.kind == kind then
        return function (_, last)
            if last then
                return nil
            end
            return self
        end
    else
        return function () end
    end
end

---@generic T: Node
---@param nodeType `T`
---@return T
function ls.node.register(nodeType)
    local child = Class(nodeType, 'Node')

    child.__bor  = M.__bor
    child.__band = M.__band
    child.__shr  = M.__shr

    return child
end

return M
