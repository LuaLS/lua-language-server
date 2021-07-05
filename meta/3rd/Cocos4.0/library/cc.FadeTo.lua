---@meta

---@class cc.FadeTo :cc.ActionInterval
local FadeTo={ }
cc.FadeTo=FadeTo




---* initializes the action with duration and opacity <br>
---* param duration in seconds
---@param duration float
---@param opacity unsigned_char
---@return boolean
function FadeTo:initWithDuration (duration,opacity) end
---* Creates an action with duration and opacity.<br>
---* param duration Duration time, in seconds.<br>
---* param opacity A certain opacity, the range is from 0 to 255.<br>
---* return An autoreleased FadeTo object.
---@param duration float
---@param opacity unsigned_char
---@return self
function FadeTo:create (duration,opacity) end
---* 
---@param target cc.Node
---@return self
function FadeTo:startWithTarget (target) end
---* 
---@return self
function FadeTo:clone () end
---* 
---@return self
function FadeTo:reverse () end
---* param time In seconds.
---@param time float
---@return self
function FadeTo:update (time) end
---* 
---@return self
function FadeTo:FadeTo () end