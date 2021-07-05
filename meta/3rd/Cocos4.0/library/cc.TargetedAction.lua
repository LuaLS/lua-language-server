---@meta

---@class cc.TargetedAction :cc.ActionInterval
local TargetedAction={ }
cc.TargetedAction=TargetedAction




---@overload fun():cc.Node
---@overload fun():cc.Node
---@return cc.Node
function TargetedAction:getForcedTarget () end
---*  Init an action with the specified action and forced target 
---@param target cc.Node
---@param action cc.FiniteTimeAction
---@return boolean
function TargetedAction:initWithTarget (target,action) end
---*  Sets the target that the action will be forced to run with.<br>
---* param forcedTarget The target that the action will be forced to run with.
---@param forcedTarget cc.Node
---@return self
function TargetedAction:setForcedTarget (forcedTarget) end
---*  Create an action with the specified action and forced target.<br>
---* param target The target needs to override.<br>
---* param action The action needs to override.<br>
---* return An autoreleased TargetedAction object.
---@param target cc.Node
---@param action cc.FiniteTimeAction
---@return self
function TargetedAction:create (target,action) end
---* 
---@param target cc.Node
---@return self
function TargetedAction:startWithTarget (target) end
---* 
---@return self
function TargetedAction:clone () end
---* 
---@return self
function TargetedAction:stop () end
---* 
---@return self
function TargetedAction:reverse () end
---* param time In seconds.
---@param time float
---@return self
function TargetedAction:update (time) end
---* 
---@return self
function TargetedAction:TargetedAction () end