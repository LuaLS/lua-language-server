---@meta

---@class cc.CardinalSplineTo :cc.ActionInterval
local CardinalSplineTo={ }
cc.CardinalSplineTo=CardinalSplineTo




---*  Return a PointArray.<br>
---* return A PointArray.
---@return point_table
function CardinalSplineTo:getPoints () end
---*  It will update the target position and change the _previousPosition to newPos<br>
---* param newPos The new position.
---@param newPos vec2_table
---@return self
function CardinalSplineTo:updatePosition (newPos) end
---* Initializes the action with a duration and an array of points.<br>
---* param duration In seconds.<br>
---* param points An PointArray.<br>
---* param tension Goodness of fit.
---@param duration float
---@param points point_table
---@param tension float
---@return boolean
function CardinalSplineTo:initWithDuration (duration,points,tension) end
---* 
---@param target cc.Node
---@return self
function CardinalSplineTo:startWithTarget (target) end
---* 
---@return self
function CardinalSplineTo:clone () end
---* 
---@return self
function CardinalSplineTo:reverse () end
---* param time In seconds.
---@param time float
---@return self
function CardinalSplineTo:update (time) end
---* js ctor<br>
---* lua NA
---@return self
function CardinalSplineTo:CardinalSplineTo () end