---@meta

---@class cc.EaseExponentialOut :cc.ActionEase
local EaseExponentialOut={ }
cc.EaseExponentialOut=EaseExponentialOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseExponentialOut:create (action) end
---* 
---@return self
function EaseExponentialOut:clone () end
---* 
---@param time float
---@return self
function EaseExponentialOut:update (time) end
---* 
---@return cc.ActionEase
function EaseExponentialOut:reverse () end
---* 
---@return self
function EaseExponentialOut:EaseExponentialOut () end