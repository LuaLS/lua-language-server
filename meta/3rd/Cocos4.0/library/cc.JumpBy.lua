---@meta

---@class cc.JumpBy :cc.ActionInterval
local JumpBy={ }
cc.JumpBy=JumpBy




---* initializes the action<br>
---* param duration in seconds
---@param duration float
---@param position vec2_table
---@param height float
---@param jumps int
---@return boolean
function JumpBy:initWithDuration (duration,position,height,jumps) end
---* Creates the action.<br>
---* param duration Duration time, in seconds.<br>
---* param position The jumping distance.<br>
---* param height The jumping height.<br>
---* param jumps The jumping times.<br>
---* return An autoreleased JumpBy object.
---@param duration float
---@param position vec2_table
---@param height float
---@param jumps int
---@return self
function JumpBy:create (duration,position,height,jumps) end
---* 
---@param target cc.Node
---@return self
function JumpBy:startWithTarget (target) end
---* 
---@return self
function JumpBy:clone () end
---* 
---@return self
function JumpBy:reverse () end
---* param time In seconds.
---@param time float
---@return self
function JumpBy:update (time) end
---* 
---@return self
function JumpBy:JumpBy () end