---@class Node.Generic: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(scope: Scope, name: string, extends?: Node, default?: Node): Node.Generic
local M = ls.node.register 'Node.Generic'

M.kind = 'generic'

M.hasGeneric = true

---@param scope Scope
---@param name string
---@param extends? Node
---@param default? Node
function M:__init(scope, name, extends, default)
    self.scope = scope
    self.name = name
    ---@type Node
    self.extends = extends or scope.rt.ANY
    self.default = default
end

---@param self Node.Generic
---@return Node
---@return true
M.__getter.value = function (self)
    local value = self.default or self.extends
    value:addRef(self)
    return value, true
end

function M:onCanBeCast(other)
    return other:canCast(self.extends)
end

function M:onCanCast(other)
    return self.extends:canCast(other)
end

function M:resolveGeneric(map)
    return map[self] or self
end

function M:inferGeneric(other, result)
    if result[self] then
        return
    end
    result[self] = other
end

function M:onView(viewer, options)
    return '<' .. self.name .. '>'
end

function M:onViewAsParam(viewer, options)
    local buf = {}
    buf[#buf+1] = self.name
    if self.extends ~= self.scope.rt.ANY then
        buf[#buf+1] = ':'
        buf[#buf+1] = viewer:view(self.extends, { skipLevel = 0 })
    end
    if self.default then
        buf[#buf+1] = '='
        buf[#buf+1] = viewer:view(self.default, { skipLevel = 0 })
    end
    return table.concat(buf)
end
