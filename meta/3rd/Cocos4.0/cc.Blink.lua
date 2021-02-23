---@meta

---@class cc.Blink :cc.ActionInterval
local Blink={ }
cc.Blink=Blink




---* initializes the action <br>
---* param duration in seconds
---@param duration float
---@param blinks int
---@return boolean
function Blink:initWithDuration (duration,blinks) end
---* Creates the action.<br>
---* param duration Duration time, in seconds.<br>
---* param blinks Blink times.<br>
---* return An autoreleased Blink object.
---@param duration float
---@param blinks int
---@return self
function Blink:create (duration,blinks) end
---* 
---@param target cc.Node
---@return self
function Blink:startWithTarget (target) end
---* 
---@return self
function Blink:clone () end
---* 
---@return self
function Blink:stop () end
---* 
---@return self
function Blink:reverse () end
---* param time In seconds.
---@param time float
---@return self
function Blink:update (time) end
---* 
---@return self
function Blink:Blink () end