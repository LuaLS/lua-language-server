---@class Node.Nil: Node
---@operator bor(Node?): Node
---@overload fun(): Node.Nil
local M = ls.node.register 'Node.Nil'

M.kind = 'nil'

function M:view()
    return 'nil'
end

ls.node.NIL = New 'Node.Nil' ()

function ls.node.Nil()
    return ls.node.NIL
end
