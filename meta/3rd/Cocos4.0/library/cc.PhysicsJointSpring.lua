---@meta

---@class cc.PhysicsJointSpring :cc.PhysicsJoint
local PhysicsJointSpring={ }
cc.PhysicsJointSpring=PhysicsJointSpring




---*  Set the anchor point on body b.
---@param anchr2 vec2_table
---@return self
function PhysicsJointSpring:setAnchr2 (anchr2) end
---*  Set the anchor point on body a.
---@param anchr1 vec2_table
---@return self
function PhysicsJointSpring:setAnchr1 (anchr1) end
---*  Get the spring soft constant.
---@return float
function PhysicsJointSpring:getDamping () end
---*  Set the spring constant.
---@param stiffness float
---@return self
function PhysicsJointSpring:setStiffness (stiffness) end
---*  Get the distance of the anchor points.
---@return float
function PhysicsJointSpring:getRestLength () end
---*  Get the anchor point on body b.
---@return vec2_table
function PhysicsJointSpring:getAnchr2 () end
---*  Get the anchor point on body a.
---@return vec2_table
function PhysicsJointSpring:getAnchr1 () end
---*  Get the spring constant.
---@return float
function PhysicsJointSpring:getStiffness () end
---* 
---@return boolean
function PhysicsJointSpring:createConstraints () end
---*  Set the distance of the anchor points.
---@param restLength float
---@return self
function PhysicsJointSpring:setRestLength (restLength) end
---*  Set the spring soft constant.
---@param damping float
---@return self
function PhysicsJointSpring:setDamping (damping) end
---*  Create a fixed distance joint.<br>
---* param a A is the body to connect.<br>
---* param b B is the body to connect.<br>
---* param anchr1 Anchr1 is the anchor point on body a.<br>
---* param anchr2 Anchr2 is the anchor point on body b.<br>
---* param stiffness It's the spring constant.<br>
---* param damping It's how soft to make the damping of the spring.<br>
---* return A object pointer.
---@param a cc.PhysicsBody
---@param b cc.PhysicsBody
---@param anchr1 vec2_table
---@param anchr2 vec2_table
---@param stiffness float
---@param damping float
---@return self
function PhysicsJointSpring:construct (a,b,anchr1,anchr2,stiffness,damping) end