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
    self.extends = extends or scope.node.ANY
    self.default = default
end

---@param skipLevel? integer
---@return string
function M:view(skipLevel)
    local buf = {}
    buf[#buf+1] = '<'
    buf[#buf+1] = self.name
    if self.extends ~= self.scope.node.ANY then
        buf[#buf+1] = ':'
        buf[#buf+1] = self.extends:view(skipLevel)
    end
    if self.default then
        buf[#buf+1] = '='
        buf[#buf+1] = self.default:view(skipLevel)
    end
    buf[#buf+1] = '>'
    return table.concat(buf)
end

---@param self Node.Generic
---@return Node
---@return true
M.__getter.value = function (self)
    return self.default or self.extends, true
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
