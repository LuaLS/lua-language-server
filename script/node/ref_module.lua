---@class Node.RefModule : Class.Base
---@field scope Scope
local M = Class 'Node.RefModule'

---@type table<Node.RefModule, true>?
M.refMap = nil

-- 注册缓存清理链。注意这是临时引用，不能作为永久引用使用。
---@param child Node.RefModule
function M:addRef(child)
    if self == child then
        return
    end
    if not self.refMap then
        self.refMap = setmetatable({}, ls.util.MODE_K)
    end
    self.refMap[child] = true
end

-- 清理自身的缓存
function M:flushCache()
    self.scope.rt:collectFlushNodes(self)
end
