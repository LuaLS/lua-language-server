---@class Node.Unknown: Node
---@operator bor(Node?): Node
---@overload fun(): Node.Unknown
local M = ls.node.register 'Node.Unknown'

M.kind = 'unknown'

function M:view()
    return 'unknown'
end

ls.node.UNKNOWN = New 'Node.Unknown' ()
function ls.node.unknown()
    return ls.node.UNKNOWN
end
