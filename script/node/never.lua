---@class Node.Never: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(): Node.Never
local M = ls.node.register 'Node.Never'

M.kind = 'never'

function M:view()
    return 'never'
end

function M:isMatch(other)
    return false
end

function M:canBeCast(other)
    return false
end

ls.node.NEVER = New 'Node.Never' ()

function ls.node.never()
    return ls.node.NEVER
end
