---@meta

---@class cc.EaseBackInOut :cc.ActionEase
local EaseBackInOut={ }
cc.EaseBackInOut=EaseBackInOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseBackInOut:create (action) end
---* 
---@return self
function EaseBackInOut:clone () end
---* 
---@param time float
---@return self
function EaseBackInOut:update (time) end
---* 
---@return cc.ActionEase
function EaseBackInOut:reverse () end
---* 
---@return self
function EaseBackInOut:EaseBackInOut () end