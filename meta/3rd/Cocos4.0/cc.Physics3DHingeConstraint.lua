---@meta

---@class cc.Physics3DHingeConstraint :cc.Physics3DConstraint
local Physics3DHingeConstraint={ }
cc.Physics3DHingeConstraint=Physics3DHingeConstraint




---@overload fun(mat4_table:mat4_table,mat4_table:mat4_table):self
---@overload fun():self
---@param transA mat4_table
---@param transB mat4_table
---@return float
function Physics3DHingeConstraint:getHingeAngle (transA,transB) end
---* get motor target velocity
---@return float
function Physics3DHingeConstraint:getMotorTargetVelosity () end
---* get rigid body A's frame offset
---@return mat4_table
function Physics3DHingeConstraint:getFrameOffsetA () end
---* get rigid body B's frame offset
---@return mat4_table
function Physics3DHingeConstraint:getFrameOffsetB () end
---*  set max motor impulse 
---@param maxMotorImpulse float
---@return self
function Physics3DHingeConstraint:setMaxMotorImpulse (maxMotorImpulse) end
---*  enable angular motor 
---@param enableMotor boolean
---@param targetVelocity float
---@param maxMotorImpulse float
---@return self
function Physics3DHingeConstraint:enableAngularMotor (enableMotor,targetVelocity,maxMotorImpulse) end
---* get upper limit
---@return float
function Physics3DHingeConstraint:getUpperLimit () end
---* get max motor impulse
---@return float
function Physics3DHingeConstraint:getMaxMotorImpulse () end
---* get lower limit
---@return float
function Physics3DHingeConstraint:getLowerLimit () end
---* set use frame offset
---@param frameOffsetOnOff boolean
---@return self
function Physics3DHingeConstraint:setUseFrameOffset (frameOffsetOnOff) end
---* get enable angular motor
---@return boolean
function Physics3DHingeConstraint:getEnableAngularMotor () end
---* 
---@param enableMotor boolean
---@return self
function Physics3DHingeConstraint:enableMotor (enableMotor) end
---* get B's frame
---@return mat4_table
function Physics3DHingeConstraint:getBFrame () end
---* set frames for rigid body A and B
---@param frameA mat4_table
---@param frameB mat4_table
---@return self
function Physics3DHingeConstraint:setFrames (frameA,frameB) end
---*  access for UseFrameOffset
---@return boolean
function Physics3DHingeConstraint:getUseFrameOffset () end
---* set angular only
---@param angularOnly boolean
---@return self
function Physics3DHingeConstraint:setAngularOnly (angularOnly) end
---*  set limit 
---@param low float
---@param high float
---@param _softness float
---@param _biasFactor float
---@param _relaxationFactor float
---@return self
function Physics3DHingeConstraint:setLimit (low,high,_softness,_biasFactor,_relaxationFactor) end
---* get angular only
---@return boolean
function Physics3DHingeConstraint:getAngularOnly () end
---* set axis
---@param axisInA vec3_table
---@return self
function Physics3DHingeConstraint:setAxis (axisInA) end
---* get A's frame 
---@return mat4_table
function Physics3DHingeConstraint:getAFrame () end
---@overload fun(cc.Physics3DRigidBody:cc.Physics3DRigidBody,cc.Physics3DRigidBody1:vec3_table,vec3_table:vec3_table,vec3_table3:boolean):self
---@overload fun(cc.Physics3DRigidBody:cc.Physics3DRigidBody,cc.Physics3DRigidBody1:mat4_table,vec3_table2:boolean):self
---@overload fun(cc.Physics3DRigidBody:cc.Physics3DRigidBody,cc.Physics3DRigidBody:cc.Physics3DRigidBody,vec3_table:vec3_table,vec3_table:vec3_table,vec3_table:vec3_table,vec3_table:vec3_table,boolean:boolean):self
---@overload fun(cc.Physics3DRigidBody:cc.Physics3DRigidBody,cc.Physics3DRigidBody:cc.Physics3DRigidBody,vec3_table2:mat4_table,vec3_table3:mat4_table,vec3_table4:boolean):self
---@param rbA cc.Physics3DRigidBody
---@param rbB cc.Physics3DRigidBody
---@param pivotInA vec3_table
---@param pivotInB vec3_table
---@param axisInA vec3_table
---@param axisInB vec3_table
---@param useReferenceFrameA boolean
---@return self
function Physics3DHingeConstraint:create (rbA,rbB,pivotInA,pivotInB,axisInA,axisInB,useReferenceFrameA) end
---* 
---@return self
function Physics3DHingeConstraint:Physics3DHingeConstraint () end