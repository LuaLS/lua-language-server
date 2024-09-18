---@class Node.Unknown: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(): Node.Unknown
local M = ls.node.register 'Node.Unknown'

M.kind = 'unknown'

M.typeName = 'unknown'

function M:view()
    return 'unknown'
end

function M:onCanCast(other)
    if other.kind == 'never'
    or other.kind == 'nil' then
        return false
    end
    return true
end

function M:onCanBeCast(other)
    if other.kind == 'never'
    or other.kind == 'nil' then
        return false
    end
    return true
end

ls.node.UNKNOWN = New 'Node.Unknown' ()
function ls.node.unknown()
    return ls.node.UNKNOWN
end
