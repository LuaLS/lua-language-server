---@meta

---@class cc.ProgressTo :cc.ActionInterval
local ProgressTo={ }
cc.ProgressTo=ProgressTo




---* brief Initializes with a duration and destination percentage. <br>
---* param duration Specify the duration of the ProgressTo action. It's a value in seconds.<br>
---* param percent Specify the destination percentage.<br>
---* return If the creation success, return true; otherwise, return false.
---@param duration float
---@param percent float
---@return boolean
function ProgressTo:initWithDuration (duration,percent) end
---* brief Create and initializes with a duration and a destination percentage.<br>
---* param duration Specify the duration of the ProgressTo action. It's a value in seconds.<br>
---* param percent Specify the destination percentage.<br>
---* return If the creation success, return a pointer of ProgressTo action; otherwise, return nil.
---@param duration float
---@param percent float
---@return self
function ProgressTo:create (duration,percent) end
---* 
---@param target cc.Node
---@return self
function ProgressTo:startWithTarget (target) end
---* 
---@return self
function ProgressTo:clone () end
---* 
---@return self
function ProgressTo:reverse () end
---* 
---@param time float
---@return self
function ProgressTo:update (time) end
---* 
---@return self
function ProgressTo:ProgressTo () end