---@meta

---
---The `lovr.physics` module simulates 3D rigid body physics.
---
---@class lovr.physics
lovr.physics = {}

---
---Creates a new BallJoint.
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
---@param width? number # The width of the box, in meters.
---@param height? number # The height of the box, in meters.
---@param depth? number # The depth of the box, in meters.
---@return lovr.BoxShape box # The new BoxShape.
function lovr.physics.newBoxShape(width, height, depth) end

---
---Creates a new CapsuleShape.  Capsules are cylinders with hemispheres on each end.
---
---@param radius? number # The radius of the capsule, in meters.
---@param length? number # The length of the capsule, not including the caps, in meters.
---@return lovr.CapsuleShape capsule # The new CapsuleShape.
function lovr.physics.newCapsuleShape(radius, length) end

---
---Creates a new CylinderShape.
---
---@param radius? number # The radius of the cylinder, in meters.
---@param length? number # The length of the cylinder, in meters.
---@return lovr.CylinderShape cylinder # The new CylinderShape.
function lovr.physics.newCylinderShape(radius, length) end

---
---Creates a new DistanceJoint.
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
---Creates a new SliderJoint.
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
---@param radius? number # The radius of the sphere, in meters.
---@return lovr.SphereShape sphere # The new SphereShape.
function lovr.physics.newSphereShape(radius) end

---
---Creates a new physics World, which tracks the overall physics simulation, holds collider objects, and resolves collisions between them.
---
---@param xg? number # The x component of the gravity force.
---@param yg? number # The y component of the gravity force.
---@param zg? number # The z component of the gravity force.
---@param allowSleep? boolean # Whether or not colliders will automatically be put to sleep.
---@param tags? table # A list of collision tags colliders can be assigned to.
---@return lovr.World world # A whole new World.
function lovr.physics.newWorld(xg, yg, zg, allowSleep, tags) end

---
---Represents the different types of physics Joints available.
---
---@class lovr.JointType
---
---A BallJoint.
---
---@field ball integer
---
---A DistanceJoint.
---
---@field distance integer
---
---A HingeJoint.
---
---@field hinge integer
---
---A SliderJoint.
---
---@field slider integer

---
---Represents the different types of physics Shapes available.
---
---@class lovr.ShapeType
---
---A BoxShape.
---
---@field box integer
---
---A CapsuleShape.
---
---@field capsule integer
---
---A CylinderShape.
---
---@field cylinder integer
---
---A SphereShape.
---
---@field sphere integer
