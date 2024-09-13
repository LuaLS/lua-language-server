---@class Node.Nil: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(): Node.Nil
local M = ls.node.register 'Node.Nil'

M.kind = 'nil'

M.typeName = 'nil'

function M:view()
    return 'nil'
end

function M:isMatch(other)
    return other.kind == 'nil'
end

ls.node.NIL = New 'Node.Nil' ()

function ls.node.Nil()
    return ls.node.NIL
end
