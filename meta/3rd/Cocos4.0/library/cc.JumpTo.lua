---@meta

---@class cc.JumpTo :cc.JumpBy
local JumpTo={ }
cc.JumpTo=JumpTo




---* initializes the action<br>
---* param duration In seconds.
---@param duration float
---@param position vec2_table
---@param height float
---@param jumps int
---@return boolean
function JumpTo:initWithDuration (duration,position,height,jumps) end
---* Creates the action.<br>
---* param duration Duration time, in seconds.<br>
---* param position The jumping destination position.<br>
---* param height The jumping height.<br>
---* param jumps The jumping times.<br>
---* return An autoreleased JumpTo object.
---@param duration float
---@param position vec2_table
---@param height float
---@param jumps int
---@return self
function JumpTo:create (duration,position,height,jumps) end
---* 
---@param target cc.Node
---@return self
function JumpTo:startWithTarget (target) end
---* 
---@return self
function JumpTo:clone () end
---* 
---@return self
function JumpTo:reverse () end
---* 
---@return self
function JumpTo:JumpTo () end