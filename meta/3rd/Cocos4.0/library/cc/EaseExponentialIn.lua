---@meta

---@class cc.EaseExponentialIn :cc.ActionEase
local EaseExponentialIn={ }
cc.EaseExponentialIn=EaseExponentialIn




---* 
---@param action cc.ActionInterval
---@return self
function EaseExponentialIn:create (action) end
---* 
---@return self
function EaseExponentialIn:clone () end
---* 
---@param time float
---@return self
function EaseExponentialIn:update (time) end
---* 
---@return cc.ActionEase
function EaseExponentialIn:reverse () end
---* 
---@return self
function EaseExponentialIn:EaseExponentialIn () end