---@meta

---@class cc.EaseIn :cc.EaseRateAction
local EaseIn={ }
cc.EaseIn=EaseIn




---* 
---@param action cc.ActionInterval
---@param rate float
---@return self
function EaseIn:create (action,rate) end
---* 
---@return self
function EaseIn:clone () end
---* 
---@param time float
---@return self
function EaseIn:update (time) end
---* 
---@return cc.EaseRateAction
function EaseIn:reverse () end
---* 
---@return self
function EaseIn:EaseIn () end