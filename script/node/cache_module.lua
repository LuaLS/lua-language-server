---@class Node.CacheModule : Class.Base
---@field scope Scope
local M = Class 'Node.CacheModule'

---@type table<Node, true>?
M.needFlush = nil

-- 注册缓存清理链
---@param me Node
function M:registerFlushChain(me)
    if not self.needFlush then
        self.needFlush = setmetatable({}, ls.util.MODE_K)
    end
    self.needFlush[me] = (self.needFlush[me] or 0) + 1
end

-- 注销缓存清理链
---@param me Node
function M:unregisterFlushChain(me)
    self.needFlush[me] = self.needFlush[me] - 1
    if self.needFlush[me] == 0 then
        self.needFlush[me] = nil
    end
end

-- 清理自身的缓存
function M:flushCache()
    self.scope.rt:collectFlushNodes(self)
end
