---@meta

---@class cc.Sequence :cc.ActionInterval
local Sequence={ }
cc.Sequence=Sequence




---* 
---@param arrayOfActions array_table
---@return boolean
function Sequence:init (arrayOfActions) end
---*  initializes the action 
---@param pActionOne cc.FiniteTimeAction
---@param pActionTwo cc.FiniteTimeAction
---@return boolean
function Sequence:initWithTwoActions (pActionOne,pActionTwo) end
---* 
---@param target cc.Node
---@return self
function Sequence:startWithTarget (target) end
---* 
---@return self
function Sequence:reverse () end
---* 
---@return self
function Sequence:clone () end
---* 
---@return self
function Sequence:stop () end
---* param t In seconds.
---@param t float
---@return self
function Sequence:update (t) end
---* 
---@return boolean
function Sequence:isDone () end
---* 
---@return self
function Sequence:Sequence () end