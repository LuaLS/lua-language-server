---@class Node.Type: Node
---@operator bor(Node?): Node
---@overload fun(name: string): Node.Type
local M = ls.node.register 'Node.Type'

M.kind = 'type'

---@param name string
function M:__init(name)
    self.name = name
end

function M:view()
    return self.name
end

---@param name string
---@return Node.Type
function ls.node.type(name)
    if name == 'never'
    or name == 'void' then
        error('Invalid type name: ' .. name)
    end
    return New 'Node.Type' (name)
end
