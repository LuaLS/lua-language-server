---@class Node.Generic: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(name: string, extends?: Node): Node.Generic
local M = ls.node.register 'Node.Generic'

M.kind = 'generic'

M.hasGeneric = true

---@param name string
---@param extends? Node
function M:__init(name, extends)
    self.name = name
    self.extends = extends
end

---@param skipLevel? integer
---@return string
function M:view(skipLevel)
    if self.extends then
        return string.format('<%s:%s>', self.name, self.extends:view(skipLevel))
    else
        return string.format('<%s>', self.name)
    end
end

function M:resolveGeneric(pack, keepGeneric)
    return pack:getGeneric(self.name, keepGeneric)
        or self.extends
        or ls.node.UNKNOWN
end

---@param name string
---@param extends? Node
---@return Node.Generic
function ls.node.generic(name, extends)
    return New 'Node.Generic' (name, extends)
end
