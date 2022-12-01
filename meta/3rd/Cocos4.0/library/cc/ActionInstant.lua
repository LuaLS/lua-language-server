---@meta

---@class cc.ActionInstant :cc.FiniteTimeAction
local ActionInstant={ }
cc.ActionInstant=ActionInstant




---* 
---@param target cc.Node
---@return self
function ActionInstant:startWithTarget (target) end
---* 
---@return self
function ActionInstant:reverse () end
---* 
---@return self
function ActionInstant:clone () end
---* param time In seconds.
---@param time float
---@return self
function ActionInstant:update (time) end
---* param dt In seconds.
---@param dt float
---@return self
function ActionInstant:step (dt) end
---* 
---@return boolean
function ActionInstant:isDone () end