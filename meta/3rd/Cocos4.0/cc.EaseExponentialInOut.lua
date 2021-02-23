---@meta

---@class cc.EaseExponentialInOut :cc.ActionEase
local EaseExponentialInOut={ }
cc.EaseExponentialInOut=EaseExponentialInOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseExponentialInOut:create (action) end
---* 
---@return self
function EaseExponentialInOut:clone () end
---* 
---@param time float
---@return self
function EaseExponentialInOut:update (time) end
---* 
---@return cc.ActionEase
function EaseExponentialInOut:reverse () end
---* 
---@return self
function EaseExponentialInOut:EaseExponentialInOut () end