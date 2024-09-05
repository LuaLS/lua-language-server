---@class Node.Boolean: Node
---@overload fun(v: true | false): Node.Boolean
local M = Class 'Node.Boolean'

---@param v true | false
function M:__init(v)
    self.value = v
end

function M:view(ignoreLevel)
    if self.value then
        return 'true'
    else
        return 'false'
    end
end

---@param v true | false
---@return Node.Boolean
function ls.node.boolean(v)
    return New 'Node.Boolean' (v)
end
