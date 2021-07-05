---@meta

---@class cc.PhysicsJointRotaryLimit :cc.PhysicsJoint
local PhysicsJointRotaryLimit={ }
cc.PhysicsJointRotaryLimit=PhysicsJointRotaryLimit




---*  Get the max rotation limit.
---@return float
function PhysicsJointRotaryLimit:getMax () end
---* 
---@return boolean
function PhysicsJointRotaryLimit:createConstraints () end
---*  Set the min rotation limit.
---@param min float
---@return self
function PhysicsJointRotaryLimit:setMin (min) end
---*  Set the max rotation limit.
---@param max float
---@return self
function PhysicsJointRotaryLimit:setMax (max) end
---*  Get the min rotation limit.
---@return float
function PhysicsJointRotaryLimit:getMin () end
---@overload fun(cc.PhysicsBody:cc.PhysicsBody,cc.PhysicsBody:cc.PhysicsBody):self
---@overload fun(cc.PhysicsBody:cc.PhysicsBody,cc.PhysicsBody:cc.PhysicsBody,float:float,float:float):self
---@param a cc.PhysicsBody
---@param b cc.PhysicsBody
---@param min float
---@param max float
---@return self
function PhysicsJointRotaryLimit:construct (a,b,min,max) end