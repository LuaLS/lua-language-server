---@meta

---@class cc.PhysicsJointMotor :cc.PhysicsJoint
local PhysicsJointMotor={ }
cc.PhysicsJointMotor=PhysicsJointMotor




---*  Set the relative angular velocity.
---@param rate float
---@return self
function PhysicsJointMotor:setRate (rate) end
---*  Get the relative angular velocity.
---@return float
function PhysicsJointMotor:getRate () end
---* 
---@return boolean
function PhysicsJointMotor:createConstraints () end
---*  Create a motor joint.<br>
---* param a A is the body to connect.<br>
---* param b B is the body to connect.<br>
---* param rate Rate is the desired relative angular velocity.<br>
---* return A object pointer.
---@param a cc.PhysicsBody
---@param b cc.PhysicsBody
---@param rate float
---@return self
function PhysicsJointMotor:construct (a,b,rate) end