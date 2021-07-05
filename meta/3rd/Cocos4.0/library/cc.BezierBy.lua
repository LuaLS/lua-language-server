---@meta

---@class cc.BezierBy :cc.ActionInterval
local BezierBy={ }
cc.BezierBy=BezierBy




---* initializes the action with a duration and a bezier configuration<br>
---* param t in seconds
---@param t float
---@param c cc._ccBezierConfig
---@return boolean
function BezierBy:initWithDuration (t,c) end
---* 
---@param target cc.Node
---@return self
function BezierBy:startWithTarget (target) end
---* 
---@return self
function BezierBy:clone () end
---* 
---@return self
function BezierBy:reverse () end
---* param time In seconds.
---@param time float
---@return self
function BezierBy:update (time) end
---* 
---@return self
function BezierBy:BezierBy () end