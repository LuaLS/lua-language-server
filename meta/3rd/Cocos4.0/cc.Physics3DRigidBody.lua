---@meta

---@class cc.Physics3DRigidBody :cc.Physics3DObject
local Physics3DRigidBody={ }
cc.Physics3DRigidBody=Physics3DRigidBody




---*  Set the acceleration. 
---@param acceleration vec3_table
---@return self
function Physics3DRigidBody:setGravity (acceleration) end
---*  Get friction. 
---@return float
function Physics3DRigidBody:getFriction () end
---@overload fun(vec3_table0:float):self
---@overload fun(vec3_table:vec3_table):self
---@param angFac vec3_table
---@return self
function Physics3DRigidBody:setAngularFactor (angFac) end
---* 
---@param constraint cc.Physics3DConstraint
---@return self
function Physics3DRigidBody:addConstraint (constraint) end
---*  Get the pointer of btRigidBody. 
---@return btRigidBody
function Physics3DRigidBody:getRigidBody () end
---*  Get total force. 
---@return vec3_table
function Physics3DRigidBody:getTotalForce () end
---*  Get the total number of constraints. 
---@return unsigned_int
function Physics3DRigidBody:getConstraintCount () end
---* Apply a central force.<br>
---* param   force the value of the force
---@param force vec3_table
---@return self
function Physics3DRigidBody:applyCentralForce (force) end
---*  Set mass and inertia. 
---@param mass float
---@param inertia vec3_table
---@return self
function Physics3DRigidBody:setMassProps (mass,inertia) end
---*  Set friction. 
---@param frict float
---@return self
function Physics3DRigidBody:setFriction (frict) end
---*  Set kinematic object. 
---@param kinematic boolean
---@return self
function Physics3DRigidBody:setKinematic (kinematic) end
---*  Set linear damping and angular damping. 
---@param lin_damping float
---@param ang_damping float
---@return self
function Physics3DRigidBody:setDamping (lin_damping,ang_damping) end
---* Apply a impulse.<br>
---* param   impulse the value of the impulse<br>
---* param   rel_pos the position of the impulse
---@param impulse vec3_table
---@param rel_pos vec3_table
---@return self
function Physics3DRigidBody:applyImpulse (impulse,rel_pos) end
---*  Check rigid body is kinematic object. 
---@return boolean
function Physics3DRigidBody:isKinematic () end
---* Apply a torque.<br>
---* param   torque the value of the torque
---@param torque vec3_table
---@return self
function Physics3DRigidBody:applyTorque (torque) end
---*  Set motion threshold, don't do continuous collision detection if the motion (in one step) is less then ccdMotionThreshold 
---@param ccdMotionThreshold float
---@return self
function Physics3DRigidBody:setCcdMotionThreshold (ccdMotionThreshold) end
---*  Set rolling friction. 
---@param frict float
---@return self
function Physics3DRigidBody:setRollingFriction (frict) end
---*  Get motion threshold. 
---@return float
function Physics3DRigidBody:getCcdMotionThreshold () end
---*  Get the linear factor. 
---@return vec3_table
function Physics3DRigidBody:getLinearFactor () end
---*  Damps the velocity, using the given linearDamping and angularDamping. 
---@param timeStep float
---@return self
function Physics3DRigidBody:applyDamping (timeStep) end
---*  Get the angular velocity. 
---@return vec3_table
function Physics3DRigidBody:getAngularVelocity () end
---* 
---@param info cc.Physics3DRigidBodyDes
---@return boolean
function Physics3DRigidBody:init (info) end
---* Apply a torque impulse.<br>
---* param   torque the value of the torque
---@param torque vec3_table
---@return self
function Physics3DRigidBody:applyTorqueImpulse (torque) end
---*  Active or inactive. 
---@param active boolean
---@return self
function Physics3DRigidBody:setActive (active) end
---*  Set the linear factor. 
---@param linearFactor vec3_table
---@return self
function Physics3DRigidBody:setLinearFactor (linearFactor) end
---*  Set the linear velocity. 
---@param lin_vel vec3_table
---@return self
function Physics3DRigidBody:setLinearVelocity (lin_vel) end
---*  Get the linear velocity. 
---@return vec3_table
function Physics3DRigidBody:getLinearVelocity () end
---*  Set swept sphere radius. 
---@param radius float
---@return self
function Physics3DRigidBody:setCcdSweptSphereRadius (radius) end
---* Apply a force.<br>
---* param   force the value of the force<br>
---* param   rel_pos the position of the force
---@param force vec3_table
---@param rel_pos vec3_table
---@return self
function Physics3DRigidBody:applyForce (force,rel_pos) end
---*  Set the angular velocity. 
---@param ang_vel vec3_table
---@return self
function Physics3DRigidBody:setAngularVelocity (ang_vel) end
---* Apply a central impulse.<br>
---* param   impulse the value of the impulse
---@param impulse vec3_table
---@return self
function Physics3DRigidBody:applyCentralImpulse (impulse) end
---*  Get the acceleration. 
---@return vec3_table
function Physics3DRigidBody:getGravity () end
---*  Get rolling friction. 
---@return float
function Physics3DRigidBody:getRollingFriction () end
---*  Set the center of mass. 
---@param xform mat4_table
---@return self
function Physics3DRigidBody:setCenterOfMassTransform (xform) end
---*  Set the inverse of local inertia. 
---@param diagInvInertia vec3_table
---@return self
function Physics3DRigidBody:setInvInertiaDiagLocal (diagInvInertia) end
---@overload fun(cc.Physics3DConstraint0:unsigned_int):self
---@overload fun(cc.Physics3DConstraint:cc.Physics3DConstraint):self
---@param constraint cc.Physics3DConstraint
---@return self
function Physics3DRigidBody:removeConstraint (constraint) end
---*  Get total torque. 
---@return vec3_table
function Physics3DRigidBody:getTotalTorque () end
---*  Get inverse of mass. 
---@return float
function Physics3DRigidBody:getInvMass () end
---*  Get constraint by index. 
---@param idx unsigned_int
---@return cc.Physics3DConstraint
function Physics3DRigidBody:getConstraint (idx) end
---*  Get restitution. 
---@return float
function Physics3DRigidBody:getRestitution () end
---*  Get swept sphere radius. 
---@return float
function Physics3DRigidBody:getCcdSweptSphereRadius () end
---*  Get hit friction. 
---@return float
function Physics3DRigidBody:getHitFraction () end
---*  Get angular damping. 
---@return float
function Physics3DRigidBody:getAngularDamping () end
---*  Get the inverse of local inertia. 
---@return vec3_table
function Physics3DRigidBody:getInvInertiaDiagLocal () end
---*  Get the center of mass. 
---@return mat4_table
function Physics3DRigidBody:getCenterOfMassTransform () end
---*  Get the angular factor. 
---@return vec3_table
function Physics3DRigidBody:getAngularFactor () end
---*  Set restitution. 
---@param rest float
---@return self
function Physics3DRigidBody:setRestitution (rest) end
---*  Set hit friction. 
---@param hitFraction float
---@return self
function Physics3DRigidBody:setHitFraction (hitFraction) end
---*  Get linear damping. 
---@return float
function Physics3DRigidBody:getLinearDamping () end
---*  override. 
---@return mat4_table
function Physics3DRigidBody:getWorldTransform () end
---* 
---@return self
function Physics3DRigidBody:Physics3DRigidBody () end