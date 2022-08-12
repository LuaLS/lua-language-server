---@meta

---@class cc.FiniteTimeAction :cc.Action
local FiniteTimeAction={ }
cc.FiniteTimeAction=FiniteTimeAction




---*  Set duration in seconds of the action. <br>
---* param duration In seconds of the action.
---@param duration float
---@return self
function FiniteTimeAction:setDuration (duration) end
---*  Get duration in seconds of the action. <br>
---* return The duration in seconds of the action.
---@return float
function FiniteTimeAction:getDuration () end
---* 
---@return self
function FiniteTimeAction:clone () end
---* 
---@return self
function FiniteTimeAction:reverse () end