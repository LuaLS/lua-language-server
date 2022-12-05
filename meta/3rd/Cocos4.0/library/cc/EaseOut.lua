---@meta

---@class cc.EaseOut :cc.EaseRateAction
local EaseOut={ }
cc.EaseOut=EaseOut




---* 
---@param action cc.ActionInterval
---@param rate float
---@return self
function EaseOut:create (action,rate) end
---* 
---@return self
function EaseOut:clone () end
---* 
---@param time float
---@return self
function EaseOut:update (time) end
---* 
---@return cc.EaseRateAction
function EaseOut:reverse () end
---* 
---@return self
function EaseOut:EaseOut () end