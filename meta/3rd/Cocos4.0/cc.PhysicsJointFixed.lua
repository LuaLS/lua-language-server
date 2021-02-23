---@meta

---@class cc.PhysicsJointFixed :cc.PhysicsJoint
local PhysicsJointFixed={ }
cc.PhysicsJointFixed=PhysicsJointFixed




---* 
---@return boolean
function PhysicsJointFixed:createConstraints () end
---*  Create a fixed joint.<br>
---* param a A is the body to connect.<br>
---* param b B is the body to connect.<br>
---* param anchr It's the pivot position.<br>
---* return A object pointer.
---@param a cc.PhysicsBody
---@param b cc.PhysicsBody
---@param anchr vec2_table
---@return self
function PhysicsJointFixed:construct (a,b,anchr) end