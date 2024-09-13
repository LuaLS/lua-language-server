---@class Node.Any: Node
---@operator bor(Node?): Node
---@operator shr(Node): boolean
---@overload fun(): Node.Any
local M = ls.node.register 'Node.Any'

M.kind = 'any'

M.typeName = 'any'

function M:view()
    return 'any'
end

function M:isMatch(other)
    if other.kind == 'never' then
        return false
    end
    return true
end

---@param other Node
---@return boolean
function M:canBeCast(other)
    if other.kind == 'never' then
        return false
    end
    return true
end

ls.node.ANY = New 'Node.Any' ()

function ls.node.any()
    return ls.node.ANY
end
