---@class Node.Any: Node
---@operator bor(Node?): Node
---@overload fun(): Node.Any
local M = ls.node.register 'Node.Any'

M.kind = 'any'

function M:view()
    return 'any'
end

ls.node.ANY = New 'Node.Any' ()

function ls.node.any()
    return ls.node.ANY
end
