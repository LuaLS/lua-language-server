---@meta

---@class cc.ActionInterval :cc.FiniteTimeAction
local ActionInterval={ }
cc.ActionInterval=ActionInterval




---*  Gets the amplitude rate, extension in GridAction<br>
---* return  The amplitude rate.
---@return float
function ActionInterval:getAmplitudeRate () end
---*  initializes the action 
---@param d float
---@return boolean
function ActionInterval:initWithDuration (d) end
---*  Sets the amplitude rate, extension in GridAction<br>
---* param amp   The amplitude rate.
---@param amp float
---@return self
function ActionInterval:setAmplitudeRate (amp) end
---*  How many seconds had elapsed since the actions started to run.<br>
---* return The seconds had elapsed since the actions started to run.
---@return float
function ActionInterval:getElapsed () end
---* 
---@param target cc.Node
---@return self
function ActionInterval:startWithTarget (target) end
---* param dt in seconds
---@param dt float
---@return self
function ActionInterval:step (dt) end
---* 
---@return self
function ActionInterval:clone () end
---* 
---@return self
function ActionInterval:reverse () end
---* 
---@return boolean
function ActionInterval:isDone () end