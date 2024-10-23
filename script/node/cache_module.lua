---@class Node.CacheModule : Class.Base
---@field scope Scope
local M = Class 'Node.CacheModule'

---@type table<Node, true>?
M.needFlush = nil

---@param needReset boolean
---@param me Node
function M:flushMe(me, needReset)
    if not self.needFlush then
        self.needFlush = setmetatable({}, ls.util.MODE_K)
    end
    if needReset then
        self.needFlush[me] = (self.needFlush[me] or 0) + 1
    else
        self.needFlush[me] = self.needFlush[me] - 1
        if self.needFlush[me] == 0 then
            self.needFlush[me] = nil
        end
    end
end

function M:flushCache()
    self.scope.node:collectFlushNodes(self)
end
