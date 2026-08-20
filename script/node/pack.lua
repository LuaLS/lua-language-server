---@class Node.Pack: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, generic: Node, element?: Node): Node.Pack
local M = ls.node.register 'Node.Pack'

M.kind = 'pack'

M.hasGeneric = true

---@param scope Scope
---@param generic Node
---@param element? Node
function M:__init(scope, generic, element)
    self.scope   = scope
    self.generic = generic
    ---@type Node
    self.element = element or scope.rt.ANY
end

---@param self Node.Pack
---@return Node
---@return true
M.__getter.value = function (self)
    self.element:addRef(self)
    return self.element, true
end

---@param other Node
---@return boolean?
function M:onCanBeCast(other)
    return other:canCast(self.element)
end

---@param other Node
---@return boolean
function M:onCanCast(other)
    return self.element:canCast(other)
end

---@return Node.Generic?
function M:getGeneric()
    local generic = self.generic:findValue(ls.node.kind['generic'])
    ---@cast generic Node.Generic?
    return generic
end

---@param map table<Node.Generic, Node>
---@param ctx? Node.ResolveContext
---@return Node
function M:resolveGeneric(map, ctx)
    return self.element:resolveGeneric(map, ctx)
end

---@param other Node
---@param result table<Node.Generic, Node>
function M:inferGeneric(other, result)
    local generic = self:getGeneric()
    if not generic then
        return
    end
    if result[generic] then
        return
    end
    local rt = self.scope.rt
    local list = other:findValue(ls.node.kind['list']) or rt.list({ other })
    result[generic] = rt.tuple(list)
end

function M:onView(viewer, options)
    return '...' .. viewer:view(self.generic, {
        needParentheses = true,
    })
end

function M:onViewAsParam(viewer, options)
    return viewer:view(self.element)
end
