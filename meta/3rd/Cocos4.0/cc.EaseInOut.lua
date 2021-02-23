---@meta

---@class cc.EaseInOut :cc.EaseRateAction
local EaseInOut={ }
cc.EaseInOut=EaseInOut




---* 
---@param action cc.ActionInterval
---@param rate float
---@return self
function EaseInOut:create (action,rate) end
---* 
---@return self
function EaseInOut:clone () end
---* 
---@param time float
---@return self
function EaseInOut:update (time) end
---* 
---@return cc.EaseRateAction
function EaseInOut:reverse () end
---* 
---@return self
function EaseInOut:EaseInOut () end