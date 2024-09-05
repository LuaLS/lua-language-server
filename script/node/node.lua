---@class Node: Class.Base
---@overload fun(): Node
local M = Class 'Node'

---展示节点内容
---@param ignoreLevel integer
---@return string?
function M:view(ignoreLevel)
    return nil
end

---@return Node
function ls.node.create()
    return New 'Node' ()
end

return M
