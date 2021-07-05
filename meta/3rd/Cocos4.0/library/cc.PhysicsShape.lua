---@meta

---@class cc.PhysicsShape :cc.Ref
local PhysicsShape={ }
cc.PhysicsShape=PhysicsShape




---* Get this shape's friction.<br>
---* return A float number.
---@return float
function PhysicsShape:getFriction () end
---* Set the group of body.<br>
---* Collision groups let you specify an integral group index. You can have all fixtures with the same group index always collide (positive index) or never collide (negative index).<br>
---* param group An integer number, it have high priority than bit masks.
---@param group int
---@return self
function PhysicsShape:setGroup (group) end
---* Set this shape's density.<br>
---* It will change the body's mass this shape attaches.<br>
---* param density A float number.
---@param density float
---@return self
function PhysicsShape:setDensity (density) end
---* Get the mass of this shape.<br>
---* return A float number.
---@return float
function PhysicsShape:getMass () end
---* Get this shape's PhysicsMaterial object.<br>
---* return A PhysicsMaterial object reference.
---@return cc.PhysicsMaterial
function PhysicsShape:getMaterial () end
---* 
---@param sensor boolean
---@return self
function PhysicsShape:setSensor (sensor) end
---* Get a mask that defines which categories of physics bodies can collide with this physics body.<br>
---* return An integer number.
---@return int
function PhysicsShape:getCollisionBitmask () end
---* Return this shape's area.<br>
---* return A float number.
---@return float
function PhysicsShape:getArea () end
---* Set a mask that defines which categories this physics body belongs to.<br>
---* Every physics body in a scene can be assigned to up to 32 different categories, each corresponding to a bit in the bit mask. You define the mask values used in your game. In conjunction with the collisionBitMask and contactTestBitMask properties, you define which physics bodies interact with each other and when your game is notified of these interactions.<br>
---* param bitmask An integer number, the default value is 0xFFFFFFFF (all bits set).
---@param bitmask int
---@return self
function PhysicsShape:setCategoryBitmask (bitmask) end
---* Get the group of body.<br>
---* return An integer number.
---@return int
function PhysicsShape:getGroup () end
---* Set this shape's moment.<br>
---* It will change the body's moment this shape attaches.<br>
---* param moment A float number.
---@param moment float
---@return self
function PhysicsShape:setMoment (moment) end
---* Test point is inside this shape or not.<br>
---* param point A Vec2 object.<br>
---* return A bool object.
---@param point vec2_table
---@return boolean
function PhysicsShape:containsPoint (point) end
---* Get a mask that defines which categories this physics body belongs to.<br>
---* return An integer number.
---@return int
function PhysicsShape:getCategoryBitmask () end
---* 
---@return boolean
function PhysicsShape:isSensor () end
---* Return this shape's type.<br>
---* return A Type object.
---@return int
function PhysicsShape:getType () end
---* Get a mask that defines which categories of bodies cause intersection notifications with this physics body.<br>
---* return An integer number.
---@return int
function PhysicsShape:getContactTestBitmask () end
---* Get this shape's center position.<br>
---* This function should be overridden in inherit classes.<br>
---* return A Vec2 object.
---@return vec2_table
function PhysicsShape:getCenter () end
---* Get this shape's density.<br>
---* return A float number.
---@return float
function PhysicsShape:getDensity () end
---* Set this shape's mass.<br>
---* It will change the body's mass this shape attaches.<br>
---* param mass A float number.
---@param mass float
---@return self
function PhysicsShape:setMass (mass) end
---* Get this shape's tag.<br>
---* return An integer number.
---@return int
function PhysicsShape:getTag () end
---* Calculate the default moment value.<br>
---* This function should be overridden in inherit classes.<br>
---* return A float number, equals 0.0.
---@return float
function PhysicsShape:calculateDefaultMoment () end
---* A mask that defines which categories of physics bodies can collide with this physics body.<br>
---* When two physics bodies contact each other, a collision may occur. This body's collision mask is compared to the other body's category mask by performing a logical AND operation. If the result is a non-zero value, then this body is affected by the collision. Each body independently chooses whether it wants to be affected by the other body. For example, you might use this to avoid collision calculations that would make negligible changes to a body's velocity.<br>
---* param bitmask An integer number, the default value is 0xFFFFFFFF (all bits set).
---@param bitmask int
---@return self
function PhysicsShape:setCollisionBitmask (bitmask) end
---* Get this shape's moment.<br>
---* return A float number.
---@return float
function PhysicsShape:getMoment () end
---* Get this shape's position offset.<br>
---* This function should be overridden in inherit classes.<br>
---* return A Vec2 object.
---@return vec2_table
function PhysicsShape:getOffset () end
---* Get this shape's restitution.<br>
---* return A float number.
---@return float
function PhysicsShape:getRestitution () end
---* Set this shape's friction.<br>
---* It will change the shape's friction.<br>
---* param friction A float number.
---@param friction float
---@return self
function PhysicsShape:setFriction (friction) end
---* Set this shape's material.<br>
---* It will change the shape's mass, elasticity and friction.<br>
---* param material A PhysicsMaterial object.
---@param material cc.PhysicsMaterial
---@return self
function PhysicsShape:setMaterial (material) end
---* Set this shape's tag.<br>
---* param tag An integer number that identifies a shape object.
---@param tag int
---@return self
function PhysicsShape:setTag (tag) end
---* A mask that defines which categories of bodies cause intersection notifications with this physics body.<br>
---* When two bodies share the same space, each body's category mask is tested against the other body's contact mask by performing a logical AND operation. If either comparison results in a non-zero value, an PhysicsContact object is created and passed to the physics world’s delegate. For best performance, only set bits in the contacts mask for interactions you are interested in.<br>
---* param bitmask An integer number, the default value is 0x00000000 (all bits cleared).
---@param bitmask int
---@return self
function PhysicsShape:setContactTestBitmask (bitmask) end
---* Set this shape's restitution.<br>
---* It will change the shape's elasticity.<br>
---* param restitution A float number.
---@param restitution float
---@return self
function PhysicsShape:setRestitution (restitution) end
---* Get the body that this shape attaches.<br>
---* return A PhysicsBody object pointer.
---@return cc.PhysicsBody
function PhysicsShape:getBody () end