---@class Node: Node.RefModule
---@field onCanCast? fun(self: Node, other: Node): boolean # 能否转换为另一个节点
---@field onCanBeCast? fun(self: Node, other: Node): boolean? # 另一个节点是否能转换为自己，用于双向检查的反向检查
---@field typeName? string
---@field hideInUnionView? boolean
---@field scope Scope
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
local M = Class 'Node'

Extends('Node', 'Node.RefModule')

---@enum(key) Node.Kind
ls.node.kind = {
    ['type']         = 1 << 0,
    ['value']        = 1 << 1,
    ['table']        = 1 << 2,
    ['tuple']        = 1 << 3,
    ['array']        = 1 << 4,
    ['index']        = 1 << 5,
    ['function']     = 1 << 6,
    ['union']        = 1 << 7,
    ['intersection'] = 1 << 8,
    ['unsolve']      = 1 << 9,
    ['generic']      = 1 << 10,
    ['call']         = 1 << 11,
    ['template']     = 1 << 12,
    ['oddtemplate']  = 1 << 13,
    ['list']         = 1 << 14,
    ['variable']     = 1 << 15,
    ['class']        = 1 << 16,
    ['alias']        = 1 << 17,
    ['fcall']        = 1 << 18,
    ['select']       = 1 << 19,
    ['field']        = 1 << 20,
    ['paramof']      = 1 << 21,
    ['narrow']       = 1 << 22,
}

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
        or a.scope.rt.union {a, b}
end

---@param a Node
---@param b Node
---@return Node?
local function makeIntersection(a, b)
    if a == b then
        return a
    end
    if a == nil or b == nil then
        return (a or b).scope.rt.NEVER
    end
end

---@param a Node
---@param b Node
---@return Node?
function M.__band(a, b)
    return makeIntersection(a, b)
        or a.scope.rt.intersection {a, b}
end

---@param other Node
---@return boolean
function M:__shr(other)
    return self:canCast(other)
end

---展示节点内容
---@param options? Node.Viewer.Options
---@return string
function M:view(options)
    local viewer = self.scope.rt.viewer()
    return viewer:view(self, options)
end

---@param options? Node.Viewer.Options
---@return string
function M:viewAsList(options)
    local viewer = self.scope.rt.viewer()
    return viewer:viewAsList(self, options)
end

---@param options? Node.Viewer.Options
---@return string
function M:viewAsVariable(options)
    local viewer = self.scope.rt.viewer()
    return viewer:viewAsVariable(self, options)
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:get(key)
    local value = self.value
    if value == self then
        return self.scope.rt.NEVER, false
    end
    return value:get(key)
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:getExpect(key)
    return self:get(key)
end

---@param key1 Node.Key
---@param key2? Node.Key
---@param ... Node.Key
---@return Node.Variable
function M:getChild(key1, key2, ...)
    local rt = self.scope.rt
    local var = rt.variable(key1, self)
    if key2 then
        return var:getChild(key2, ...)
    end
    return var
end

---@param key Node.Key
---@return Node
---@return boolean exists
function M:select(key)
    local rt = self.scope.rt
    if key == 1 or key == rt.value(1) then
        return self, true
    end
    return self.scope.rt.NEVER, false
end

---@type Node
M.typeOfKey = nil

---@param self Node
---@return Node
---@return true
M.__getter.typeOfKey = function (self)
    if self.value == self then
        return self.scope.rt.NEVER, true
    end
    return self.value.typeOfKey, true
end

---@param value Node
---@return Node
function M:keyOf(value)
    if self.value == self then
        return self.scope.rt.NEVER
    end
    return self.value:keyOf(value)
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
        other = self.scope.rt.value(other)
    end
    local castCache = self.scope.rt.castCache
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

---@param kinds integer
---@return Node?
function M:findValue(kinds)
    local value = self
    for _ = 1, 1000 do
        if (kinds & ls.node.kind[value.kind]) ~= 0 then
            return value
        end
        if value == value.value then
            return nil
        end
        value = value.value
    end
    return nil
end

---@return Node
function M:simplify()
    return self
end

function M:isTableLike()
    if self.value == self then
        return false
    end
    return self.value:isTableLike()
end

---@type Node
M.value = nil

---@param self Node
---@return Node
---@return true
M.__getter.value = function (self)
    return self, true
end

---@type Node
M.truly = nil

---@param self Node
---@return Node
---@return true
M.__getter.truly = function (self)
    if self.value == self then
        return self, true
    end
    return self.value.truly, true
end

---@type Node
M.falsy = nil

---@param self Node
---@return Node
---@return true
M.__getter.falsy = function (self)
    if self.value == self then
        return self.scope.rt.NEVER, true
    end
    return self.value.falsy, true
end

---@type boolean | number | string | nil
M.literal = nil

---@param other Node
---@return Node narrowed
---@return Node otherSide
function M:narrow(other)
    if self.value ~= self then
        return self.value:narrow(other)
    end
    if self:canCast(other) then
        return self, self.scope.rt.NEVER
    end
    return self.scope.rt.NEVER, self
end

---@param key Node.Key
---@param value Node.Key
---@return Node narrowed
---@return Node otherSide
function M:narrowByField(key, value)
    if self.value ~= self then
        return self.value:narrowByField(key, value)
    end
    local myValue = self:get(key)
    if myValue:canCast(value) then
        return self, self.scope.rt.NEVER
    end
    return self.scope.rt.NEVER, self
end

---@param other Node
---@return Node narrowed
---@return Node otherSide
function M:narrowEqual(other)
    local v = self:findValue(ls.node.kind['value'] | ls.node.kind['type'] | ls.node.kind['union'])
    if v then
        return v:narrowEqual(other)
    end
    return self.scope.rt.NEVER, self
end

---@type boolean
M.hasGeneric = nil

---@param self Node
---@return boolean
---@return true
M.__getter.hasGeneric = function (self)
    self.hasGeneric = false
    if self.value == self then
        return false, true
    end
    self.value:addRef(self)
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
---@param callback fun(node: Node)
---@param visited? table<Node, boolean>
function M:each(kind, callback, visited)
    if self.kind == kind then
        callback(self)
        return
    end
    if self.value == self then
        return
    end
    visited = ls.util.visited(self, visited)
    if not visited then
        return
    end
    self.value:each(kind, callback, visited)
end

---@param viewer Node.Viewer
---@param options Node.Viewer.Options
---@return string
function M:onView(viewer, options)
    if self.value == self then
        error('Cannot view node of kind ' .. self.kind)
    end
    return viewer:view(self.value, options)
end

---@param viewer Node.Viewer
---@param options Node.Viewer.Options
---@return string
function M:onViewAsKey(viewer, options)
    return '[' .. viewer:view(self, options) .. ']'
end

---@param viewer Node.Viewer
---@param options Node.Viewer.Options
---@return string
function M:onViewAsVariable(viewer, options)
    error('Cannot view variable of node kind ' .. self.kind)
end

---@param viewer Node.Viewer
---@param options Node.Viewer.Options
---@return string
function M:onViewAsParam(viewer, options)
    error('Cannot view variable of node kind ' .. self.kind)
end

---@param viewer Node.Viewer
---@param options Node.Viewer.Options
---@return string
function M:onViewAsList(viewer, options)
    error('Cannot view variable of node kind ' .. self.kind)
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
