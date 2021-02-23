---@meta

---@class cc.TintBy :cc.ActionInterval
local TintBy={ }
cc.TintBy=TintBy




---*  initializes the action with duration and color 
---@param duration float
---@param deltaRed short
---@param deltaGreen short
---@param deltaBlue short
---@return boolean
function TintBy:initWithDuration (duration,deltaRed,deltaGreen,deltaBlue) end
---* Creates an action with duration and color.<br>
---* param duration Duration time, in seconds.<br>
---* param deltaRed Delta red color.<br>
---* param deltaGreen Delta green color.<br>
---* param deltaBlue Delta blue color.<br>
---* return An autoreleased TintBy object.
---@param duration float
---@param deltaRed short
---@param deltaGreen short
---@param deltaBlue short
---@return self
function TintBy:create (duration,deltaRed,deltaGreen,deltaBlue) end
---* 
---@param target cc.Node
---@return self
function TintBy:startWithTarget (target) end
---* 
---@return self
function TintBy:clone () end
---* 
---@return self
function TintBy:reverse () end
---* param time In seconds.
---@param time float
---@return self
function TintBy:update (time) end
---* 
---@return self
function TintBy:TintBy () end