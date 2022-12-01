---@meta

---@class cc.Spawn :cc.ActionInterval
local Spawn={ }
cc.Spawn=Spawn




---* 
---@param arrayOfActions array_table
---@return boolean
function Spawn:init (arrayOfActions) end
---*  initializes the Spawn action with the 2 actions to spawn 
---@param action1 cc.FiniteTimeAction
---@param action2 cc.FiniteTimeAction
---@return boolean
function Spawn:initWithTwoActions (action1,action2) end
---* 
---@param target cc.Node
---@return self
function Spawn:startWithTarget (target) end
---* 
---@return self
function Spawn:clone () end
---* 
---@return self
function Spawn:stop () end
---* 
---@return self
function Spawn:reverse () end
---* param time In seconds.
---@param time float
---@return self
function Spawn:update (time) end
---* 
---@return self
function Spawn:Spawn () end