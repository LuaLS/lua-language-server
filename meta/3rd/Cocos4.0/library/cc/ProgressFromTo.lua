---@meta

---@class cc.ProgressFromTo :cc.ActionInterval
local ProgressFromTo={ }
cc.ProgressFromTo=ProgressFromTo




---* brief Initializes the action with a duration, a "from" percentage and a "to" percentage.<br>
---* param duration Specify the duration of the ProgressFromTo action. It's a value in seconds.<br>
---* param fromPercentage Specify the source percentage.<br>
---* param toPercentage Specify the destination percentage.<br>
---* return If the creation success, return true; otherwise, return false.
---@param duration float
---@param fromPercentage float
---@param toPercentage float
---@return boolean
function ProgressFromTo:initWithDuration (duration,fromPercentage,toPercentage) end
---* brief Create and initializes the action with a duration, a "from" percentage and a "to" percentage.<br>
---* param duration Specify the duration of the ProgressFromTo action. It's a value in seconds.<br>
---* param fromPercentage Specify the source percentage.<br>
---* param toPercentage Specify the destination percentage.<br>
---* return If the creation success, return a pointer of ProgressFromTo action; otherwise, return nil.
---@param duration float
---@param fromPercentage float
---@param toPercentage float
---@return self
function ProgressFromTo:create (duration,fromPercentage,toPercentage) end
---* 
---@param target cc.Node
---@return self
function ProgressFromTo:startWithTarget (target) end
---* 
---@return self
function ProgressFromTo:clone () end
---* 
---@return self
function ProgressFromTo:reverse () end
---* 
---@param time float
---@return self
function ProgressFromTo:update (time) end
---* 
---@return self
function ProgressFromTo:ProgressFromTo () end