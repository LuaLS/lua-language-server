---@meta

---@class cc.EaseQuinticActionOut :cc.ActionEase
local EaseQuinticActionOut={ }
cc.EaseQuinticActionOut=EaseQuinticActionOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseQuinticActionOut:create (action) end
---* 
---@return self
function EaseQuinticActionOut:clone () end
---* 
---@param time float
---@return self
function EaseQuinticActionOut:update (time) end
---* 
---@return cc.ActionEase
function EaseQuinticActionOut:reverse () end
---* 
---@return self
function EaseQuinticActionOut:EaseQuinticActionOut () end