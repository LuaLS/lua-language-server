---@class Node.Boolean: Node
---@operator bor(Node): Node
---@overload fun(v: true | false): Node.Boolean
local M = Class('Node.Boolean', 'Node')

M.cate = 'literal'

M.__bor = ls.node.bor

---@param v true | false
function M:__init(v)
    self.value = v
end

function M:view(skipLevel)
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
