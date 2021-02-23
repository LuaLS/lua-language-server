---@meta

---@class cc.Physics3DPointToPointConstraint :cc.Physics3DConstraint
local Physics3DPointToPointConstraint={ }
cc.Physics3DPointToPointConstraint=Physics3DPointToPointConstraint




---* get pivot point in A's local space
---@return vec3_table
function Physics3DPointToPointConstraint:getPivotPointInA () end
---* get pivot point in B's local space
---@return vec3_table
function Physics3DPointToPointConstraint:getPivotPointInB () end
---@overload fun(cc.Physics3DRigidBody:cc.Physics3DRigidBody,cc.Physics3DRigidBody:cc.Physics3DRigidBody,vec3_table:vec3_table,vec3_table:vec3_table):self
---@overload fun(cc.Physics3DRigidBody:cc.Physics3DRigidBody,cc.Physics3DRigidBody1:vec3_table):self
---@param rbA cc.Physics3DRigidBody
---@param rbB cc.Physics3DRigidBody
---@param pivotPointInA vec3_table
---@param pivotPointInB vec3_table
---@return boolean
function Physics3DPointToPointConstraint:init (rbA,rbB,pivotPointInA,pivotPointInB) end
---* set pivot point in A's local space
---@param pivotA vec3_table
---@return self
function Physics3DPointToPointConstraint:setPivotPointInA (pivotA) end
---* set pivot point in B's local space
---@param pivotB vec3_table
---@return self
function Physics3DPointToPointConstraint:setPivotPointInB (pivotB) end
---@overload fun(cc.Physics3DRigidBody:cc.Physics3DRigidBody,cc.Physics3DRigidBody:cc.Physics3DRigidBody,vec3_table:vec3_table,vec3_table:vec3_table):self
---@overload fun(cc.Physics3DRigidBody:cc.Physics3DRigidBody,cc.Physics3DRigidBody1:vec3_table):self
---@param rbA cc.Physics3DRigidBody
---@param rbB cc.Physics3DRigidBody
---@param pivotPointInA vec3_table
---@param pivotPointInB vec3_table
---@return self
function Physics3DPointToPointConstraint:create (rbA,rbB,pivotPointInA,pivotPointInB) end
---* 
---@return self
function Physics3DPointToPointConstraint:Physics3DPointToPointConstraint () end