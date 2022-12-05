---@meta

---@class cc.Physics3D6DofConstraint :cc.Physics3DConstraint
local Physics3D6DofConstraint={ }
cc.Physics3D6DofConstraint=Physics3D6DofConstraint




---* set linear lower limit
---@param linearLower vec3_table
---@return self
function Physics3D6DofConstraint:setLinearLowerLimit (linearLower) end
---* get linear lower limit
---@return vec3_table
function Physics3D6DofConstraint:getLinearLowerLimit () end
---* get angular upper limit
---@return vec3_table
function Physics3D6DofConstraint:getAngularUpperLimit () end
---*  access for UseFrameOffset
---@return boolean
function Physics3D6DofConstraint:getUseFrameOffset () end
---* get linear upper limit
---@return vec3_table
function Physics3D6DofConstraint:getLinearUpperLimit () end
---* set angular lower limit
---@param angularLower vec3_table
---@return self
function Physics3D6DofConstraint:setAngularLowerLimit (angularLower) end
---* is limited?<br>
---* param limitIndex first 3 are linear, next 3 are angular
---@param limitIndex int
---@return boolean
function Physics3D6DofConstraint:isLimited (limitIndex) end
---* set use frame offset
---@param frameOffsetOnOff boolean
---@return self
function Physics3D6DofConstraint:setUseFrameOffset (frameOffsetOnOff) end
---* set linear upper limit
---@param linearUpper vec3_table
---@return self
function Physics3D6DofConstraint:setLinearUpperLimit (linearUpper) end
---* get angular lower limit
---@return vec3_table
function Physics3D6DofConstraint:getAngularLowerLimit () end
---* set angular upper limit
---@param angularUpper vec3_table
---@return self
function Physics3D6DofConstraint:setAngularUpperLimit (angularUpper) end
---@overload fun(cc.Physics3DRigidBody:cc.Physics3DRigidBody,cc.Physics3DRigidBody1:mat4_table,mat4_table2:boolean):self
---@overload fun(cc.Physics3DRigidBody:cc.Physics3DRigidBody,cc.Physics3DRigidBody:cc.Physics3DRigidBody,mat4_table:mat4_table,mat4_table:mat4_table,boolean:boolean):self
---@param rbA cc.Physics3DRigidBody
---@param rbB cc.Physics3DRigidBody
---@param frameInA mat4_table
---@param frameInB mat4_table
---@param useLinearReferenceFrameA boolean
---@return self
function Physics3D6DofConstraint:create (rbA,rbB,frameInA,frameInB,useLinearReferenceFrameA) end
---* 
---@return self
function Physics3D6DofConstraint:Physics3D6DofConstraint () end