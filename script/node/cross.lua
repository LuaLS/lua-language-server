---@class Node.Cross: Node
---@operator bor(Node?): Node
---@operator band(Node?): Node
---@operator shr(Node): boolean
---@overload fun(nodes?: Node[]): Node.Cross
local M = ls.node.register 'Node.Cross'

M.kind = 'cross'

---@param nodes? Node[]
function M:__init(nodes)
    ---@package
    self.rawNodes = nodes or {}
end

---@type Node
M.value = nil

---@param self Node.Cross
---@return Node
---@return true
M.__getter.value = function (self)
    local value = self.rawNodes[1]
    for i = 2, #self.rawNodes do
        local other = self.rawNodes[i]
        if value >> other then
            goto continue
        end
        if other >> value then
            value = other
            goto continue
        end
        value = ls.node.NEVER
        break
        ::continue::
    end
    return value, true
end

function M:view(skipLevel)
    return self.value:view(skipLevel)
end

---@param nodes? Node[]
---@return Node.Cross
function ls.node.cross(nodes)
    return New 'Node.Cross' (nodes)
end
