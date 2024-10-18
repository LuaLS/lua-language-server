---@class Node.Generic: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(name: string, extends?: Node, default?: Node): Node.Generic
local M = ls.node.register 'Node.Generic'

M.kind = 'generic'

M.hasGeneric = true

---@param name string
---@param extends? Node
---@param default? Node
function M:__init(name, extends, default)
    self.name = name
    self.extends = extends or ls.node.ANY
    self.default = default
end

---@param skipLevel? integer
---@return string
function M:view(skipLevel)
    local buf = {}
    buf[#buf+1] = '<'
    buf[#buf+1] = self.name
    if self.extends ~= ls.node.ANY then
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

---@param name string
---@param extends? Node
---@param default? Node
---@return Node.Generic
function ls.node.generic(name, extends, default)
    return New 'Node.Generic' (name, extends, default)
end
