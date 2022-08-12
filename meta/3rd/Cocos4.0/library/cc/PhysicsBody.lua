---@meta

---@class cc.PhysicsBody :cc.Component
local PhysicsBody={ }
cc.PhysicsBody=PhysicsBody




---*  Whether this physics body is affected by the physics world's gravitational force. 
---@return boolean
function PhysicsBody:isGravityEnabled () end
---* reset all the force applied to body. 
---@return self
function PhysicsBody:resetForces () end
---*  get the max of velocity 
---@return float
function PhysicsBody:getVelocityLimit () end
---* Set the group of body.<br>
---* Collision groups let you specify an integral group index. You can have all fixtures with the same group index always collide (positive index) or never collide (negative index).<br>
---* It have high priority than bit masks.
---@param group int
---@return self
function PhysicsBody:setGroup (group) end
---*  Get the body mass. 
---@return float
function PhysicsBody:getMass () end
---* Return bitmask of first shape.<br>
---* return If there is no shape in body, return default value.(0xFFFFFFFF)
---@return int
function PhysicsBody:getCollisionBitmask () end
---*  set the body rotation offset 
---@return float
function PhysicsBody:getRotationOffset () end
---*  get the body rotation. 
---@return float
function PhysicsBody:getRotation () end
---*  Get the body moment of inertia. 
---@return float
function PhysicsBody:getMoment () end
---* Applies a immediate force to body.<br>
---* param impulse The impulse is applies to this body.<br>
---* param offset A Vec2 object, it is the offset from the body's center of gravity in world coordinates.
---@param impulse vec2_table
---@param offset vec2_table
---@return self
function PhysicsBody:applyImpulse (impulse,offset) end
---*  set body rotation offset, it's the rotation witch relative to node 
---@param rotation float
---@return self
function PhysicsBody:setRotationOffset (rotation) end
---* Applies a continuous force to body.<br>
---* param force The force is applies to this body.<br>
---* param offset A Vec2 object, it is the offset from the body's center of gravity in world coordinates.
---@param force vec2_table
---@param offset vec2_table
---@return self
function PhysicsBody:applyForce (force,offset) end
---* brief Add a shape to body.<br>
---* param shape The shape to be added.<br>
---* param addMassAndMoment If this is true, the shape's mass and moment will be added to body. The default is true.<br>
---* return This shape's pointer if added success or nullptr if failed.
---@param shape cc.PhysicsShape
---@param addMassAndMoment boolean
---@return cc.PhysicsShape
function PhysicsBody:addShape (shape,addMassAndMoment) end
---* Applies a torque force to body.<br>
---* param torque The torque is applies to this body.
---@param torque float
---@return self
function PhysicsBody:applyTorque (torque) end
---*  get the max of angular velocity 
---@return float
function PhysicsBody:getAngularVelocityLimit () end
---*  set the max of angular velocity 
---@param limit float
---@return self
function PhysicsBody:setAngularVelocityLimit (limit) end
---*  Get the velocity of a body. 
---@return vec2_table
function PhysicsBody:getVelocity () end
---*  get linear damping. 
---@return float
function PhysicsBody:getLinearDamping () end
---* Remove all shapes.<br>
---* param reduceMassAndMoment If this is true, the body mass and moment will be reduced by shape. The default is true.
---@return self
function PhysicsBody:removeAllShapes () end
---* Set angular damping.<br>
---* It is used to simulate fluid or air friction forces on the body.<br>
---* param damping The value is 0.0f to 1.0f.
---@param damping float
---@return self
function PhysicsBody:setAngularDamping (damping) end
---*  set the max of velocity 
---@param limit float
---@return self
function PhysicsBody:setVelocityLimit (limit) end
---*  set body to rest 
---@param rest boolean
---@return self
function PhysicsBody:setResting (rest) end
---*  get body position offset. 
---@return vec2_table
function PhysicsBody:getPositionOffset () end
---* A mask that defines which categories this physics body belongs to.<br>
---* Every physics body in a scene can be assigned to up to 32 different categories, each corresponding to a bit in the bit mask. You define the mask values used in your game. In conjunction with the collisionBitMask and contactTestBitMask properties, you define which physics bodies interact with each other and when your game is notified of these interactions.<br>
---* param bitmask An integer number, the default value is 0xFFFFFFFF (all bits set).
---@param bitmask int
---@return self
function PhysicsBody:setCategoryBitmask (bitmask) end
---*  get the world body added to. 
---@return cc.PhysicsWorld
function PhysicsBody:getWorld () end
---*  get the angular velocity of a body 
---@return float
function PhysicsBody:getAngularVelocity () end
---*  get the body position. 
---@return vec2_table
function PhysicsBody:getPosition () end
---*  Set the body is affected by the physics world's gravitational force or not. 
---@param enable boolean
---@return self
function PhysicsBody:setGravityEnable (enable) end
---* Return group of first shape.<br>
---* return If there is no shape in body, return default value.(0) 
---@return int
function PhysicsBody:getGroup () end
---* brief Set the body moment of inertia.<br>
---* note If you need add/subtract moment to body, don't use setMoment(getMoment() +/- moment), because the moment of body may be equal to PHYSICS_INFINITY, it will cause some unexpected result, please use addMoment() instead.
---@param moment float
---@return self
function PhysicsBody:setMoment (moment) end
---*  Get the body's tag. 
---@return int
function PhysicsBody:getTag () end
---*  Convert the local point to world. 
---@param point vec2_table
---@return vec2_table
function PhysicsBody:local2World (point) end
---* Return bitmask of first shape.<br>
---* return If there is no shape in body, return default value.(0xFFFFFFFF)
---@return int
function PhysicsBody:getCategoryBitmask () end
---* brief Set dynamic to body.<br>
---* A dynamic body will effect with gravity.
---@param dynamic boolean
---@return self
function PhysicsBody:setDynamic (dynamic) end
---* Get the first shape of the body shapes.<br>
---* return The first shape in this body.
---@return cc.PhysicsShape
function PhysicsBody:getFirstShape () end
---* Get the body shapes.<br>
---* return A Vector<PhysicsShape*> object contains PhysicsShape pointer.
---@return array_table
function PhysicsBody:getShapes () end
---* Return bitmask of first shape.<br>
---* return If there is no shape in body, return default value.(0x00000000)
---@return int
function PhysicsBody:getContactTestBitmask () end
---* Set the angular velocity of a body.<br>
---* param velocity The angular velocity is set to this body.
---@param velocity float
---@return self
function PhysicsBody:setAngularVelocity (velocity) end
---*  Convert the world point to local. 
---@param point vec2_table
---@return vec2_table
function PhysicsBody:world2Local (point) end
---@overload fun(cc.PhysicsShape0:int,boolean:boolean):self
---@overload fun(cc.PhysicsShape:cc.PhysicsShape,boolean:boolean):self
---@param shape cc.PhysicsShape
---@param reduceMassAndMoment boolean
---@return self
function PhysicsBody:removeShape (shape,reduceMassAndMoment) end
---* brief Set the body mass.<br>
---* attention If you need add/subtract mass to body, don't use setMass(getMass() +/- mass), because the mass of body may be equal to PHYSICS_INFINITY, it will cause some unexpected result, please use addMass() instead.
---@param mass float
---@return self
function PhysicsBody:setMass (mass) end
---* brief Add moment of inertia to body.<br>
---* param moment If _moment(moment of the body) == PHYSICS_INFINITY, it remains.<br>
---* if moment == PHYSICS_INFINITY, _moment will be PHYSICS_INFINITY.<br>
---* if moment == -PHYSICS_INFINITY, _moment will not change.<br>
---* if moment + _moment <= 0, _moment will equal to MASS_DEFAULT(1.0)<br>
---* other wise, moment = moment + _moment;
---@param moment float
---@return self
function PhysicsBody:addMoment (moment) end
---* Set the velocity of a body.<br>
---* param velocity The velocity is set to this body.
---@param velocity vec2_table
---@return self
function PhysicsBody:setVelocity (velocity) end
---* Set linear damping.<br>
---* it is used to simulate fluid or air friction forces on the body.<br>
---* param damping The value is 0.0f to 1.0f.
---@param damping float
---@return self
function PhysicsBody:setLinearDamping (damping) end
---* A mask that defines which categories of physics bodies can collide with this physics body.<br>
---* When two physics bodies contact each other, a collision may occur. This body's collision mask is compared to the other body's category mask by performing a logical AND operation. If the result is a non-zero value, then this body is affected by the collision. Each body independently chooses whether it wants to be affected by the other body. For example, you might use this to avoid collision calculations that would make negligible changes to a body's velocity.<br>
---* param bitmask An integer number, the default value is 0xFFFFFFFF (all bits set).
---@param bitmask int
---@return self
function PhysicsBody:setCollisionBitmask (bitmask) end
---*  set body position offset, it's the position witch relative to node 
---@param position vec2_table
---@return self
function PhysicsBody:setPositionOffset (position) end
---*  Set the body is allow rotation or not 
---@param enable boolean
---@return self
function PhysicsBody:setRotationEnable (enable) end
---*  Whether the body can rotation. 
---@return boolean
function PhysicsBody:isRotationEnabled () end
---*  Get the rigid body of chipmunk. 
---@return cpBody
function PhysicsBody:getCPBody () end
---*  Get angular damping. 
---@return float
function PhysicsBody:getAngularDamping () end
---*  Get the angular velocity of a body at a local point.
---@param point vec2_table
---@return vec2_table
function PhysicsBody:getVelocityAtLocalPoint (point) end
---*  Whether the body is at rest. 
---@return boolean
function PhysicsBody:isResting () end
---* brief Add mass to body.<br>
---* param mass If _mass(mass of the body) == PHYSICS_INFINITY, it remains.<br>
---* if mass == PHYSICS_INFINITY, _mass will be PHYSICS_INFINITY.<br>
---* if mass == -PHYSICS_INFINITY, _mass will not change.<br>
---* if mass + _mass <= 0, _mass will equal to MASS_DEFAULT(1.0)<br>
---* other wise, mass = mass + _mass;
---@param mass float
---@return self
function PhysicsBody:addMass (mass) end
---* get the shape of the body.<br>
---* param   tag   An integer number that identifies a PhysicsShape object.<br>
---* return A PhysicsShape object pointer or nullptr if no shapes were found.
---@param tag int
---@return cc.PhysicsShape
function PhysicsBody:getShape (tag) end
---*  set the body's tag. 
---@param tag int
---@return self
function PhysicsBody:setTag (tag) end
---*  get the angular velocity of a body at a world point 
---@param point vec2_table
---@return vec2_table
function PhysicsBody:getVelocityAtWorldPoint (point) end
---* A mask that defines which categories of bodies cause intersection notifications with this physics body.<br>
---* When two bodies share the same space, each body's category mask is tested against the other body's contact mask by performing a logical AND operation. If either comparison results in a non-zero value, an PhysicsContact object is created and passed to the physics world’s delegate. For best performance, only set bits in the contacts mask for interactions you are interested in.<br>
---* param bitmask An integer number, the default value is 0x00000000 (all bits cleared).
---@param bitmask int
---@return self
function PhysicsBody:setContactTestBitmask (bitmask) end
---*  remove the body from the world it added to 
---@return self
function PhysicsBody:removeFromWorld () end
---* brief Test the body is dynamic or not.<br>
---* A dynamic body will effect with gravity.
---@return boolean
function PhysicsBody:isDynamic () end
---*  get the node the body set to. 
---@return cc.Node
function PhysicsBody:getNode () end
---* Create a body contains a box shape.<br>
---* param   size Size contains this box's width and height.<br>
---* param   material A PhysicsMaterial object, the default value is PHYSICSSHAPE_MATERIAL_DEFAULT.<br>
---* param   offset A Vec2 object, it is the offset from the body's center of gravity in body local coordinates.<br>
---* return  An autoreleased PhysicsBody object pointer.
---@param size size_table
---@param material cc.PhysicsMaterial
---@param offset vec2_table
---@return self
function PhysicsBody:createBox (size,material,offset) end
---* Create a body contains a EdgeSegment shape.<br>
---* param   a It's the edge's begin position.<br>
---* param   b It's the edge's end position.<br>
---* param   material A PhysicsMaterial object, the default value is PHYSICSSHAPE_MATERIAL_DEFAULT.<br>
---* param   border It's a edge's border width.<br>
---* return  An autoreleased PhysicsBody object pointer.
---@param a vec2_table
---@param b vec2_table
---@param material cc.PhysicsMaterial
---@param border float
---@return self
function PhysicsBody:createEdgeSegment (a,b,material,border) end
---@overload fun(float:float):self
---@overload fun():self
---@overload fun(float:float,float:float):self
---@param mass float
---@param moment float
---@return self
function PhysicsBody:create (mass,moment) end
---* Create a body contains a EdgeBox shape.<br>
---* param   size Size contains this box's width and height.<br>
---* param   material A PhysicsMaterial object, the default value is PHYSICSSHAPE_MATERIAL_DEFAULT.<br>
---* param   border It's a edge's border width.<br>
---* param   offset A Vec2 object, it is the offset from the body's center of gravity in body local coordinates.<br>
---* return  An autoreleased PhysicsBody object pointer.
---@param size size_table
---@param material cc.PhysicsMaterial
---@param border float
---@param offset vec2_table
---@return self
function PhysicsBody:createEdgeBox (size,material,border,offset) end
---* Create a body contains a circle.<br>
---* param   radius A float number, it is the circle's radius.<br>
---* param   material A PhysicsMaterial object, the default value is PHYSICSSHAPE_MATERIAL_DEFAULT.<br>
---* param   offset A Vec2 object, it is the offset from the body's center of gravity in body local coordinates.<br>
---* return  An autoreleased PhysicsBody object pointer.
---@param radius float
---@param material cc.PhysicsMaterial
---@param offset vec2_table
---@return self
function PhysicsBody:createCircle (radius,material,offset) end
---* Set the enable value.<br>
---* If the body it isn't enabled, it will not has simulation by world.
---@param enable boolean
---@return self
function PhysicsBody:setEnabled (enable) end
---* 
---@return self
function PhysicsBody:onRemove () end
---* 
---@return self
function PhysicsBody:onEnter () end
---* 
---@return self
function PhysicsBody:onExit () end
---* 
---@return self
function PhysicsBody:onAdd () end