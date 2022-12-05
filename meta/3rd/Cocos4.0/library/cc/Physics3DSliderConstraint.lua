---@meta

---@class cc.Physics3DSliderConstraint :cc.Physics3DConstraint
local Physics3DSliderConstraint={ }
cc.Physics3DSliderConstraint=Physics3DSliderConstraint




---* 
---@param onOff boolean
---@return self
function Physics3DSliderConstraint:setPoweredAngMotor (onOff) end
---* 
---@return float
function Physics3DSliderConstraint:getDampingLimAng () end
---* 
---@param restitutionOrthoLin float
---@return self
function Physics3DSliderConstraint:setRestitutionOrthoLin (restitutionOrthoLin) end
---* 
---@param restitutionDirLin float
---@return self
function Physics3DSliderConstraint:setRestitutionDirLin (restitutionDirLin) end
---* 
---@return float
function Physics3DSliderConstraint:getLinearPos () end
---* get A's frame offset
---@return mat4_table
function Physics3DSliderConstraint:getFrameOffsetA () end
---* get B's frame offset
---@return mat4_table
function Physics3DSliderConstraint:getFrameOffsetB () end
---* 
---@param onOff boolean
---@return self
function Physics3DSliderConstraint:setPoweredLinMotor (onOff) end
---* 
---@return float
function Physics3DSliderConstraint:getDampingDirAng () end
---* 
---@return float
function Physics3DSliderConstraint:getRestitutionLimLin () end
---* 
---@return float
function Physics3DSliderConstraint:getSoftnessOrthoAng () end
---* 
---@param softnessOrthoLin float
---@return self
function Physics3DSliderConstraint:setSoftnessOrthoLin (softnessOrthoLin) end
---* 
---@param softnessLimLin float
---@return self
function Physics3DSliderConstraint:setSoftnessLimLin (softnessLimLin) end
---* 
---@return float
function Physics3DSliderConstraint:getAngularPos () end
---* 
---@param restitutionLimAng float
---@return self
function Physics3DSliderConstraint:setRestitutionLimAng (restitutionLimAng) end
---* set upper linear limit
---@param upperLimit float
---@return self
function Physics3DSliderConstraint:setUpperLinLimit (upperLimit) end
---* 
---@param dampingDirLin float
---@return self
function Physics3DSliderConstraint:setDampingDirLin (dampingDirLin) end
---* get upper angular limit
---@return float
function Physics3DSliderConstraint:getUpperAngLimit () end
---* 
---@return float
function Physics3DSliderConstraint:getDampingDirLin () end
---* 
---@return float
function Physics3DSliderConstraint:getSoftnessDirAng () end
---* 
---@return boolean
function Physics3DSliderConstraint:getPoweredAngMotor () end
---* set lower angular limit
---@param lowerLimit float
---@return self
function Physics3DSliderConstraint:setLowerAngLimit (lowerLimit) end
---* set upper angular limit
---@param upperLimit float
---@return self
function Physics3DSliderConstraint:setUpperAngLimit (upperLimit) end
---* 
---@param targetLinMotorVelocity float
---@return self
function Physics3DSliderConstraint:setTargetLinMotorVelocity (targetLinMotorVelocity) end
---* 
---@param dampingLimAng float
---@return self
function Physics3DSliderConstraint:setDampingLimAng (dampingLimAng) end
---* 
---@return float
function Physics3DSliderConstraint:getRestitutionLimAng () end
---*  access for UseFrameOffset
---@return boolean
function Physics3DSliderConstraint:getUseFrameOffset () end
---* 
---@return float
function Physics3DSliderConstraint:getSoftnessOrthoLin () end
---* 
---@return float
function Physics3DSliderConstraint:getDampingOrthoAng () end
---* set use frame offset
---@param frameOffsetOnOff boolean
---@return self
function Physics3DSliderConstraint:setUseFrameOffset (frameOffsetOnOff) end
---* set lower linear limit
---@param lowerLimit float
---@return self
function Physics3DSliderConstraint:setLowerLinLimit (lowerLimit) end
---* 
---@return float
function Physics3DSliderConstraint:getRestitutionDirLin () end
---* 
---@return float
function Physics3DSliderConstraint:getTargetLinMotorVelocity () end
---* get lower linear limit
---@return float
function Physics3DSliderConstraint:getLowerLinLimit () end
---* 
---@return float
function Physics3DSliderConstraint:getSoftnessLimLin () end
---* 
---@param dampingOrthoAng float
---@return self
function Physics3DSliderConstraint:setDampingOrthoAng (dampingOrthoAng) end
---* 
---@param softnessDirAng float
---@return self
function Physics3DSliderConstraint:setSoftnessDirAng (softnessDirAng) end
---* 
---@return boolean
function Physics3DSliderConstraint:getPoweredLinMotor () end
---* 
---@param restitutionOrthoAng float
---@return self
function Physics3DSliderConstraint:setRestitutionOrthoAng (restitutionOrthoAng) end
---* 
---@param dampingDirAng float
---@return self
function Physics3DSliderConstraint:setDampingDirAng (dampingDirAng) end
---* set frames for rigid body A and B
---@param frameA mat4_table
---@param frameB mat4_table
---@return self
function Physics3DSliderConstraint:setFrames (frameA,frameB) end
---* 
---@return float
function Physics3DSliderConstraint:getRestitutionOrthoAng () end
---* 
---@return float
function Physics3DSliderConstraint:getMaxAngMotorForce () end
---* 
---@return float
function Physics3DSliderConstraint:getDampingOrthoLin () end
---* get upper linear limit
---@return float
function Physics3DSliderConstraint:getUpperLinLimit () end
---* 
---@param maxLinMotorForce float
---@return self
function Physics3DSliderConstraint:setMaxLinMotorForce (maxLinMotorForce) end
---* 
---@return float
function Physics3DSliderConstraint:getRestitutionOrthoLin () end
---* 
---@param targetAngMotorVelocity float
---@return self
function Physics3DSliderConstraint:setTargetAngMotorVelocity (targetAngMotorVelocity) end
---* 
---@return float
function Physics3DSliderConstraint:getSoftnessLimAng () end
---* 
---@param restitutionDirAng float
---@return self
function Physics3DSliderConstraint:setRestitutionDirAng (restitutionDirAng) end
---* 
---@return float
function Physics3DSliderConstraint:getDampingLimLin () end
---* get lower angular limit
---@return float
function Physics3DSliderConstraint:getLowerAngLimit () end
---* 
---@return float
function Physics3DSliderConstraint:getRestitutionDirAng () end
---* 
---@return float
function Physics3DSliderConstraint:getTargetAngMotorVelocity () end
---* 
---@param restitutionLimLin float
---@return self
function Physics3DSliderConstraint:setRestitutionLimLin (restitutionLimLin) end
---* 
---@return float
function Physics3DSliderConstraint:getMaxLinMotorForce () end
---* 
---@param dampingOrthoLin float
---@return self
function Physics3DSliderConstraint:setDampingOrthoLin (dampingOrthoLin) end
---* 
---@param softnessOrthoAng float
---@return self
function Physics3DSliderConstraint:setSoftnessOrthoAng (softnessOrthoAng) end
---* 
---@param dampingLimLin float
---@return self
function Physics3DSliderConstraint:setDampingLimLin (dampingLimLin) end
---* 
---@param softnessDirLin float
---@return self
function Physics3DSliderConstraint:setSoftnessDirLin (softnessDirLin) end
---* 
---@param maxAngMotorForce float
---@return self
function Physics3DSliderConstraint:setMaxAngMotorForce (maxAngMotorForce) end
---* 
---@return float
function Physics3DSliderConstraint:getSoftnessDirLin () end
---* 
---@param softnessLimAng float
---@return self
function Physics3DSliderConstraint:setSoftnessLimAng (softnessLimAng) end
---* use A's frame as linear reference
---@return boolean
function Physics3DSliderConstraint:getUseLinearReferenceFrameA () end
---* create slider constraint<br>
---* param rbA rigid body A<br>
---* param rbB rigid body B<br>
---* param frameInA frame in A's local space<br>
---* param frameInB frame in B's local space<br>
---* param useLinearReferenceFrameA use fixed frame A for linear limits
---@param rbA cc.Physics3DRigidBody
---@param rbB cc.Physics3DRigidBody
---@param frameInA mat4_table
---@param frameInB mat4_table
---@param useLinearReferenceFrameA boolean
---@return self
function Physics3DSliderConstraint:create (rbA,rbB,frameInA,frameInB,useLinearReferenceFrameA) end
---* 
---@return self
function Physics3DSliderConstraint:Physics3DSliderConstraint () end