---@meta

---@class cc.PhysicsJointPin :cc.PhysicsJoint
local PhysicsJointPin={ }
cc.PhysicsJointPin=PhysicsJointPin




---* 
---@return boolean
function PhysicsJointPin:createConstraints () end
---@overload fun(cc.PhysicsBody:cc.PhysicsBody,cc.PhysicsBody:cc.PhysicsBody,vec2_table:vec2_table,vec2_table:vec2_table):self
---@overload fun(cc.PhysicsBody:cc.PhysicsBody,cc.PhysicsBody:cc.PhysicsBody,vec2_table:vec2_table):self
---@param a cc.PhysicsBody
---@param b cc.PhysicsBody
---@param anchr1 vec2_table
---@param anchr2 vec2_table
---@return self
function PhysicsJointPin:construct (a,b,anchr1,anchr2) end