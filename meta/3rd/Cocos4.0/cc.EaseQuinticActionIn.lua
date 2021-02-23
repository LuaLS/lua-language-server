---@meta

---@class cc.EaseQuinticActionIn :cc.ActionEase
local EaseQuinticActionIn={ }
cc.EaseQuinticActionIn=EaseQuinticActionIn




---* 
---@param action cc.ActionInterval
---@return self
function EaseQuinticActionIn:create (action) end
---* 
---@return self
function EaseQuinticActionIn:clone () end
---* 
---@param time float
---@return self
function EaseQuinticActionIn:update (time) end
---* 
---@return cc.ActionEase
function EaseQuinticActionIn:reverse () end
---* 
---@return self
function EaseQuinticActionIn:EaseQuinticActionIn () end