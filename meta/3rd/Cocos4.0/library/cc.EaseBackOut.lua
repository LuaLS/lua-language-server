---@meta

---@class cc.EaseBackOut :cc.ActionEase
local EaseBackOut={ }
cc.EaseBackOut=EaseBackOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseBackOut:create (action) end
---* 
---@return self
function EaseBackOut:clone () end
---* 
---@param time float
---@return self
function EaseBackOut:update (time) end
---* 
---@return cc.ActionEase
function EaseBackOut:reverse () end
---* 
---@return self
function EaseBackOut:EaseBackOut () end