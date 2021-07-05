---@meta

---@class cc.EaseQuinticActionInOut :cc.ActionEase
local EaseQuinticActionInOut={ }
cc.EaseQuinticActionInOut=EaseQuinticActionInOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseQuinticActionInOut:create (action) end
---* 
---@return self
function EaseQuinticActionInOut:clone () end
---* 
---@param time float
---@return self
function EaseQuinticActionInOut:update (time) end
---* 
---@return cc.ActionEase
function EaseQuinticActionInOut:reverse () end
---* 
---@return self
function EaseQuinticActionInOut:EaseQuinticActionInOut () end