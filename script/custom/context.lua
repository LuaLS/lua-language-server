---@type table<any, Custom.Context.Master>
local masterMap = ls.util.weakKTable()

---@class Custom.Context: Class.Base
---@field args Node[] | table<string, Node>
local C = Class 'Custom.Context'

---@class Custom.Context.Master
local M = Class 'Custom.Context.Master'

---@param rt Node.Runtime
---@param data? table
function M:__init(rt, data)
    self.rt = rt
    ---@type Custom.Context
    self.context = New 'Custom.Context' ()
    if data then
        ls.util.tableMerge(self.context, data)
    end
    masterMap[self.context] = self
end

---@param func fun(c: Custom.Context): Node
---@return Node
function M:call(func)
    local c1 = os.clock()
    local suc, res = pcall(func, self.context)
    local c2 = os.clock()
    local duration = (c2 - c1) * 1000
    if duration > 10 then
        log.warn(('[Custom] execution took %.2f ms'):format(duration))
    end
    if suc then
        return res
    end
    log.error(('[Custom] error: %s'):format(res))
    return self.rt.NEVER
end

---@param rt Node.Runtime
---@param data? table
---@return Custom.Context.Master
function ls.custom.contextMaster(rt, data)
    local master = New 'Custom.Context.Master' (rt, data)
    return master
end
