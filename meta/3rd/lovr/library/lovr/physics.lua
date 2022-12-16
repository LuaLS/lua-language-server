---@meta

---
---The `lovr.physics` module simulates 3D rigid body physics.
---
---@class lovr.physics
lovr.physics = {}

---
---Creates a new BallJoint.
---
---
---### NOTE:
---A ball joint is like a ball and socket between the two colliders.
---
---It tries to keep the distance between the colliders and the anchor position the same, but does not constrain the angle between them.
---
---@param colliderA lovr.Collider # The first collider to attach the Joint to.
---@param colliderB lovr.Collider # The second collider to attach the Joint to.
---@param x number # The x position of the joint anchor point, in world coordinates.
---@param y number # The y position of the joint anchor point, in world coordinates.
---@param z number # The z position of the joint anchor point, in world coordinates.
---@return lovr.BallJoint ball # The new BallJoint.
function lovr.physics.newBallJoint(colliderA, colliderB, x, y, z) end

---
---Creates a new BoxShape.
---
---
---### NOTE:
---A Shape can be attached to a Collider using `Collider:addShape`.
---
---@param width? number # The width of the box, in meters.
---@param height? number # The height of the box, in meters.
---@param depth? number # The depth of the box, in meters.
---@return lovr.BoxShape box # The new BoxShape.
function lovr.physics.newBoxShape(width, height, depth) end

---
---Creates a new CapsuleShape.
---
---Capsules are cylinders with hemispheres on each end.
---
---
---### NOTE:
---A Shape can be attached to a Collider using `Collider:addShape`.
---
---@param radius? number # The radius of the capsule, in meters.
---@param length? number # The length of the capsule, not including the caps, in meters.
---@return lovr.CapsuleShape capsule # The new CapsuleShape.
function lovr.physics.newCapsuleShape(radius, length) end

---
---Creates a new CylinderShape.
---
---
---### NOTE:
---A Shape can be attached to a Collider using `Collider:addShape`.
---
---@param radius? number # The radius of the cylinder, in meters.
---@param length? number # The length of the cylinder, in meters.
---@return lovr.CylinderShape cylinder # The new CylinderShape.
function lovr.physics.newCylinderShape(radius, length) end

---
---Creates a new DistanceJoint.
---
---
---### NOTE:
---A distance joint tries to keep the two colliders a fixed distance apart.
---
---The distance is determined by the initial distance between the anchor points.
---
---The joint allows for rotation on the anchor points.
---
---@param colliderA lovr.Collider # The first collider to attach the Joint to.
---@param colliderB lovr.Collider # The second collider to attach the Joint to.
---@param x1 number # The x position of the first anchor point, in world coordinates.
---@param y1 number # The y position of the first anchor point, in world coordinates.
---@param z1 number # The z position of the first anchor point, in world coordinates.
---@param x2 number # The x position of the second anchor point, in world coordinates.
---@param y2 number # The y position of the second anchor point, in world coordinates.
---@param z2 number # The z position of the second anchor point, in world coordinates.
---@return lovr.DistanceJoint joint # The new DistanceJoint.
function lovr.physics.newDistanceJoint(colliderA, colliderB, x1, y1, z1, x2, y2, z2) end

---
---Creates a new HingeJoint.
---
---
---### NOTE:
---A hinge joint constrains two colliders to allow rotation only around the hinge's axis.
---
---@param colliderA lovr.Collider # The first collider to attach the Joint to.
---@param colliderB lovr.Collider # The second collider to attach the Joint to.
---@param x number # The x position of the hinge anchor, in world coordinates.
---@param y number # The y position of the hinge anchor, in world coordinates.
---@param z number # The z position of the hinge anchor, in world coordinates.
---@param ax number # The x component of the hinge axis.
---@param ay number # The y component of the hinge axis.
---@param az number # The z component of the hinge axis.
---@return lovr.HingeJoint hinge # The new HingeJoint.
function lovr.physics.newHingeJoint(colliderA, colliderB, x, y, z, ax, ay, az) end

---
---Creates a new MeshShape.
---
---
---### NOTE:
---A Shape can be attached to a Collider using `Collider:addShape`.
---
---@overload fun(model: lovr.Model):lovr.MeshShape
---@param vertices table # The table of vertices in the mesh.  Each vertex is a table with 3 numbers.
---@param indices table # A table of triangle indices representing how the vertices are connected in the Mesh.
---@return lovr.MeshShape mesh # The new MeshShape.
function lovr.physics.newMeshShape(vertices, indices) end

---
---Creates a new SliderJoint.
---
---
---### NOTE:
---A slider joint constrains two colliders to only allow movement along the slider's axis.
---
---@param colliderA lovr.Collider # The first collider to attach the Joint to.
---@param colliderB lovr.Collider # The second collider to attach the Joint to.
---@param ax number # The x component of the slider axis.
---@param ay number # The y component of the slider axis.
---@param az number # The z component of the slider axis.
---@return lovr.SliderJoint slider # The new SliderJoint.
function lovr.physics.newSliderJoint(colliderA, colliderB, ax, ay, az) end

---
---Creates a new SphereShape.
---
---
---### NOTE:
---A Shape can be attached to a Collider using `Collider:addShape`.
---
---@param radius? number # The radius of the sphere, in meters.
---@return lovr.SphereShape sphere # The new SphereShape.
function lovr.physics.newSphereShape(radius) end

---
---Creates a new TerrainShape.
---
---
---### NOTE:
---A Shape can be attached to a Collider using `Collider:addShape`. For immobile terrain use the `Collider:setKinematic`.
---
---@overload fun(scale: number, heightmap: lovr.Image, stretch?: number):lovr.TerrainShape
---@overload fun(scale: number, callback: function, samples?: number):lovr.TerrainShape
---@param scale number # The width and depth of the terrain, in meters.
---@return lovr.TerrainShape terrain # The new TerrainShape.
function lovr.physics.newTerrainShape(scale) end

---
---Creates a new physics World, which tracks the overall physics simulation, holds collider objects, and resolves collisions between them.
---
---
---### NOTE:
---A World must be updated with `World:update` in `lovr.update` for the physics simulation to advance.
---
---@param xg? number # The x component of the gravity force.
---@param yg? number # The y component of the gravity force.
---@param zg? number # The z component of the gravity force.
---@param allowSleep? boolean # Whether or not colliders will automatically be put to sleep.
---@param tags table # A list of collision tags colliders can be assigned to.
---@return lovr.World world # A whole new World.
function lovr.physics.newWorld(xg, yg, zg, allowSleep, tags) end

---
---A BallJoint is a type of `Joint` that acts like a ball and socket between two colliders.
---
---It allows the colliders to rotate freely around an anchor point, but does not allow the colliders' distance from the anchor point to change.
---
---@class lovr.BallJoint
local BallJoint = {}

---
---Returns the anchor points of the BallJoint, in world coordinates.
---
---The first point is the anchor on the first collider, and the second point is on the second collider.
---
---The joint tries to keep these points the same, but they may be different if the joint is forced apart by some other means.
---
---@return number x1 # The x coordinate of the first anchor point, in world coordinates.
---@return number y1 # The y coordinate of the first anchor point, in world coordinates.
---@return number z1 # The z coordinate of the first anchor point, in world coordinates.
---@return number x2 # The x coordinate of the second anchor point, in world coordinates.
---@return number y2 # The y coordinate of the second anchor point, in world coordinates.
---@return number z2 # The z coordinate of the second anchor point, in world coordinates.
function BallJoint:getAnchors() end

---
---Returns the response time of the joint.
---
---See `World:setResponseTime` for more info.
---
---@return number responseTime # The response time setting for the joint.
function BallJoint:getResponseTime() end

---
---Returns the tightness of the joint.
---
---See `World:setTightness` for how this affects the joint.
---
---@return number tightness # The tightness of the joint.
function BallJoint:getTightness() end

---
---Sets a new anchor point for the BallJoint.
---
---@param x number # The x coordinate of the anchor point, in world coordinates.
---@param y number # The y coordinate of the anchor point, in world coordinates.
---@param z number # The z coordinate of the anchor point, in world coordinates.
function BallJoint:setAnchor(x, y, z) end

---
---Sets the response time of the joint.
---
---See `World:setResponseTime` for more info.
---
---@param responseTime number # The new response time setting for the joint.
function BallJoint:setResponseTime(responseTime) end

---
---Sets the tightness of the joint.
---
---See `World:setTightness` for how this affects the joint.
---
---@param tightness number # The tightness of the joint.
function BallJoint:setTightness(tightness) end

---
---A type of `Shape` that can be used for cubes or boxes.
---
---@class lovr.BoxShape
local BoxShape = {}

---
---Returns the width, height, and depth of the BoxShape.
---
---@return number width # The width of the box, in meters.
---@return number height # The height of the box, in meters.
---@return number depth # The depth of the box, in meters.
function BoxShape:getDimensions() end

---
---Sets the width, height, and depth of the BoxShape.
---
---@param width number # The width of the box, in meters.
---@param height number # The height of the box, in meters.
---@param depth number # The depth of the box, in meters.
function BoxShape:setDimensions(width, height, depth) end

---
---A type of `Shape` that can be used for capsule-shaped things.
---
---@class lovr.CapsuleShape
local CapsuleShape = {}

---
---Returns the length of the CapsuleShape, not including the caps.
---
---@return number length # The length of the capsule, in meters.
function CapsuleShape:getLength() end

---
---Returns the radius of the CapsuleShape.
---
---@return number radius # The radius of the capsule, in meters.
function CapsuleShape:getRadius() end

---
---Sets the length of the CapsuleShape.
---
---@param length number # The new length, in meters, not including the caps.
function CapsuleShape:setLength(length) end

---
---Sets the radius of the CapsuleShape.
---
---@param radius number # The new radius, in meters.
function CapsuleShape:setRadius(radius) end

---
---Colliders are objects that represent a single rigid body in a physics simulation.
---
---They can have forces applied to them and collide with other colliders.
---
---@class lovr.Collider
local Collider = {}

---
---Attaches a Shape to the collider.
---
---Attached shapes will collide with other shapes in the world.
---
---@param shape lovr.Shape # The Shape to attach.
function Collider:addShape(shape) end

---
---Applies a force to the Collider.
---
---
---### NOTE:
---If the Collider is asleep, it will need to be woken up with `Collider:setAwake` for this function to have any affect.
---
---@overload fun(self: lovr.Collider, x: number, y: number, z: number, px: number, py: number, pz: number)
---@param x number # The x component of the force to apply.
---@param y number # The y component of the force to apply.
---@param z number # The z component of the force to apply.
function Collider:applyForce(x, y, z) end

---
---Applies torque to the Collider.
---
---
---### NOTE:
---If the Collider is asleep, it will need to be woken up with `Collider:setAwake` for this function to have any effect.
---
---@param x number # The x component of the torque.
---@param y number # The y component of the torque.
---@param z number # The z component of the torque.
function Collider:applyTorque(x, y, z) end

---
---Destroy the Collider, removing it from the World.
---
---
---### NOTE:
---Calling functions on the collider after destroying it is a bad idea.
---
function Collider:destroy() end

---
---Returns the bounding box for the Collider, computed from attached shapes.
---
---@return number minx # The minimum x coordinate of the box.
---@return number maxx # The maximum x coordinate of the box.
---@return number miny # The minimum y coordinate of the box.
---@return number maxy # The maximum y coordinate of the box.
---@return number minz # The minimum z coordinate of the box.
---@return number maxz # The maximum z coordinate of the box.
function Collider:getAABB() end

---
---Returns the angular damping parameters of the Collider.
---
---Angular damping makes things less "spinny", making them slow down their angular velocity over time.
---
---
---### NOTE:
---Angular damping can also be set on the World.
---
---@return number damping # The angular damping.
---@return number threshold # Velocity limit below which the damping is not applied.
function Collider:getAngularDamping() end

---
---Returns the angular velocity of the Collider.
---
---@return number vx # The x component of the angular velocity.
---@return number vy # The y component of the angular velocity.
---@return number vz # The z component of the angular velocity.
function Collider:getAngularVelocity() end

---
---Returns the friction of the Collider.
---
---By default, the friction of two Colliders is combined (multiplied) when they collide to generate a friction force.
---
---The initial friction is 0.
---
---@return number friction # The friction of the Collider.
function Collider:getFriction() end

---
---Returns a list of Joints attached to the Collider.
---
---@return table joints # A list of Joints attached to the Collider.
function Collider:getJoints() end

---
---Returns the Collider's linear damping parameters.
---
---Linear damping is similar to drag or air resistance, slowing the Collider down over time.
---
---
---### NOTE:
---A linear damping of 0 means the Collider won't slow down over time.
---
---This is the default.
---
---Linear damping can also be set on the World using `World:setLinearDamping`, which will affect all new colliders.
---
---@return number damping # The linear damping.
---@return number threshold # Velocity limit below which the damping is not applied.
function Collider:getLinearDamping() end

---
---Returns the linear velocity of the Collider.
---
---This is how fast the Collider is moving.
---
---There is also angular velocity, which is how fast the Collider is spinning.
---
---@return number vx # The x velocity of the Collider, in meters per second.
---@return number vy # The y velocity of the Collider, in meters per second.
---@return number vz # The z velocity of the Collider, in meters per second.
function Collider:getLinearVelocity() end

---
---Returns the linear velocity of a point relative to the Collider.
---
---@param x number # The x coordinate.
---@param y number # The y coordinate.
---@param z number # The z coordinate.
---@return number vx # The x component of the velocity of the point.
---@return number vy # The y component of the velocity of the point.
---@return number vz # The z component of the velocity of the point.
function Collider:getLinearVelocityFromLocalPoint(x, y, z) end

---
---Returns the linear velocity of a point on the Collider specified in world space.
---
---@param x number # The x coordinate in world space.
---@param y number # The y coordinate in world space.
---@param z number # The z coordinate in world space.
---@return number vx # The x component of the velocity of the point.
---@return number vy # The y component of the velocity of the point.
---@return number vz # The z component of the velocity of the point.
function Collider:getLinearVelocityFromWorldPoint(x, y, z) end

---
---Returns the Collider's center of mass.
---
---@return number cx # The x position of the center of mass.
---@return number cy # The y position of the center of mass.
---@return number cz # The z position of the center of mass.
function Collider:getLocalCenter() end

---
---Converts a point from world coordinates into local coordinates relative to the Collider.
---
---@param wx number # The x coordinate of the world point.
---@param wy number # The y coordinate of the world point.
---@param wz number # The z coordinate of the world point.
---@return number x # The x position of the local-space point.
---@return number y # The y position of the local-space point.
---@return number z # The z position of the local-space point.
function Collider:getLocalPoint(wx, wy, wz) end

---
---Converts a direction vector from world space to local space.
---
---@param wx number # The x component of the world vector.
---@param wy number # The y component of the world vector.
---@param wz number # The z component of the world vector.
---@return number x # The x coordinate of the local vector.
---@return number y # The y coordinate of the local vector.
---@return number z # The z coordinate of the local vector.
function Collider:getLocalVector(wx, wy, wz) end

---
---Returns the total mass of the Collider.
---
---The mass of a Collider depends on its attached shapes.
---
---@return number mass # The mass of the Collider, in kilograms.
function Collider:getMass() end

---
---Computes mass properties for the Collider.
---
---@return number cx # The x position of the center of mass.
---@return number cy # The y position of the center of mass.
---@return number cz # The z position of the center of mass.
---@return number mass # The computed mass of the Collider.
---@return table inertia # A table containing 6 values of the rotational inertia tensor matrix.  The table contains the 3 diagonal elements of the matrix (upper left to bottom right), followed by the 3 elements of the upper right portion of the 3x3 matrix.
function Collider:getMassData() end

---
---Returns the orientation of the Collider in angle/axis representation.
---
---@return number angle # The number of radians the Collider is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function Collider:getOrientation() end

---
---Returns the position and orientation of the Collider.
---
---@return number x # The x position of the Collider, in meters.
---@return number y # The y position of the Collider, in meters.
---@return number z # The z position of the Collider, in meters.
---@return number angle # The number of radians the Collider is rotated around its axis of rotation.
---@return number ax # The x component of the axis of rotation.
---@return number ay # The y component of the axis of rotation.
---@return number az # The z component of the axis of rotation.
function Collider:getPose() end

---
---Returns the position of the Collider.
---
---@return number x # The x position of the Collider, in meters.
---@return number y # The y position of the Collider, in meters.
---@return number z # The z position of the Collider, in meters.
function Collider:getPosition() end

---
---Returns the restitution (bounciness) of the Collider.
---
---By default, the restitution of two Colliders is combined (the max is used) when they collide to cause them to bounce away from each other.
---
---The initial restitution is 0.
---
---@return number restitution # The restitution of the Collider.
function Collider:getRestitution() end

---
---Returns a list of Shapes attached to the Collider.
---
---@return table shapes # A list of Shapes attached to the Collider.
function Collider:getShapes() end

---
---Returns the Collider's tag.
---
---
---### NOTE:
---Collision between tags can be enabled and disabled using `World:enableCollisionBetween` and `World:disableCollisionBetween`.
---
---@return string tag # The Collider's collision tag.
function Collider:getTag() end

---
---Returns the user data associated with the Collider.
---
---
---### NOTE:
---User data can be useful to identify the Collider in callbacks.
---
---@return any data # The custom value associated with the Collider.
function Collider:getUserData() end

---
---Returns the World the Collider is in.
---
---
---### NOTE:
---Colliders can only be in one World at a time.
---
---@return lovr.World world # The World the Collider is in.
function Collider:getWorld() end

---
---Convert a point relative to the collider to a point in world coordinates.
---
---@param x number # The x position of the point.
---@param y number # The y position of the point.
---@param z number # The z position of the point.
---@return number wx # The x coordinate of the world point.
---@return number wy # The y coordinate of the world point.
---@return number wz # The z coordinate of the world point.
function Collider:getWorldPoint(x, y, z) end

---
---Converts a direction vector from local space to world space.
---
---@param x number # The x coordinate of the local vector.
---@param y number # The y coordinate of the local vector.
---@param z number # The z coordinate of the local vector.
---@return number wx # The x component of the world vector.
---@return number wy # The y component of the world vector.
---@return number wz # The z component of the world vector.
function Collider:getWorldVector(x, y, z) end

---
---Returns whether the Collider is currently awake.
---
---@return boolean awake # Whether the Collider is awake.
function Collider:isAwake() end

---
---Returns whether the Collider is currently ignoring gravity.
---
---@return boolean ignored # Whether gravity is ignored for this Collider.
function Collider:isGravityIgnored() end

---
---Returns whether the Collider is kinematic.
---
---
---### NOTE:
---Kinematic colliders behave as though they have infinite mass, ignoring external forces like gravity, joints, or collisions (though non-kinematic colliders will collide with them). They can be useful for static objects like floors or walls.
---
---@return boolean kinematic # Whether the Collider is kinematic.
function Collider:isKinematic() end

---
---Returns whether the Collider is allowed to sleep.
---
---
---### NOTE:
---If sleeping is enabled, the simulation will put the Collider to sleep if it hasn't moved in a while. Sleeping colliders don't impact the physics simulation, which makes updates more efficient and improves physics performance.
---
---However, the physics engine isn't perfect at waking up sleeping colliders and this can lead to bugs where colliders don't react to forces or collisions properly.
---
---It is possible to set the default value for new colliders using `World:setSleepingAllowed`.
---
---Colliders can be manually put to sleep or woken up using `Collider:setAwake`.
---
---@return boolean allowed # Whether the Collider can go to sleep.
function Collider:isSleepingAllowed() end

---
---Removes a Shape from the Collider.
---
---
---### NOTE:
---Colliders without any shapes won't collide with anything.
---
---@param shape lovr.Shape # The Shape to remove.
function Collider:removeShape(shape) end

---
---Sets the angular damping of the Collider.
---
---Angular damping makes things less "spinny", causing them to slow down their angular velocity over time. Damping is only applied when angular velocity is over the threshold value.
---
---
---### NOTE:
---Angular damping can also be set on the World.
---
---@param damping number # The angular damping.
---@param threshold? number # Velocity limit below which the damping is not applied.
function Collider:setAngularDamping(damping, threshold) end

---
---Sets the angular velocity of the Collider.
---
---@param vx number # The x component of the angular velocity.
---@param vy number # The y component of the angular velocity.
---@param vz number # The z component of the angular velocity.
function Collider:setAngularVelocity(vx, vy, vz) end

---
---Manually puts the Collider to sleep or wakes it up.
---
---You can do this if you know a Collider won't be touched for a while or if you need to it be active.
---
---@param awake boolean # Whether the Collider should be awake.
function Collider:setAwake(awake) end

---
---Sets the friction of the Collider.
---
---By default, the friction of two Colliders is combined (multiplied) when they collide to generate a friction force.
---
---The initial friction is 0.
---
---@param friction number # The new friction.
function Collider:setFriction(friction) end

---
---Sets whether the Collider should ignore gravity.
---
---@param ignored boolean # Whether gravity should be ignored.
function Collider:setGravityIgnored(ignored) end

---
---Sets whether the Collider is kinematic.
---
---
---### NOTE:
---Kinematic colliders behave as though they have infinite mass, ignoring external forces like gravity, joints, or collisions (though non-kinematic colliders will collide with them). They can be useful for static objects like floors or walls.
---
---@param kinematic boolean # Whether the Collider is kinematic.
function Collider:setKinematic(kinematic) end

---
---Sets the Collider's linear damping parameter.
---
---Linear damping is similar to drag or air resistance, slowing the Collider down over time. Damping is only applied when linear velocity is over the threshold value.
---
---
---### NOTE:
---A linear damping of 0 means the Collider won't slow down over time.
---
---This is the default.
---
---Linear damping can also be set on the World using `World:setLinearDamping`, which will affect all new colliders.
---
---@param damping number # The linear damping.
---@param threshold? number # Velocity limit below which the damping is not applied.
function Collider:setLinearDamping(damping, threshold) end

---
---Sets the linear velocity of the Collider directly.
---
---Usually it's preferred to use `Collider:applyForce` to change velocity since instantaneous velocity changes can lead to weird glitches.
---
---@param vx number # The x velocity of the Collider, in meters per second.
---@param vy number # The y velocity of the Collider, in meters per second.
---@param vz number # The z velocity of the Collider, in meters per second.
function Collider:setLinearVelocity(vx, vy, vz) end

---
---Sets the total mass of the Collider.
---
---@param mass number # The new mass for the Collider, in kilograms.
function Collider:setMass(mass) end

---
---Sets mass properties for the Collider.
---
---@param cx number # The x position of the center of mass.
---@param cy number # The y position of the center of mass.
---@param cz number # The z position of the center of mass.
---@param mass number # The computed mass of the Collider.
---@param inertia table # A table containing 6 values of the rotational inertia tensor matrix.  The table contains the 3 diagonal elements of the matrix (upper left to bottom right), followed by the 3 elements of the upper right portion of the 3x3 matrix.
function Collider:setMassData(cx, cy, cz, mass, inertia) end

---
---Sets the orientation of the Collider in angle/axis representation.
---
---@param angle number # The number of radians the Collider is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function Collider:setOrientation(angle, ax, ay, az) end

---
---Sets the position and orientation of the Collider.
---
---@param x number # The x position of the Collider, in meters.
---@param y number # The y position of the Collider, in meters.
---@param z number # The z position of the Collider, in meters.
---@param angle number # The number of radians the Collider is rotated around its axis of rotation.
---@param ax number # The x component of the axis of rotation.
---@param ay number # The y component of the axis of rotation.
---@param az number # The z component of the axis of rotation.
function Collider:setPose(x, y, z, angle, ax, ay, az) end

---
---Sets the position of the Collider.
---
---@param x number # The x position of the Collider, in meters.
---@param y number # The y position of the Collider, in meters.
---@param z number # The z position of the Collider, in meters.
function Collider:setPosition(x, y, z) end

---
---Sets the restitution (bounciness) of the Collider.
---
---By default, the restitution of two Colliders is combined (the max is used) when they collide to cause them to bounce away from each other. The initial restitution is 0.
---
---@param restitution number # The new restitution.
function Collider:setRestitution(restitution) end

---
---Sets whether the Collider is allowed to sleep.
---
---
---### NOTE:
---If sleeping is enabled, the simulation will put the Collider to sleep if it hasn't moved in a while. Sleeping colliders don't impact the physics simulation, which makes updates more efficient and improves physics performance.
---
---However, the physics engine isn't perfect at waking up sleeping colliders and this can lead to bugs where colliders don't react to forces or collisions properly.
---
---It is possible to set the default value for new colliders using `World:setSleepingAllowed`.
---
---Colliders can be manually put to sleep or woken up using `Collider:setAwake`.
---
---@param allowed boolean # Whether the Collider can go to sleep.
function Collider:setSleepingAllowed(allowed) end

---
---Sets the Collider's tag.
---
---
---### NOTE:
---Collision between tags can be enabled and disabled using `World:enableCollisionBetween` and `World:disableCollisionBetween`.
---
---@param tag string # The Collider's collision tag.
function Collider:setTag(tag) end

---
---Associates a custom value with the Collider.
---
---
---### NOTE:
---User data can be useful to identify the Collider in callbacks.
---
---@param data any # The custom value to associate with the Collider.
function Collider:setUserData(data) end

---
---A type of `Shape` that can be used for cylinder-shaped things.
---
---@class lovr.CylinderShape
local CylinderShape = {}

---
---Returns the length of the CylinderShape.
---
---@return number length # The length of the cylinder, in meters.
function CylinderShape:getLength() end

---
---Returns the radius of the CylinderShape.
---
---@return number radius # The radius of the cylinder, in meters.
function CylinderShape:getRadius() end

---
---Sets the length of the CylinderShape.
---
---@param length number # The new length, in meters.
function CylinderShape:setLength(length) end

---
---Sets the radius of the CylinderShape.
---
---@param radius number # The new radius, in meters.
function CylinderShape:setRadius(radius) end

---
---A DistanceJoint is a type of `Joint` that tries to keep two colliders a fixed distance apart. The distance is determined by the initial distance between the anchor points.
---
---The joint allows for rotation on the anchor points.
---
---@class lovr.DistanceJoint
local DistanceJoint = {}

---
---Returns the anchor points of the DistanceJoint.
---
---@return number x1 # The x coordinate of the first anchor point, in world coordinates.
---@return number y1 # The y coordinate of the first anchor point, in world coordinates.
---@return number z1 # The z coordinate of the first anchor point, in world coordinates.
---@return number x2 # The x coordinate of the second anchor point, in world coordinates.
---@return number y2 # The y coordinate of the second anchor point, in world coordinates.
---@return number z2 # The z coordinate of the second anchor point, in world coordinates.
function DistanceJoint:getAnchors() end

---
---Returns the target distance for the DistanceJoint.
---
---The joint tries to keep the Colliders this far apart.
---
---@return number distance # The target distance.
function DistanceJoint:getDistance() end

---
---Returns the response time of the joint.
---
---See `World:setResponseTime` for more info.
---
---@return number responseTime # The response time setting for the joint.
function DistanceJoint:getResponseTime() end

---
---Returns the tightness of the joint.
---
---See `World:setTightness` for how this affects the joint.
---
---@return number tightness # The tightness of the joint.
function DistanceJoint:getTightness() end

---
---Sets the anchor points of the DistanceJoint.
---
---@param x1 number # The x coordinate of the first anchor point, in world coordinates.
---@param y1 number # The y coordinate of the first anchor point, in world coordinates.
---@param z1 number # The z coordinate of the first anchor point, in world coordinates.
---@param x2 number # The x coordinate of the second anchor point, in world coordinates.
---@param y2 number # The y coordinate of the second anchor point, in world coordinates.
---@param z2 number # The z coordinate of the second anchor point, in world coordinates.
function DistanceJoint:setAnchors(x1, y1, z1, x2, y2, z2) end

---
---Sets the target distance for the DistanceJoint.
---
---The joint tries to keep the Colliders this far apart.
---
---@param distance number # The new target distance.
function DistanceJoint:setDistance(distance) end

---
---Sets the response time of the joint.
---
---See `World:setResponseTime` for more info.
---
---@param responseTime number # The new response time setting for the joint.
function DistanceJoint:setResponseTime(responseTime) end

---
---Sets the tightness of the joint.
---
---See `World:setTightness` for how this affects the joint.
---
---@param tightness number # The tightness of the joint.
function DistanceJoint:setTightness(tightness) end

---
---A HingeJoint is a type of `Joint` that only allows colliders to rotate on a single axis.
---
---@class lovr.HingeJoint
local HingeJoint = {}

---
---Returns the anchor points of the HingeJoint.
---
---@return number x1 # The x coordinate of the first anchor point, in world coordinates.
---@return number y1 # The y coordinate of the first anchor point, in world coordinates.
---@return number z1 # The z coordinate of the first anchor point, in world coordinates.
---@return number x2 # The x coordinate of the second anchor point, in world coordinates.
---@return number y2 # The y coordinate of the second anchor point, in world coordinates.
---@return number z2 # The z coordinate of the second anchor point, in world coordinates.
function HingeJoint:getAnchors() end

---
---Get the angle between the two colliders attached to the HingeJoint.
---
---When the joint is created or when the anchor or axis is set, the current angle is the new "zero" angle.
---
---@return number angle # The hinge angle, in radians.
function HingeJoint:getAngle() end

---
---Returns the axis of the hinge.
---
---@return number x # The x component of the axis.
---@return number y # The y component of the axis.
---@return number z # The z component of the axis.
function HingeJoint:getAxis() end

---
---Returns the upper and lower limits of the hinge angle.
---
---These will be between -π and π.
---
---@return number lower # The lower limit, in radians.
---@return number upper # The upper limit, in radians.
function HingeJoint:getLimits() end

---
---Returns the lower limit of the hinge angle.
---
---This will be greater than -π.
---
---@return number limit # The lower limit, in radians.
function HingeJoint:getLowerLimit() end

---
---Returns the upper limit of the hinge angle.
---
---This will be less than π.
---
---@return number limit # The upper limit, in radians.
function HingeJoint:getUpperLimit() end

---
---Sets a new anchor point for the HingeJoint.
---
---@param x number # The x coordinate of the anchor point, in world coordinates.
---@param y number # The y coordinate of the anchor point, in world coordinates.
---@param z number # The z coordinate of the anchor point, in world coordinates.
function HingeJoint:setAnchor(x, y, z) end

---
---Sets the axis of the hinge.
---
---@param x number # The x component of the axis.
---@param y number # The y component of the axis.
---@param z number # The z component of the axis.
function HingeJoint:setAxis(x, y, z) end

---
---Sets the upper and lower limits of the hinge angle.
---
---These should be between -π and π.
---
---@param lower number # The lower limit, in radians.
---@param upper number # The upper limit, in radians.
function HingeJoint:setLimits(lower, upper) end

---
---Sets the lower limit of the hinge angle.
---
---This should be greater than -π.
---
---@param limit number # The lower limit, in radians.
function HingeJoint:setLowerLimit(limit) end

---
---Sets the upper limit of the hinge angle.
---
---This should be less than π.
---
---@param limit number # The upper limit, in radians.
function HingeJoint:setUpperLimit(limit) end

---
---A Joint is a physics object that constrains the movement of two Colliders.
---
---@class lovr.Joint
local Joint = {}

---
---Destroy the Joint, removing it from Colliders it's attached to.
---
---
---### NOTE:
---Calling functions on the Joint after destroying it is a bad idea.
---
function Joint:destroy() end

---
---Returns the Colliders the Joint is attached to.
---
---All Joints are attached to two colliders.
---
---@return lovr.Collider colliderA # The first Collider.
---@return lovr.Collider colliderB # The second Collider.
function Joint:getColliders() end

---
---Returns the type of the Joint.
---
---@return lovr.JointType type # The type of the Joint.
function Joint:getType() end

---
---Returns the user data associated with the Joint.
---
---@return any data # The custom value associated with the Joint.
function Joint:getUserData() end

---
---Returns whether the Joint is enabled.
---
---@return boolean enabled # Whether the Joint is enabled.
function Joint:isEnabled() end

---
---Enable or disable the Joint.
---
---@param enabled boolean # Whether the Joint should be enabled.
function Joint:setEnabled(enabled) end

---
---Sets the user data associated with the Joint.
---
---@param data any # The custom value associated with the Joint.
function Joint:setUserData(data) end

---
---A type of `Shape` that can be used for triangle meshes.
---
---@class lovr.MeshShape
local MeshShape = {}

---
---A Shape is a physics object that can be attached to colliders to define their shape.
---
---@class lovr.Shape
local Shape = {}

---
---Destroy the Shape, removing it from Colliders it's attached to.
---
---
---### NOTE:
---Calling functions on the Shape after destroying it is a bad idea.
---
function Shape:destroy() end

---
---Returns the bounding box for the Shape.
---
---@return number minx # The minimum x coordinate of the box.
---@return number maxx # The maximum x coordinate of the box.
---@return number miny # The minimum y coordinate of the box.
---@return number maxy # The maximum y coordinate of the box.
---@return number minz # The minimum z coordinate of the box.
---@return number maxz # The maximum z coordinate of the box.
function Shape:getAABB() end

---
---Returns the Collider the Shape is attached to.
---
---
---### NOTE:
---A Shape can only be attached to one Collider at a time.
---
---@return lovr.Collider collider # The Collider the Shape is attached to.
function Shape:getCollider() end

---
---Computes mass properties of the Shape.
---
---@param density number # The density to use, in kilograms per cubic meter.
---@return number cx # The x position of the center of mass.
---@return number cy # The y position of the center of mass.
---@return number cz # The z position of the center of mass.
---@return number mass # The mass of the Shape.
---@return table inertia # A table containing 6 values of the rotational inertia tensor matrix.  The table contains the 3 diagonal elements of the matrix (upper left to bottom right), followed by the 3 elements of the upper right portion of the 3x3 matrix.
function Shape:getMass(density) end

---
---Get the orientation of the Shape relative to its Collider.
---
---@return number angle # The number of radians the Shape is rotated.
---@return number ax # The x component of the rotation axis.
---@return number ay # The y component of the rotation axis.
---@return number az # The z component of the rotation axis.
function Shape:getOrientation() end

---
---Get the position of the Shape relative to its Collider.
---
---@return number x # The x offset.
---@return number y # The y offset.
---@return number z # The z offset.
function Shape:getPosition() end

---
---Returns the type of the Shape.
---
---@return lovr.ShapeType type # The type of the Shape.
function Shape:getType() end

---
---Returns the user data associated with the Shape.
---
---
---### NOTE:
---User data can be useful to identify the Shape in callbacks.
---
---@return any data # The custom value associated with the Shape.
function Shape:getUserData() end

---
---Returns whether the Shape is enabled.
---
---
---### NOTE:
---Disabled shapes won't collide with anything.
---
---@return boolean enabled # Whether the Shape is enabled.
function Shape:isEnabled() end

---
---Returns whether the Shape is a sensor.
---
---Sensors do not trigger any collision response, but they still report collisions in `World:collide`.
---
---@return boolean sensor # Whether the Shape is a sensor.
function Shape:isSensor() end

---
---Enable or disable the Shape.
---
---
---### NOTE:
---Disabled shapes won't collide with anything.
---
---@param enabled boolean # Whether the Shape should be enabled.
function Shape:setEnabled(enabled) end

---
---Set the orientation of the Shape relative to its Collider.
---
---
---### NOTE:
---If the Shape isn't attached to a Collider, this will error.
---
---@param angle number # The number of radians the Shape is rotated.
---@param ax number # The x component of the rotation axis.
---@param ay number # The y component of the rotation axis.
---@param az number # The z component of the rotation axis.
function Shape:setOrientation(angle, ax, ay, az) end

---
---Set the position of the Shape relative to its Collider.
---
---
---### NOTE:
---If the Shape isn't attached to a Collider, this will error.
---
---@param x number # The x offset.
---@param y number # The y offset.
---@param z number # The z offset.
function Shape:setPosition(x, y, z) end

---
---Sets whether this Shape is a sensor.
---
---Sensors do not trigger any collision response, but they still report collisions in `World:collide`.
---
---@param sensor boolean # Whether the Shape should be a sensor.
function Shape:setSensor(sensor) end

---
---Sets the user data associated with the Shape.
---
---
---### NOTE:
---User data can be useful to identify the Shape in callbacks.
---
---@param data any # The custom value associated with the Shape.
function Shape:setUserData(data) end

---
---A SliderJoint is a type of `Joint` that only allows colliders to move on a single axis.
---
---@class lovr.SliderJoint
local SliderJoint = {}

---
---Returns the axis of the slider.
---
---@return number x # The x component of the axis.
---@return number y # The y component of the axis.
---@return number z # The z component of the axis.
function SliderJoint:getAxis() end

---
---Returns the upper and lower limits of the slider position.
---
---@return number lower # The lower limit.
---@return number upper # The upper limit.
function SliderJoint:getLimits() end

---
---Returns the lower limit of the slider position.
---
---@return number limit # The lower limit.
function SliderJoint:getLowerLimit() end

---
---Returns how far the slider joint is extended (zero is the position the slider was created at, positive values are further apart).
---
---@return number position # The joint position along its axis.
function SliderJoint:getPosition() end

---
---Returns the upper limit of the slider position.
---
---@return number limit # The upper limit.
function SliderJoint:getUpperLimit() end

---
---Sets the axis of the slider.
---
---@param x number # The x component of the axis.
---@param y number # The y component of the axis.
---@param z number # The z component of the axis.
function SliderJoint:setAxis(x, y, z) end

---
---Sets the upper and lower limits of the slider position.
---
---@param lower number # The lower limit.
---@param upper number # The upper limit.
function SliderJoint:setLimits(lower, upper) end

---
---Sets the lower limit of the slider position.
---
---@param limit number # The lower limit.
function SliderJoint:setLowerLimit(limit) end

---
---Sets the upper limit of the slider position.
---
---@param limit number # The upper limit.
function SliderJoint:setUpperLimit(limit) end

---
---A type of `Shape` that can be used for spheres.
---
---@class lovr.SphereShape
local SphereShape = {}

---
---Returns the radius of the SphereShape.
---
---@return number radius # The radius of the sphere, in meters.
function SphereShape:getRadius() end

---
---Sets the radius of the SphereShape.
---
---@param radius number # The radius of the sphere, in meters.
function SphereShape:setRadius(radius) end

---
---A type of `Shape` that can be used for terrains and irregular surfaces.
---
---@class lovr.TerrainShape
local TerrainShape = {}

---
---A World is an object that holds the colliders, joints, and shapes in a physics simulation.
---
---
---### NOTE:
---Be sure to update the World in `lovr.update` using `World:update`, otherwise everything will stand still.
---
---@class lovr.World
local World = {}

---
---Attempt to collide two shapes.
---
---Internally this uses joints and forces to ensure the colliders attached to the shapes do not pass through each other.
---
---Collisions can be customized using friction and restitution (bounciness) parameters, and default to using a mix of the colliders' friction and restitution parameters.
---
---Usually this is called automatically by `World:update`.
---
---
---### NOTE:
---For friction, numbers in the range of 0-1 are common, but larger numbers can also be used.
---
---For restitution, numbers in the range 0-1 should be used.
---
---This function respects collision tags, so using `World:disableCollisionBetween` and `World:enableCollisionBetween` will change the behavior of this function.
---
---@param shapeA lovr.Shape # The first shape.
---@param shapeB lovr.Shape # The second shape.
---@param friction? number # The friction parameter for the collision.
---@param restitution? number # The restitution (bounciness) parameter for the collision.
---@return boolean collided # Whether the shapes collided.
function World:collide(shapeA, shapeB, friction, restitution) end

---
---Detects which pairs of shapes in the world are near each other and could be colliding.
---
---After calling this function, the `World:overlaps` iterator can be used to iterate over the overlaps, and `World:collide` can be used to resolve a collision for the shapes (if any). Usually this is called automatically by `World:update`.
---
function World:computeOverlaps() end

---
---Destroy the World!
---
---
---### NOTE:
---Bad things will happen if you destroy the world and then try to access it or anything that was in it.
---
function World:destroy() end

---
---Disables collision between two collision tags.
---
---
---### NOTE:
---Tags must be set up when creating the World, see `lovr.physics.newWorld`.
---
---By default, collision is enabled between all tags.
---
---@param tag1 string # The first tag.
---@param tag2 string # The second tag.
function World:disableCollisionBetween(tag1, tag2) end

---
---Enables collision between two collision tags.
---
---
---### NOTE:
---Tags must be set up when creating the World, see `lovr.physics.newWorld`.
---
---By default, collision is enabled between all tags.
---
---@param tag1 string # The first tag.
---@param tag2 string # The second tag.
function World:enableCollisionBetween(tag1, tag2) end

---
---Returns the angular damping parameters of the World.
---
---Angular damping makes things less "spinny", making them slow down their angular velocity over time.
---
---
---### NOTE:
---Angular damping can also be set on individual colliders.
---
---@return number damping # The angular damping.
---@return number threshold # Velocity limit below which the damping is not applied.
function World:getAngularDamping() end

---
---Returns a table of all Colliders in the World.
---
---@overload fun(self: lovr.World, t: table):table
---@return table colliders # A table of `Collider` objects.
function World:getColliders() end

---
---Returns the gravity of the World.
---
---@return number xg # The x component of the gravity force.
---@return number yg # The y component of the gravity force.
---@return number zg # The z component of the gravity force.
function World:getGravity() end

---
---Returns the linear damping parameters of the World.
---
---Linear damping is similar to drag or air resistance, slowing down colliders over time as they move.
---
---
---### NOTE:
---A linear damping of 0 means colliders won't slow down over time.
---
---This is the default.
---
---Linear damping can also be set on individual colliders.
---
---@return number damping # The linear damping.
---@return number threshold # Velocity limit below which the damping is not applied.
function World:getLinearDamping() end

---
---Returns the response time factor of the World.
---
---The response time controls how relaxed collisions and joints are in the physics simulation, and functions similar to inertia.
---
---A low response time means collisions are resolved quickly, and higher values make objects more spongy and soft.
---
---The value can be any positive number.
---
---It can be changed on a per-joint basis for `DistanceJoint` and `BallJoint` objects.
---
---@return number responseTime # The response time setting for the World.
function World:getResponseTime() end

---
---Returns the step count of the World.
---
---The step count influences how many steps are taken during a call to `World:update`.
---
---A higher number of steps will be slower, but more accurate.
---
---The default step count is 20.
---
---@return number steps # The step count.
function World:getStepCount() end

---
---Returns the tightness of joints in the World.
---
---The tightness controls how much force is applied to colliders connected by joints.
---
---With a value of 0, no force will be applied and joints won't have any effect.
---
---With a tightness of 1, a strong force will be used to try to keep the Colliders constrained.
---
---A tightness larger than 1 will overcorrect the joints, which can sometimes be desirable.
---
---Negative tightness values are not supported.
---
---@return number tightness # The tightness of the World.
function World:getTightness() end

---
---Returns whether collisions are currently enabled between two tags.
---
---
---### NOTE:
---Tags must be set up when creating the World, see `lovr.physics.newWorld`.
---
---By default, collision is enabled between all tags.
---
---@param tag1 string # The first tag.
---@param tag2 string # The second tag.
---@return boolean enabled # Whether or not two colliders with the specified tags will collide.
function World:isCollisionEnabledBetween(tag1, tag2) end

---
---Returns whether colliders can go to sleep in the World.
---
---
---### NOTE:
---If sleeping is enabled, the World will try to detect colliders that haven't moved for a while and put them to sleep.
---
---Sleeping colliders don't impact the physics simulation, which makes updates more efficient and improves physics performance.
---
---However, the physics engine isn't perfect at waking up sleeping colliders and this can lead to bugs where colliders don't react to forces or collisions properly.
---
---This can be set on individual colliders.
---
---Colliders can be manually put to sleep or woken up using `Collider:setAwake`.
---
---@return boolean allowed # Whether colliders can sleep.
function World:isSleepingAllowed() end

---
---Adds a new Collider to the World with a BoxShape already attached.
---
---@param x? number # The x coordinate of the center of the box.
---@param y? number # The y coordinate of the center of the box.
---@param z? number # The z coordinate of the center of the box.
---@param width? number # The total width of the box, in meters.
---@param height? number # The total height of the box, in meters.
---@param depth? number # The total depth of the box, in meters.
---@return lovr.Collider collider # The new Collider.
function World:newBoxCollider(x, y, z, width, height, depth) end

---
---Adds a new Collider to the World with a CapsuleShape already attached.
---
---@param x? number # The x coordinate of the center of the capsule.
---@param y? number # The y coordinate of the center of the capsule.
---@param z? number # The z coordinate of the center of the capsule.
---@param radius? number # The radius of the capsule, in meters.
---@param length? number # The length of the capsule, not including the caps, in meters.
---@return lovr.Collider collider # The new Collider.
function World:newCapsuleCollider(x, y, z, radius, length) end

---
---Adds a new Collider to the World.
---
---
---### NOTE:
---This function creates a collider without any shapes attached to it, which means it won't collide with anything.
---
---To add a shape to the collider, use `Collider:addShape`, or use one of the following functions to create the collider:
---
---- `World:newBoxCollider`
---- `World:newCapsuleCollider`
---- `World:newCylinderCollider`
---- `World:newSphereCollider`
---
---@param x? number # The x position of the Collider.
---@param y? number # The y position of the Collider.
---@param z? number # The z position of the Collider.
---@return lovr.Collider collider # The new Collider.
function World:newCollider(x, y, z) end

---
---Adds a new Collider to the World with a CylinderShape already attached.
---
---@param x? number # The x coordinate of the center of the cylinder.
---@param y? number # The y coordinate of the center of the cylinder.
---@param z? number # The z coordinate of the center of the cylinder.
---@param radius? number # The radius of the cylinder, in meters.
---@param length? number # The length of the cylinder, in meters.
---@return lovr.Collider collider # The new Collider.
function World:newCylinderCollider(x, y, z, radius, length) end

---
---Adds a new Collider to the World with a MeshShape already attached.
---
---@overload fun(self: lovr.World, model: lovr.Model):lovr.Collider
---@param vertices table # The table of vertices in the mesh.  Each vertex is a table with 3 numbers.
---@param indices table # A table of triangle indices representing how the vertices are connected in the Mesh.
---@return lovr.Collider collider # The new Collider.
function World:newMeshCollider(vertices, indices) end

---
---Adds a new Collider to the World with a SphereShape already attached.
---
---@param x? number # The x coordinate of the center of the sphere.
---@param y? number # The y coordinate of the center of the sphere.
---@param z? number # The z coordinate of the center of the sphere.
---@param radius? number # The radius of the sphere, in meters.
---@return lovr.Collider collider # The new Collider.
function World:newSphereCollider(x, y, z, radius) end

---
---Adds a new Collider to the World with a TerrainShape already attached.
---
---
---### NOTE:
---The collider will be positioned at 0, 0, 0.
---
---Unlike other colliders, it will automatically be set as kinematic when created.
---
---@overload fun(self: lovr.World, scale: number, heightmap: lovr.Image, stretch?: number):lovr.Collider
---@overload fun(self: lovr.World, scale: number, callback: function, samples?: number):lovr.Collider
---@param scale number # The width and depth of the terrain, in meters.
---@return lovr.Collider collider # The new Collider.
function World:newTerrainCollider(scale) end

---
---Returns an iterator that can be used to iterate over "overlaps", or potential collisions between pairs of shapes in the World.
---
---This should be called after using `World:computeOverlaps` to compute the list of overlaps. Usually this is called automatically by `World:update`.
---
---@return function iterator # A Lua iterator, usable in a for loop.
function World:overlaps() end

---
---Casts a ray through the World, calling a function every time the ray intersects with a Shape.
---
---
---### NOTE:
---The callback is passed the shape that was hit, the hit position (in world coordinates), and the normal vector of the hit.
---
---@param x1 number # The x coordinate of the starting position of the ray.
---@param y1 number # The y coordinate of the starting position of the ray.
---@param z1 number # The z coordinate of the starting position of the ray.
---@param x2 number # The x coordinate of the ending position of the ray.
---@param y2 number # The y coordinate of the ending position of the ray.
---@param z2 number # The z coordinate of the ending position of the ray.
---@param callback function # The function to call when an intersection is detected.
function World:raycast(x1, y1, z1, x2, y2, z2, callback) end

---
---Sets the angular damping of the World.
---
---Angular damping makes things less "spinny", making them slow down their angular velocity over time. Damping is only applied when angular velocity is over the threshold value.
---
---
---### NOTE:
---Angular damping can also be set on individual colliders.
---
---@param damping number # The angular damping.
---@param threshold? number # Velocity limit below which the damping is not applied.
function World:setAngularDamping(damping, threshold) end

---
---Sets the gravity of the World.
---
---@param xg number # The x component of the gravity force.
---@param yg number # The y component of the gravity force.
---@param zg number # The z component of the gravity force.
function World:setGravity(xg, yg, zg) end

---
---Sets the linear damping of the World.
---
---Linear damping is similar to drag or air resistance, slowing down colliders over time as they move. Damping is only applied when linear velocity is over the threshold value.
---
---
---### NOTE:
---A linear damping of 0 means colliders won't slow down over time.
---
---This is the default.
---
---Linear damping can also be set on individual colliders.
---
---@param damping number # The linear damping.
---@param threshold? number # Velocity limit below which the damping is not applied.
function World:setLinearDamping(damping, threshold) end

---
---Sets the response time factor of the World.
---
---The response time controls how relaxed collisions and joints are in the physics simulation, and functions similar to inertia.
---
---A low response time means collisions are resolved quickly, and higher values make objects more spongy and soft.
---
---The value can be any positive number.
---
---It can be changed on a per-joint basis for `DistanceJoint` and `BallJoint` objects.
---
---@param responseTime number # The new response time setting for the World.
function World:setResponseTime(responseTime) end

---
---Sets whether colliders can go to sleep in the World.
---
---
---### NOTE:
---If sleeping is enabled, the World will try to detect colliders that haven't moved for a while and put them to sleep.
---
---Sleeping colliders don't impact the physics simulation, which makes updates more efficient and improves physics performance.
---
---However, the physics engine isn't perfect at waking up sleeping colliders and this can lead to bugs where colliders don't react to forces or collisions properly.
---
---This can be set on individual colliders.
---
---Colliders can be manually put to sleep or woken up using `Collider:setAwake`.
---
---@param allowed boolean # Whether colliders can sleep.
function World:setSleepingAllowed(allowed) end

---
---Sets the step count of the World.
---
---The step count influences how many steps are taken during a call to `World:update`.
---
---A higher number of steps will be slower, but more accurate.
---
---The default step count is 20.
---
---@param steps number # The new step count.
function World:setStepCount(steps) end

---
---Sets the tightness of joints in the World.
---
---The tightness controls how much force is applied to colliders connected by joints.
---
---With a value of 0, no force will be applied and joints won't have any effect.
---
---With a tightness of 1, a strong force will be used to try to keep the Colliders constrained.
---
---A tightness larger than 1 will overcorrect the joints, which can sometimes be desirable.
---
---Negative tightness values are not supported.
---
---@param tightness number # The new tightness for the World.
function World:setTightness(tightness) end

---
---Updates the World, advancing the physics simulation forward in time and resolving collisions between colliders in the World.
---
---
---### NOTE:
---It is common to pass the `dt` variable from `lovr.update` into this function.
---
---The default collision resolver function is:
---
---    function defaultResolver(world)
---      world:computeOverlaps()
---      for shapeA, shapeB in world:overlaps() do
---        world:collide(shapeA, shapeB)
---      end
---    end
---
---Additional logic could be introduced to the collision resolver function to add custom collision behavior or to change the collision parameters (like friction and restitution) on a per-collision basis.
---
---> If possible, use a fixed timestep value for updating the World. It will greatly improve the
---> accuracy of the simulation and reduce bugs. For more information on implementing a fixed
---> timestep loop, see [this article](http://gafferongames.com/game-physics/fix-your-timestep/).
---
---@param dt number # The amount of time to advance the simulation forward.
---@param resolver? function # The collision resolver function to use.  This will be called before updating to allow for custom collision processing.  If absent, a default will be used.
function World:update(dt, resolver) end

---
---Represents the different types of physics Joints available.
---
---@alias lovr.JointType
---
---A BallJoint.
---
---| "ball"
---
---A DistanceJoint.
---
---| "distance"
---
---A HingeJoint.
---
---| "hinge"
---
---A SliderJoint.
---
---| "slider"

---
---Represents the different types of physics Shapes available.
---
---@alias lovr.ShapeType
---
---A BoxShape.
---
---| "box"
---
---A CapsuleShape.
---
---| "capsule"
---
---A CylinderShape.
---
---| "cylinder"
---
---A SphereShape.
---
---| "sphere"
