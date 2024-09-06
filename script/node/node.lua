---@class Node: Class.Base
---@operator bor(Node): Node
---@overload fun(): Node
local M = Class 'Node'

---基础分类
---@type 'never' | 'any' | 'unknown' | 'void' | 'literal' | 'union' | 'cross'
M.cate = 'never'

M.__bor = ls.node.bor

---展示节点内容
---@param skipLevel? integer
---@return string?
function M:view(skipLevel)
    return 'never'
end

---@return Node
function ls.node.create()
    return New 'Node' ()
end

return M
