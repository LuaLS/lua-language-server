---@meta

---@class cc.PhysicsJointRotarySpring :cc.PhysicsJoint
local PhysicsJointRotarySpring={ }
cc.PhysicsJointRotarySpring=PhysicsJointRotarySpring




---*  Get the spring soft constant.
---@return float
function PhysicsJointRotarySpring:getDamping () end
---*  Set the relative angle in radians from the body a to b.
---@param restAngle float
---@return self
function PhysicsJointRotarySpring:setRestAngle (restAngle) end
---*  Get the spring constant.
---@return float
function PhysicsJointRotarySpring:getStiffness () end
---* 
---@return boolean
function PhysicsJointRotarySpring:createConstraints () end
---*  Set the spring constant.
---@param stiffness float
---@return self
function PhysicsJointRotarySpring:setStiffness (stiffness) end
---*  Set the spring soft constant.
---@param damping float
---@return self
function PhysicsJointRotarySpring:setDamping (damping) end
---*  Get the relative angle in radians from the body a to b.
---@return float
function PhysicsJointRotarySpring:getRestAngle () end
---*  Create a damped rotary spring joint.<br>
---* param a A is the body to connect.<br>
---* param b B is the body to connect.<br>
---* param stiffness It's the spring constant.<br>
---* param damping It's how soft to make the damping of the spring.<br>
---* return A object pointer.
---@param a cc.PhysicsBody
---@param b cc.PhysicsBody
---@param stiffness float
---@param damping float
---@return self
function PhysicsJointRotarySpring:construct (a,b,stiffness,damping) end