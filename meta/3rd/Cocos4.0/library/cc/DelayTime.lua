---@meta

---@class cc.DelayTime :cc.ActionInterval
local DelayTime={ }
cc.DelayTime=DelayTime




---* Creates the action.<br>
---* param d Duration time, in seconds.<br>
---* return An autoreleased DelayTime object.
---@param d float
---@return self
function DelayTime:create (d) end
---* 
---@return self
function DelayTime:clone () end
---* param time In seconds.
---@param time float
---@return self
function DelayTime:update (time) end
---* 
---@return self
function DelayTime:reverse () end
---* 
---@return self
function DelayTime:DelayTime () end