---@meta

---
---Can simulate 2D rigid body physics in a realistic manner. This module is based on Box2D, and this API corresponds to the Box2D API as closely as possible.
---
---@class love.physics
love.physics = {}

---
---Returns the two closest points between two fixtures and their distance.
---
---@param fixture1 love.Fixture # The first fixture.
---@param fixture2 love.Fixture # The second fixture.
---@return number distance # The distance of the two points.
---@return number x1 # The x-coordinate of the first point.
---@return number y1 # The y-coordinate of the first point.
---@return number x2 # The x-coordinate of the second point.
---@return number y2 # The y-coordinate of the second point.
function love.physics.getDistance(fixture1, fixture2) end

---
---Returns the meter scale factor.
---
---All coordinates in the physics module are divided by this number, creating a convenient way to draw the objects directly to the screen without the need for graphics transformations.
---
---It is recommended to create shapes no larger than 10 times the scale. This is important because Box2D is tuned to work well with shape sizes from 0.1 to 10 meters.
---
---@return number scale # The scale factor as an integer.
function love.physics.getMeter() end

---
---Creates a new body.
---
---There are three types of bodies. 
---
---* Static bodies do not move, have a infinite mass, and can be used for level boundaries. 
---
---* Dynamic bodies are the main actors in the simulation, they collide with everything. 
---
---* Kinematic bodies do not react to forces and only collide with dynamic bodies.
---
---The mass of the body gets calculated when a Fixture is attached or removed, but can be changed at any time with Body:setMass or Body:resetMassData.
---
---@param world love.World # The world to create the body in.
---@param x? number # The x position of the body.
---@param y? number # The y position of the body.
---@param type? love.BodyType # The type of the body.
---@return love.Body body # A new body.
function love.physics.newBody(world, x, y, type) end

---
---Creates a new ChainShape.
---
---@overload fun(loop: boolean, points: table):love.ChainShape
---@param loop boolean # If the chain should loop back to the first point.
---@param x1 number # The x position of the first point.
---@param y1 number # The y position of the first point.
---@param x2 number # The x position of the second point.
---@param y2 number # The y position of the second point.
---@return love.ChainShape shape # The new shape.
function love.physics.newChainShape(loop, x1, y1, x2, y2) end

---
---Creates a new CircleShape.
---
---@overload fun(x: number, y: number, radius: number):love.CircleShape
---@param radius number # The radius of the circle.
---@return love.CircleShape shape # The new shape.
function love.physics.newCircleShape(radius) end

---
---Creates a DistanceJoint between two bodies.
---
---This joint constrains the distance between two points on two bodies to be constant. These two points are specified in world coordinates and the two bodies are assumed to be in place when this joint is created. The first anchor point is connected to the first body and the second to the second body, and the points define the length of the distance joint.
---
---@param body1 love.Body # The first body to attach to the joint.
---@param body2 love.Body # The second body to attach to the joint.
---@param x1 number # The x position of the first anchor point (world space).
---@param y1 number # The y position of the first anchor point (world space).
---@param x2 number # The x position of the second anchor point (world space).
---@param y2 number # The y position of the second anchor point (world space).
---@param collideConnected? boolean # Specifies whether the two bodies should collide with each other.
---@return love.DistanceJoint joint # The new distance joint.
function love.physics.newDistanceJoint(body1, body2, x1, y1, x2, y2, collideConnected) end

---
---Creates a new EdgeShape.
---
---@param x1 number # The x position of the first point.
---@param y1 number # The y position of the first point.
---@param x2 number # The x position of the second point.
---@param y2 number # The y position of the second point.
---@return love.EdgeShape shape # The new shape.
function love.physics.newEdgeShape(x1, y1, x2, y2) end

---
---Creates and attaches a Fixture to a body.
---
---Note that the Shape object is copied rather than kept as a reference when the Fixture is created. To get the Shape object that the Fixture owns, use Fixture:getShape.
---
---@param body love.Body # The body which gets the fixture attached.
---@param shape love.Shape # The shape to be copied to the fixture.
---@param density? number # The density of the fixture.
---@return love.Fixture fixture # The new fixture.
function love.physics.newFixture(body, shape, density) end

---
---Create a friction joint between two bodies. A FrictionJoint applies friction to a body.
---
---@overload fun(body1: love.Body, body2: love.Body, x1: number, y1: number, x2: number, y2: number, collideConnected: boolean):love.FrictionJoint
---@param body1 love.Body # The first body to attach to the joint.
---@param body2 love.Body # The second body to attach to the joint.
---@param x number # The x position of the anchor point.
---@param y number # The y position of the anchor point.
---@param collideConnected? boolean # Specifies whether the two bodies should collide with each other.
---@return love.FrictionJoint joint # The new FrictionJoint.
function love.physics.newFrictionJoint(body1, body2, x, y, collideConnected) end

---
---Create a GearJoint connecting two Joints.
---
---The gear joint connects two joints that must be either  prismatic or  revolute joints. Using this joint requires that the joints it uses connect their respective bodies to the ground and have the ground as the first body. When destroying the bodies and joints you must make sure you destroy the gear joint before the other joints.
---
---The gear joint has a ratio the determines how the angular or distance values of the connected joints relate to each other. The formula coordinate1 + ratio * coordinate2 always has a constant value that is set when the gear joint is created.
---
---@param joint1 love.Joint # The first joint to connect with a gear joint.
---@param joint2 love.Joint # The second joint to connect with a gear joint.
---@param ratio? number # The gear ratio.
---@param collideConnected? boolean # Specifies whether the two bodies should collide with each other.
---@return love.GearJoint joint # The new gear joint.
function love.physics.newGearJoint(joint1, joint2, ratio, collideConnected) end

---
---Creates a joint between two bodies which controls the relative motion between them.
---
---Position and rotation offsets can be specified once the MotorJoint has been created, as well as the maximum motor force and torque that will be be applied to reach the target offsets.
---
---@overload fun(body1: love.Body, body2: love.Body, correctionFactor: number, collideConnected: boolean):love.MotorJoint
---@param body1 love.Body # The first body to attach to the joint.
---@param body2 love.Body # The second body to attach to the joint.
---@param correctionFactor? number # The joint's initial position correction factor, in the range of 1.
---@return love.MotorJoint joint # The new MotorJoint.
function love.physics.newMotorJoint(body1, body2, correctionFactor) end

---
---Create a joint between a body and the mouse.
---
---This joint actually connects the body to a fixed point in the world. To make it follow the mouse, the fixed point must be updated every timestep (example below).
---
---The advantage of using a MouseJoint instead of just changing a body position directly is that collisions and reactions to other joints are handled by the physics engine. 
---
---@param body love.Body # The body to attach to the mouse.
---@param x number # The x position of the connecting point.
---@param y number # The y position of the connecting point.
---@return love.MouseJoint joint # The new mouse joint.
function love.physics.newMouseJoint(body, x, y) end

---
---Creates a new PolygonShape.
---
---This shape can have 8 vertices at most, and must form a convex shape.
---
---@overload fun(vertices: table):love.PolygonShape
---@param x1 number # The x position of the first point.
---@param y1 number # The y position of the first point.
---@param x2 number # The x position of the second point.
---@param y2 number # The y position of the second point.
---@param x3 number # The x position of the third point.
---@param y3 number # The y position of the third point.
---@return love.PolygonShape shape # A new PolygonShape.
function love.physics.newPolygonShape(x1, y1, x2, y2, x3, y3) end

---
---Creates a PrismaticJoint between two bodies.
---
---A prismatic joint constrains two bodies to move relatively to each other on a specified axis. It does not allow for relative rotation. Its definition and operation are similar to a  revolute joint, but with translation and force substituted for angle and torque.
---
---@overload fun(body1: love.Body, body2: love.Body, x1: number, y1: number, x2: number, y2: number, ax: number, ay: number, collideConnected: boolean):love.PrismaticJoint
---@overload fun(body1: love.Body, body2: love.Body, x1: number, y1: number, x2: number, y2: number, ax: number, ay: number, collideConnected: boolean, referenceAngle: number):love.PrismaticJoint
---@param body1 love.Body # The first body to connect with a prismatic joint.
---@param body2 love.Body # The second body to connect with a prismatic joint.
---@param x number # The x coordinate of the anchor point.
---@param y number # The y coordinate of the anchor point.
---@param ax number # The x coordinate of the axis vector.
---@param ay number # The y coordinate of the axis vector.
---@param collideConnected? boolean # Specifies whether the two bodies should collide with each other.
---@return love.PrismaticJoint joint # The new prismatic joint.
function love.physics.newPrismaticJoint(body1, body2, x, y, ax, ay, collideConnected) end

---
---Creates a PulleyJoint to join two bodies to each other and the ground.
---
---The pulley joint simulates a pulley with an optional block and tackle. If the ratio parameter has a value different from one, then the simulated rope extends faster on one side than the other. In a pulley joint the total length of the simulated rope is the constant length1 + ratio * length2, which is set when the pulley joint is created.
---
---Pulley joints can behave unpredictably if one side is fully extended. It is recommended that the method  setMaxLengths  be used to constrain the maximum lengths each side can attain.
---
---@param body1 love.Body # The first body to connect with a pulley joint.
---@param body2 love.Body # The second body to connect with a pulley joint.
---@param gx1 number # The x coordinate of the first body's ground anchor.
---@param gy1 number # The y coordinate of the first body's ground anchor.
---@param gx2 number # The x coordinate of the second body's ground anchor.
---@param gy2 number # The y coordinate of the second body's ground anchor.
---@param x1 number # The x coordinate of the pulley joint anchor in the first body.
---@param y1 number # The y coordinate of the pulley joint anchor in the first body.
---@param x2 number # The x coordinate of the pulley joint anchor in the second body.
---@param y2 number # The y coordinate of the pulley joint anchor in the second body.
---@param ratio? number # The joint ratio.
---@param collideConnected? boolean # Specifies whether the two bodies should collide with each other.
---@return love.PulleyJoint joint # The new pulley joint.
function love.physics.newPulleyJoint(body1, body2, gx1, gy1, gx2, gy2, x1, y1, x2, y2, ratio, collideConnected) end

---
---Shorthand for creating rectangular PolygonShapes. 
---
---By default, the local origin is located at the '''center''' of the rectangle as opposed to the top left for graphics.
---
---@overload fun(x: number, y: number, width: number, height: number, angle: number):love.PolygonShape
---@param width number # The width of the rectangle.
---@param height number # The height of the rectangle.
---@return love.PolygonShape shape # A new PolygonShape.
function love.physics.newRectangleShape(width, height) end

---
---Creates a pivot joint between two bodies.
---
---This joint connects two bodies to a point around which they can pivot.
---
---@overload fun(body1: love.Body, body2: love.Body, x1: number, y1: number, x2: number, y2: number, collideConnected: boolean, referenceAngle: number):love.RevoluteJoint
---@param body1 love.Body # The first body.
---@param body2 love.Body # The second body.
---@param x number # The x position of the connecting point.
---@param y number # The y position of the connecting point.
---@param collideConnected? boolean # Specifies whether the two bodies should collide with each other.
---@return love.RevoluteJoint joint # The new revolute joint.
function love.physics.newRevoluteJoint(body1, body2, x, y, collideConnected) end

---
---Creates a joint between two bodies. Its only function is enforcing a max distance between these bodies.
---
---@param body1 love.Body # The first body to attach to the joint.
---@param body2 love.Body # The second body to attach to the joint.
---@param x1 number # The x position of the first anchor point.
---@param y1 number # The y position of the first anchor point.
---@param x2 number # The x position of the second anchor point.
---@param y2 number # The y position of the second anchor point.
---@param maxLength number # The maximum distance for the bodies.
---@param collideConnected? boolean # Specifies whether the two bodies should collide with each other.
---@return love.RopeJoint joint # The new RopeJoint.
function love.physics.newRopeJoint(body1, body2, x1, y1, x2, y2, maxLength, collideConnected) end

---
---Creates a constraint joint between two bodies. A WeldJoint essentially glues two bodies together. The constraint is a bit soft, however, due to Box2D's iterative solver.
---
---@overload fun(body1: love.Body, body2: love.Body, x1: number, y1: number, x2: number, y2: number, collideConnected: boolean):love.WeldJoint
---@overload fun(body1: love.Body, body2: love.Body, x1: number, y1: number, x2: number, y2: number, collideConnected: boolean, referenceAngle: number):love.WeldJoint
---@param body1 love.Body # The first body to attach to the joint.
---@param body2 love.Body # The second body to attach to the joint.
---@param x number # The x position of the anchor point (world space).
---@param y number # The y position of the anchor point (world space).
---@param collideConnected? boolean # Specifies whether the two bodies should collide with each other.
---@return love.WeldJoint joint # The new WeldJoint.
function love.physics.newWeldJoint(body1, body2, x, y, collideConnected) end

---
---Creates a wheel joint.
---
---@overload fun(body1: love.Body, body2: love.Body, x1: number, y1: number, x2: number, y2: number, ax: number, ay: number, collideConnected: boolean):love.WheelJoint
---@param body1 love.Body # The first body.
---@param body2 love.Body # The second body.
---@param x number # The x position of the anchor point.
---@param y number # The y position of the anchor point.
---@param ax number # The x position of the axis unit vector.
---@param ay number # The y position of the axis unit vector.
---@param collideConnected? boolean # Specifies whether the two bodies should collide with each other.
---@return love.WheelJoint joint # The new WheelJoint.
function love.physics.newWheelJoint(body1, body2, x, y, ax, ay, collideConnected) end

---
---Creates a new World.
---
---@param xg? number # The x component of gravity.
---@param yg? number # The y component of gravity.
---@param sleep? boolean # Whether the bodies in this world are allowed to sleep.
---@return love.World world # A brave new World.
function love.physics.newWorld(xg, yg, sleep) end

---
---Sets the pixels to meter scale factor.
---
---All coordinates in the physics module are divided by this number and converted to meters, and it creates a convenient way to draw the objects directly to the screen without the need for graphics transformations.
---
---It is recommended to create shapes no larger than 10 times the scale. This is important because Box2D is tuned to work well with shape sizes from 0.1 to 10 meters. The default meter scale is 30.
---
---@param scale number # The scale factor as an integer.
function love.physics.setMeter(scale) end

---
---Bodies are objects with velocity and position.
---
---@class love.Body: love.Object
local Body = {}

---
---Applies an angular impulse to a body. This makes a single, instantaneous addition to the body momentum.
---
---A body with with a larger mass will react less. The reaction does '''not''' depend on the timestep, and is equivalent to applying a force continuously for 1 second. Impulses are best used to give a single push to a body. For a continuous push to a body it is better to use Body:applyForce.
---
---@param impulse number # The impulse in kilogram-square meter per second.
function Body:applyAngularImpulse(impulse) end

---
---Apply force to a Body.
---
---A force pushes a body in a direction. A body with with a larger mass will react less. The reaction also depends on how long a force is applied: since the force acts continuously over the entire timestep, a short timestep will only push the body for a short time. Thus forces are best used for many timesteps to give a continuous push to a body (like gravity). For a single push that is independent of timestep, it is better to use Body:applyLinearImpulse.
---
---If the position to apply the force is not given, it will act on the center of mass of the body. The part of the force not directed towards the center of mass will cause the body to spin (and depends on the rotational inertia).
---
---Note that the force components and position must be given in world coordinates.
---
---@overload fun(fx: number, fy: number, x: number, y: number)
---@param fx number # The x component of force to apply to the center of mass.
---@param fy number # The y component of force to apply to the center of mass.
function Body:applyForce(fx, fy) end

---
---Applies an impulse to a body.
---
---This makes a single, instantaneous addition to the body momentum.
---
---An impulse pushes a body in a direction. A body with with a larger mass will react less. The reaction does '''not''' depend on the timestep, and is equivalent to applying a force continuously for 1 second. Impulses are best used to give a single push to a body. For a continuous push to a body it is better to use Body:applyForce.
---
---If the position to apply the impulse is not given, it will act on the center of mass of the body. The part of the impulse not directed towards the center of mass will cause the body to spin (and depends on the rotational inertia). 
---
---Note that the impulse components and position must be given in world coordinates.
---
---@overload fun(ix: number, iy: number, x: number, y: number)
---@param ix number # The x component of the impulse applied to the center of mass.
---@param iy number # The y component of the impulse applied to the center of mass.
function Body:applyLinearImpulse(ix, iy) end

---
---Apply torque to a body.
---
---Torque is like a force that will change the angular velocity (spin) of a body. The effect will depend on the rotational inertia a body has.
---
---@param torque number # The torque to apply.
function Body:applyTorque(torque) end

---
---Explicitly destroys the Body and all fixtures and joints attached to it.
---
---An error will occur if you attempt to use the object after calling this function. In 0.7.2, when you don't have time to wait for garbage collection, this function may be used to free the object immediately.
---
function Body:destroy() end

---
---Get the angle of the body.
---
---The angle is measured in radians. If you need to transform it to degrees, use math.deg.
---
---A value of 0 radians will mean 'looking to the right'. Although radians increase counter-clockwise, the y axis points down so it becomes ''clockwise'' from our point of view.
---
---@return number angle # The angle in radians.
function Body:getAngle() end

---
---Gets the Angular damping of the Body
---
---The angular damping is the ''rate of decrease of the angular velocity over time'': A spinning body with no damping and no external forces will continue spinning indefinitely. A spinning body with damping will gradually stop spinning.
---
---Damping is not the same as friction - they can be modelled together. However, only damping is provided by Box2D (and LOVE).
---
---Damping parameters should be between 0 and infinity, with 0 meaning no damping, and infinity meaning full damping. Normally you will use a damping value between 0 and 0.1.
---
---@return number damping # The value of the angular damping.
function Body:getAngularDamping() end

---
---Get the angular velocity of the Body.
---
---The angular velocity is the ''rate of change of angle over time''.
---
---It is changed in World:update by applying torques, off centre forces/impulses, and angular damping. It can be set directly with Body:setAngularVelocity.
---
---If you need the ''rate of change of position over time'', use Body:getLinearVelocity.
---
---@return number w # The angular velocity in radians/second.
function Body:getAngularVelocity() end

---
---Gets a list of all Contacts attached to the Body.
---
---@return table contacts # A list with all contacts associated with the Body.
function Body:getContacts() end

---
---Returns a table with all fixtures.
---
---@return table fixtures # A sequence with all fixtures.
function Body:getFixtures() end

---
---Returns the gravity scale factor.
---
---@return number scale # The gravity scale factor.
function Body:getGravityScale() end

---
---Gets the rotational inertia of the body.
---
---The rotational inertia is how hard is it to make the body spin.
---
---@return number inertia # The rotational inertial of the body.
function Body:getInertia() end

---
---Returns a table containing the Joints attached to this Body.
---
---@return table joints # A sequence with the Joints attached to the Body.
function Body:getJoints() end

---
---Gets the linear damping of the Body.
---
---The linear damping is the ''rate of decrease of the linear velocity over time''. A moving body with no damping and no external forces will continue moving indefinitely, as is the case in space. A moving body with damping will gradually stop moving.
---
---Damping is not the same as friction - they can be modelled together.
---
---@return number damping # The value of the linear damping.
function Body:getLinearDamping() end

---
---Gets the linear velocity of the Body from its center of mass.
---
---The linear velocity is the ''rate of change of position over time''.
---
---If you need the ''rate of change of angle over time'', use Body:getAngularVelocity.
---
---If you need to get the linear velocity of a point different from the center of mass:
---
---*  Body:getLinearVelocityFromLocalPoint allows you to specify the point in local coordinates.
---
---*  Body:getLinearVelocityFromWorldPoint allows you to specify the point in world coordinates.
---
---See page 136 of 'Essential Mathematics for Games and Interactive Applications' for definitions of local and world coordinates.
---
---@return number x # The x-component of the velocity vector
---@return number y # The y-component of the velocity vector
function Body:getLinearVelocity() end

---
---Get the linear velocity of a point on the body.
---
---The linear velocity for a point on the body is the velocity of the body center of mass plus the velocity at that point from the body spinning.
---
---The point on the body must given in local coordinates. Use Body:getLinearVelocityFromWorldPoint to specify this with world coordinates.
---
---@param x number # The x position to measure velocity.
---@param y number # The y position to measure velocity.
---@return number vx # The x component of velocity at point (x,y).
---@return number vy # The y component of velocity at point (x,y).
function Body:getLinearVelocityFromLocalPoint(x, y) end

---
---Get the linear velocity of a point on the body.
---
---The linear velocity for a point on the body is the velocity of the body center of mass plus the velocity at that point from the body spinning.
---
---The point on the body must given in world coordinates. Use Body:getLinearVelocityFromLocalPoint to specify this with local coordinates.
---
---@param x number # The x position to measure velocity.
---@param y number # The y position to measure velocity.
---@return number vx # The x component of velocity at point (x,y).
---@return number vy # The y component of velocity at point (x,y).
function Body:getLinearVelocityFromWorldPoint(x, y) end

---
---Get the center of mass position in local coordinates.
---
---Use Body:getWorldCenter to get the center of mass in world coordinates.
---
---@return number x # The x coordinate of the center of mass.
---@return number y # The y coordinate of the center of mass.
function Body:getLocalCenter() end

---
---Transform a point from world coordinates to local coordinates.
---
---@param worldX number # The x position in world coordinates.
---@param worldY number # The y position in world coordinates.
---@return number localX # The x position in local coordinates.
---@return number localY # The y position in local coordinates.
function Body:getLocalPoint(worldX, worldY) end

---
---Transform a vector from world coordinates to local coordinates.
---
---@param worldX number # The vector x component in world coordinates.
---@param worldY number # The vector y component in world coordinates.
---@return number localX # The vector x component in local coordinates.
---@return number localY # The vector y component in local coordinates.
function Body:getLocalVector(worldX, worldY) end

---
---Get the mass of the body.
---
---Static bodies always have a mass of 0.
---
---@return number mass # The mass of the body (in kilograms).
function Body:getMass() end

---
---Returns the mass, its center, and the rotational inertia.
---
---@return number x # The x position of the center of mass.
---@return number y # The y position of the center of mass.
---@return number mass # The mass of the body.
---@return number inertia # The rotational inertia.
function Body:getMassData() end

---
---Get the position of the body.
---
---Note that this may not be the center of mass of the body.
---
---@return number x # The x position.
---@return number y # The y position.
function Body:getPosition() end

---
---Get the position and angle of the body.
---
---Note that the position may not be the center of mass of the body. An angle of 0 radians will mean 'looking to the right'. Although radians increase counter-clockwise, the y axis points down so it becomes clockwise from our point of view.
---
---@return number x # The x component of the position.
---@return number y # The y component of the position.
---@return number angle # The angle in radians.
function Body:getTransform() end

---
---Returns the type of the body.
---
---@return love.BodyType type # The body type.
function Body:getType() end

---
---Returns the Lua value associated with this Body.
---
---@return any value # The Lua value associated with the Body.
function Body:getUserData() end

---
---Gets the World the body lives in.
---
---@return love.World world # The world the body lives in.
function Body:getWorld() end

---
---Get the center of mass position in world coordinates.
---
---Use Body:getLocalCenter to get the center of mass in local coordinates.
---
---@return number x # The x coordinate of the center of mass.
---@return number y # The y coordinate of the center of mass.
function Body:getWorldCenter() end

---
---Transform a point from local coordinates to world coordinates.
---
---@param localX number # The x position in local coordinates.
---@param localY number # The y position in local coordinates.
---@return number worldX # The x position in world coordinates.
---@return number worldY # The y position in world coordinates.
function Body:getWorldPoint(localX, localY) end

---
---Transforms multiple points from local coordinates to world coordinates.
---
---@param x1 number # The x position of the first point.
---@param y1 number # The y position of the first point.
---@param x2 number # The x position of the second point.
---@param y2 number # The y position of the second point.
---@return number x1 # The transformed x position of the first point.
---@return number y1 # The transformed y position of the first point.
---@return number x2 # The transformed x position of the second point.
---@return number y2 # The transformed y position of the second point.
function Body:getWorldPoints(x1, y1, x2, y2) end

---
---Transform a vector from local coordinates to world coordinates.
---
---@param localX number # The vector x component in local coordinates.
---@param localY number # The vector y component in local coordinates.
---@return number worldX # The vector x component in world coordinates.
---@return number worldY # The vector y component in world coordinates.
function Body:getWorldVector(localX, localY) end

---
---Get the x position of the body in world coordinates.
---
---@return number x # The x position in world coordinates.
function Body:getX() end

---
---Get the y position of the body in world coordinates.
---
---@return number y # The y position in world coordinates.
function Body:getY() end

---
---Returns whether the body is actively used in the simulation.
---
---@return boolean status # True if the body is active or false if not.
function Body:isActive() end

---
---Returns the sleep status of the body.
---
---@return boolean status # True if the body is awake or false if not.
function Body:isAwake() end

---
---Get the bullet status of a body.
---
---There are two methods to check for body collisions:
---
---*  at their location when the world is updated (default)
---
---*  using continuous collision detection (CCD)
---
---The default method is efficient, but a body moving very quickly may sometimes jump over another body without producing a collision. A body that is set as a bullet will use CCD. This is less efficient, but is guaranteed not to jump when moving quickly.
---
---Note that static bodies (with zero mass) always use CCD, so your walls will not let a fast moving body pass through even if it is not a bullet.
---
---@return boolean status # The bullet status of the body.
function Body:isBullet() end

---
---Gets whether the Body is destroyed. Destroyed bodies cannot be used.
---
---@return boolean destroyed # Whether the Body is destroyed.
function Body:isDestroyed() end

---
---Returns whether the body rotation is locked.
---
---@return boolean fixed # True if the body's rotation is locked or false if not.
function Body:isFixedRotation() end

---
---Returns the sleeping behaviour of the body.
---
---@return boolean allowed # True if the body is allowed to sleep or false if not.
function Body:isSleepingAllowed() end

---
---Gets whether the Body is touching the given other Body.
---
---@param otherbody love.Body # The other body to check.
---@return boolean touching # True if this body is touching the other body, false otherwise.
function Body:isTouching(otherbody) end

---
---Resets the mass of the body by recalculating it from the mass properties of the fixtures.
---
function Body:resetMassData() end

---
---Sets whether the body is active in the world.
---
---An inactive body does not take part in the simulation. It will not move or cause any collisions.
---
---@param active boolean # If the body is active or not.
function Body:setActive(active) end

---
---Set the angle of the body.
---
---The angle is measured in radians. If you need to transform it from degrees, use math.rad.
---
---A value of 0 radians will mean 'looking to the right'. Although radians increase counter-clockwise, the y axis points down so it becomes ''clockwise'' from our point of view.
---
---It is possible to cause a collision with another body by changing its angle. 
---
---@param angle number # The angle in radians.
function Body:setAngle(angle) end

---
---Sets the angular damping of a Body
---
---See Body:getAngularDamping for a definition of angular damping.
---
---Angular damping can take any value from 0 to infinity. It is recommended to stay between 0 and 0.1, though. Other values will look unrealistic.
---
---@param damping number # The new angular damping.
function Body:setAngularDamping(damping) end

---
---Sets the angular velocity of a Body.
---
---The angular velocity is the ''rate of change of angle over time''.
---
---This function will not accumulate anything; any impulses previously applied since the last call to World:update will be lost. 
---
---@param w number # The new angular velocity, in radians per second
function Body:setAngularVelocity(w) end

---
---Wakes the body up or puts it to sleep.
---
---@param awake boolean # The body sleep status.
function Body:setAwake(awake) end

---
---Set the bullet status of a body.
---
---There are two methods to check for body collisions:
---
---*  at their location when the world is updated (default)
---
---*  using continuous collision detection (CCD)
---
---The default method is efficient, but a body moving very quickly may sometimes jump over another body without producing a collision. A body that is set as a bullet will use CCD. This is less efficient, but is guaranteed not to jump when moving quickly.
---
---Note that static bodies (with zero mass) always use CCD, so your walls will not let a fast moving body pass through even if it is not a bullet.
---
---@param status boolean # The bullet status of the body.
function Body:setBullet(status) end

---
---Set whether a body has fixed rotation.
---
---Bodies with fixed rotation don't vary the speed at which they rotate. Calling this function causes the mass to be reset. 
---
---@param isFixed boolean # Whether the body should have fixed rotation.
function Body:setFixedRotation(isFixed) end

---
---Sets a new gravity scale factor for the body.
---
---@param scale number # The new gravity scale factor.
function Body:setGravityScale(scale) end

---
---Set the inertia of a body.
---
---@param inertia number # The new moment of inertia, in kilograms * pixel squared.
function Body:setInertia(inertia) end

---
---Sets the linear damping of a Body
---
---See Body:getLinearDamping for a definition of linear damping.
---
---Linear damping can take any value from 0 to infinity. It is recommended to stay between 0 and 0.1, though. Other values will make the objects look 'floaty'(if gravity is enabled).
---
---@param ld number # The new linear damping
function Body:setLinearDamping(ld) end

---
---Sets a new linear velocity for the Body.
---
---This function will not accumulate anything; any impulses previously applied since the last call to World:update will be lost.
---
---@param x number # The x-component of the velocity vector.
---@param y number # The y-component of the velocity vector.
function Body:setLinearVelocity(x, y) end

---
---Sets a new body mass.
---
---@param mass number # The mass, in kilograms.
function Body:setMass(mass) end

---
---Overrides the calculated mass data.
---
---@param x number # The x position of the center of mass.
---@param y number # The y position of the center of mass.
---@param mass number # The mass of the body.
---@param inertia number # The rotational inertia.
function Body:setMassData(x, y, mass, inertia) end

---
---Set the position of the body.
---
---Note that this may not be the center of mass of the body.
---
---This function cannot wake up the body.
---
---@param x number # The x position.
---@param y number # The y position.
function Body:setPosition(x, y) end

---
---Sets the sleeping behaviour of the body. Should sleeping be allowed, a body at rest will automatically sleep. A sleeping body is not simulated unless it collided with an awake body. Be wary that one can end up with a situation like a floating sleeping body if the floor was removed.
---
---@param allowed boolean # True if the body is allowed to sleep or false if not.
function Body:setSleepingAllowed(allowed) end

---
---Set the position and angle of the body.
---
---Note that the position may not be the center of mass of the body. An angle of 0 radians will mean 'looking to the right'. Although radians increase counter-clockwise, the y axis points down so it becomes clockwise from our point of view.
---
---This function cannot wake up the body.
---
---@param x number # The x component of the position.
---@param y number # The y component of the position.
---@param angle number # The angle in radians.
function Body:setTransform(x, y, angle) end

---
---Sets a new body type.
---
---@param type love.BodyType # The new type.
function Body:setType(type) end

---
---Associates a Lua value with the Body.
---
---To delete the reference, explicitly pass nil.
---
---@param value any # The Lua value to associate with the Body.
function Body:setUserData(value) end

---
---Set the x position of the body.
---
---This function cannot wake up the body. 
---
---@param x number # The x position.
function Body:setX(x) end

---
---Set the y position of the body.
---
---This function cannot wake up the body. 
---
---@param y number # The y position.
function Body:setY(y) end

---
---A ChainShape consists of multiple line segments. It can be used to create the boundaries of your terrain. The shape does not have volume and can only collide with PolygonShape and CircleShape.
---
---Unlike the PolygonShape, the ChainShape does not have a vertices limit or has to form a convex shape, but self intersections are not supported.
---
---@class love.ChainShape: love.Shape, love.Object
local ChainShape = {}

---
---Returns a child of the shape as an EdgeShape.
---
---@param index number # The index of the child.
---@return love.EdgeShape shape # The child as an EdgeShape.
function ChainShape:getChildEdge(index) end

---
---Gets the vertex that establishes a connection to the next shape.
---
---Setting next and previous ChainShape vertices can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---@return number x # The x-component of the vertex, or nil if ChainShape:setNextVertex hasn't been called.
---@return number y # The y-component of the vertex, or nil if ChainShape:setNextVertex hasn't been called.
function ChainShape:getNextVertex() end

---
---Returns a point of the shape.
---
---@param index number # The index of the point to return.
---@return number x # The x-coordinate of the point.
---@return number y # The y-coordinate of the point.
function ChainShape:getPoint(index) end

---
---Returns all points of the shape.
---
---@return number x1 # The x-coordinate of the first point.
---@return number y1 # The y-coordinate of the first point.
---@return number x2 # The x-coordinate of the second point.
---@return number y2 # The y-coordinate of the second point.
function ChainShape:getPoints() end

---
---Gets the vertex that establishes a connection to the previous shape.
---
---Setting next and previous ChainShape vertices can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---@return number x # The x-component of the vertex, or nil if ChainShape:setPreviousVertex hasn't been called.
---@return number y # The y-component of the vertex, or nil if ChainShape:setPreviousVertex hasn't been called.
function ChainShape:getPreviousVertex() end

---
---Returns the number of vertices the shape has.
---
---@return number count # The number of vertices.
function ChainShape:getVertexCount() end

---
---Sets a vertex that establishes a connection to the next shape.
---
---This can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---@param x number # The x-component of the vertex.
---@param y number # The y-component of the vertex.
function ChainShape:setNextVertex(x, y) end

---
---Sets a vertex that establishes a connection to the previous shape.
---
---This can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---@param x number # The x-component of the vertex.
---@param y number # The y-component of the vertex.
function ChainShape:setPreviousVertex(x, y) end

---
---Circle extends Shape and adds a radius and a local position.
---
---@class love.CircleShape: love.Shape, love.Object
local CircleShape = {}

---
---Gets the center point of the circle shape.
---
---@return number x # The x-component of the center point of the circle.
---@return number y # The y-component of the center point of the circle.
function CircleShape:getPoint() end

---
---Gets the radius of the circle shape.
---
---@return number radius # The radius of the circle
function CircleShape:getRadius() end

---
---Sets the location of the center of the circle shape.
---
---@param x number # The x-component of the new center point of the circle.
---@param y number # The y-component of the new center point of the circle.
function CircleShape:setPoint(x, y) end

---
---Sets the radius of the circle.
---
---@param radius number # The radius of the circle
function CircleShape:setRadius(radius) end

---
---Contacts are objects created to manage collisions in worlds.
---
---@class love.Contact: love.Object
local Contact = {}

---
---Gets the two Fixtures that hold the shapes that are in contact.
---
---@return love.Fixture fixtureA # The first Fixture.
---@return love.Fixture fixtureB # The second Fixture.
function Contact:getFixtures() end

---
---Get the friction between two shapes that are in contact.
---
---@return number friction # The friction of the contact.
function Contact:getFriction() end

---
---Get the normal vector between two shapes that are in contact.
---
---This function returns the coordinates of a unit vector that points from the first shape to the second.
---
---@return number nx # The x component of the normal vector.
---@return number ny # The y component of the normal vector.
function Contact:getNormal() end

---
---Returns the contact points of the two colliding fixtures. There can be one or two points.
---
---@return number x1 # The x coordinate of the first contact point.
---@return number y1 # The y coordinate of the first contact point.
---@return number x2 # The x coordinate of the second contact point.
---@return number y2 # The y coordinate of the second contact point.
function Contact:getPositions() end

---
---Get the restitution between two shapes that are in contact.
---
---@return number restitution # The restitution between the two shapes.
function Contact:getRestitution() end

---
---Returns whether the contact is enabled. The collision will be ignored if a contact gets disabled in the preSolve callback.
---
---@return boolean enabled # True if enabled, false otherwise.
function Contact:isEnabled() end

---
---Returns whether the two colliding fixtures are touching each other.
---
---@return boolean touching # True if they touch or false if not.
function Contact:isTouching() end

---
---Resets the contact friction to the mixture value of both fixtures.
---
function Contact:resetFriction() end

---
---Resets the contact restitution to the mixture value of both fixtures.
---
function Contact:resetRestitution() end

---
---Enables or disables the contact.
---
---@param enabled boolean # True to enable or false to disable.
function Contact:setEnabled(enabled) end

---
---Sets the contact friction.
---
---@param friction number # The contact friction.
function Contact:setFriction(friction) end

---
---Sets the contact restitution.
---
---@param restitution number # The contact restitution.
function Contact:setRestitution(restitution) end

---
---Keeps two bodies at the same distance.
---
---@class love.DistanceJoint: love.Joint, love.Object
local DistanceJoint = {}

---
---Gets the damping ratio.
---
---@return number ratio # The damping ratio.
function DistanceJoint:getDampingRatio() end

---
---Gets the response speed.
---
---@return number Hz # The response speed.
function DistanceJoint:getFrequency() end

---
---Gets the equilibrium distance between the two Bodies.
---
---@return number l # The length between the two Bodies.
function DistanceJoint:getLength() end

---
---Sets the damping ratio.
---
---@param ratio number # The damping ratio.
function DistanceJoint:setDampingRatio(ratio) end

---
---Sets the response speed.
---
---@param Hz number # The response speed.
function DistanceJoint:setFrequency(Hz) end

---
---Sets the equilibrium distance between the two Bodies.
---
---@param l number # The length between the two Bodies.
function DistanceJoint:setLength(l) end

---
---A EdgeShape is a line segment. They can be used to create the boundaries of your terrain. The shape does not have volume and can only collide with PolygonShape and CircleShape.
---
---@class love.EdgeShape: love.Shape, love.Object
local EdgeShape = {}

---
---Gets the vertex that establishes a connection to the next shape.
---
---Setting next and previous EdgeShape vertices can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---@return number x # The x-component of the vertex, or nil if EdgeShape:setNextVertex hasn't been called.
---@return number y # The y-component of the vertex, or nil if EdgeShape:setNextVertex hasn't been called.
function EdgeShape:getNextVertex() end

---
---Returns the local coordinates of the edge points.
---
---@return number x1 # The x-component of the first vertex.
---@return number y1 # The y-component of the first vertex.
---@return number x2 # The x-component of the second vertex.
---@return number y2 # The y-component of the second vertex.
function EdgeShape:getPoints() end

---
---Gets the vertex that establishes a connection to the previous shape.
---
---Setting next and previous EdgeShape vertices can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---@return number x # The x-component of the vertex, or nil if EdgeShape:setPreviousVertex hasn't been called.
---@return number y # The y-component of the vertex, or nil if EdgeShape:setPreviousVertex hasn't been called.
function EdgeShape:getPreviousVertex() end

---
---Sets a vertex that establishes a connection to the next shape.
---
---This can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---@param x number # The x-component of the vertex.
---@param y number # The y-component of the vertex.
function EdgeShape:setNextVertex(x, y) end

---
---Sets a vertex that establishes a connection to the previous shape.
---
---This can help prevent unwanted collisions when a flat shape slides along the edge and moves over to the new shape.
---
---@param x number # The x-component of the vertex.
---@param y number # The y-component of the vertex.
function EdgeShape:setPreviousVertex(x, y) end

---
---Fixtures attach shapes to bodies.
---
---@class love.Fixture: love.Object
local Fixture = {}

---
---Destroys the fixture.
---
function Fixture:destroy() end

---
---Returns the body to which the fixture is attached.
---
---@return love.Body body # The parent body.
function Fixture:getBody() end

---
---Returns the points of the fixture bounding box. In case the fixture has multiple children a 1-based index can be specified. For example, a fixture will have multiple children with a chain shape.
---
---@param index? number # A bounding box of the fixture.
---@return number topLeftX # The x position of the top-left point.
---@return number topLeftY # The y position of the top-left point.
---@return number bottomRightX # The x position of the bottom-right point.
---@return number bottomRightY # The y position of the bottom-right point.
function Fixture:getBoundingBox(index) end

---
---Returns the categories the fixture belongs to.
---
---@return number category1 # The first category.
---@return number category2 # The second category.
function Fixture:getCategory() end

---
---Returns the density of the fixture.
---
---@return number density # The fixture density in kilograms per square meter.
function Fixture:getDensity() end

---
---Returns the filter data of the fixture.
---
---Categories and masks are encoded as the bits of a 16-bit integer.
---
---@return number categories # The categories as an integer from 0 to 65535.
---@return number mask # The mask as an integer from 0 to 65535.
---@return number group # The group as an integer from -32768 to 32767.
function Fixture:getFilterData() end

---
---Returns the friction of the fixture.
---
---@return number friction # The fixture friction.
function Fixture:getFriction() end

---
---Returns the group the fixture belongs to. Fixtures with the same group will always collide if the group is positive or never collide if it's negative. The group zero means no group.
---
---The groups range from -32768 to 32767.
---
---@return number group # The group of the fixture.
function Fixture:getGroupIndex() end

---
---Returns which categories this fixture should '''NOT''' collide with.
---
---@return number mask1 # The first category selected by the mask.
---@return number mask2 # The second category selected by the mask.
function Fixture:getMask() end

---
---Returns the mass, its center and the rotational inertia.
---
---@return number x # The x position of the center of mass.
---@return number y # The y position of the center of mass.
---@return number mass # The mass of the fixture.
---@return number inertia # The rotational inertia.
function Fixture:getMassData() end

---
---Returns the restitution of the fixture.
---
---@return number restitution # The fixture restitution.
function Fixture:getRestitution() end

---
---Returns the shape of the fixture. This shape is a reference to the actual data used in the simulation. It's possible to change its values between timesteps.
---
---@return love.Shape shape # The fixture's shape.
function Fixture:getShape() end

---
---Returns the Lua value associated with this fixture.
---
---@return any value # The Lua value associated with the fixture.
function Fixture:getUserData() end

---
---Gets whether the Fixture is destroyed. Destroyed fixtures cannot be used.
---
---@return boolean destroyed # Whether the Fixture is destroyed.
function Fixture:isDestroyed() end

---
---Returns whether the fixture is a sensor.
---
---@return boolean sensor # If the fixture is a sensor.
function Fixture:isSensor() end

---
---Casts a ray against the shape of the fixture and returns the surface normal vector and the line position where the ray hit. If the ray missed the shape, nil will be returned.
---
---The ray starts on the first point of the input line and goes towards the second point of the line. The fifth argument is the maximum distance the ray is going to travel as a scale factor of the input line length.
---
---The childIndex parameter is used to specify which child of a parent shape, such as a ChainShape, will be ray casted. For ChainShapes, the index of 1 is the first edge on the chain. Ray casting a parent shape will only test the child specified so if you want to test every shape of the parent, you must loop through all of its children.
---
---The world position of the impact can be calculated by multiplying the line vector with the third return value and adding it to the line starting point.
---
---hitx, hity = x1 + (x2 - x1) * fraction, y1 + (y2 - y1) * fraction
---
---@param x1 number # The x position of the input line starting point.
---@param y1 number # The y position of the input line starting point.
---@param x2 number # The x position of the input line end point.
---@param y2 number # The y position of the input line end point.
---@param maxFraction number # Ray length parameter.
---@param childIndex? number # The index of the child the ray gets cast against.
---@return number xn # The x component of the normal vector of the edge where the ray hit the shape.
---@return number yn # The y component of the normal vector of the edge where the ray hit the shape.
---@return number fraction # The position on the input line where the intersection happened as a factor of the line length.
function Fixture:rayCast(x1, y1, x2, y2, maxFraction, childIndex) end

---
---Sets the categories the fixture belongs to. There can be up to 16 categories represented as a number from 1 to 16.
---
---All fixture's default category is 1.
---
---@param category1 number # The first category.
---@param category2 number # The second category.
function Fixture:setCategory(category1, category2) end

---
---Sets the density of the fixture. Call Body:resetMassData if this needs to take effect immediately.
---
---@param density number # The fixture density in kilograms per square meter.
function Fixture:setDensity(density) end

---
---Sets the filter data of the fixture.
---
---Groups, categories, and mask can be used to define the collision behaviour of the fixture.
---
---If two fixtures are in the same group they either always collide if the group is positive, or never collide if it's negative. If the group is zero or they do not match, then the contact filter checks if the fixtures select a category of the other fixture with their masks. The fixtures do not collide if that's not the case. If they do have each other's categories selected, the return value of the custom contact filter will be used. They always collide if none was set.
---
---There can be up to 16 categories. Categories and masks are encoded as the bits of a 16-bit integer.
---
---When created, prior to calling this function, all fixtures have category set to 1, mask set to 65535 (all categories) and group set to 0.
---
---This function allows setting all filter data for a fixture at once. To set only the categories, the mask or the group, you can use Fixture:setCategory, Fixture:setMask or Fixture:setGroupIndex respectively.
---
---@param categories number # The categories as an integer from 0 to 65535.
---@param mask number # The mask as an integer from 0 to 65535.
---@param group number # The group as an integer from -32768 to 32767.
function Fixture:setFilterData(categories, mask, group) end

---
---Sets the friction of the fixture.
---
---Friction determines how shapes react when they 'slide' along other shapes. Low friction indicates a slippery surface, like ice, while high friction indicates a rough surface, like concrete. Range: 0.0 - 1.0.
---
---@param friction number # The fixture friction.
function Fixture:setFriction(friction) end

---
---Sets the group the fixture belongs to. Fixtures with the same group will always collide if the group is positive or never collide if it's negative. The group zero means no group.
---
---The groups range from -32768 to 32767.
---
---@param group number # The group as an integer from -32768 to 32767.
function Fixture:setGroupIndex(group) end

---
---Sets the category mask of the fixture. There can be up to 16 categories represented as a number from 1 to 16.
---
---This fixture will '''NOT''' collide with the fixtures that are in the selected categories if the other fixture also has a category of this fixture selected.
---
---@param mask1 number # The first category.
---@param mask2 number # The second category.
function Fixture:setMask(mask1, mask2) end

---
---Sets the restitution of the fixture.
---
---@param restitution number # The fixture restitution.
function Fixture:setRestitution(restitution) end

---
---Sets whether the fixture should act as a sensor.
---
---Sensors do not cause collision responses, but the begin-contact and end-contact World callbacks will still be called for this fixture.
---
---@param sensor boolean # The sensor status.
function Fixture:setSensor(sensor) end

---
---Associates a Lua value with the fixture.
---
---To delete the reference, explicitly pass nil.
---
---@param value any # The Lua value to associate with the fixture.
function Fixture:setUserData(value) end

---
---Checks if a point is inside the shape of the fixture.
---
---@param x number # The x position of the point.
---@param y number # The y position of the point.
---@return boolean isInside # True if the point is inside or false if it is outside.
function Fixture:testPoint(x, y) end

---
---A FrictionJoint applies friction to a body.
---
---@class love.FrictionJoint: love.Joint, love.Object
local FrictionJoint = {}

---
---Gets the maximum friction force in Newtons.
---
---@return number force # Maximum force in Newtons.
function FrictionJoint:getMaxForce() end

---
---Gets the maximum friction torque in Newton-meters.
---
---@return number torque # Maximum torque in Newton-meters.
function FrictionJoint:getMaxTorque() end

---
---Sets the maximum friction force in Newtons.
---
---@param maxForce number # Max force in Newtons.
function FrictionJoint:setMaxForce(maxForce) end

---
---Sets the maximum friction torque in Newton-meters.
---
---@param torque number # Maximum torque in Newton-meters.
function FrictionJoint:setMaxTorque(torque) end

---
---Keeps bodies together in such a way that they act like gears.
---
---@class love.GearJoint: love.Joint, love.Object
local GearJoint = {}

---
---Get the Joints connected by this GearJoint.
---
---@return love.Joint joint1 # The first connected Joint.
---@return love.Joint joint2 # The second connected Joint.
function GearJoint:getJoints() end

---
---Get the ratio of a gear joint.
---
---@return number ratio # The ratio of the joint.
function GearJoint:getRatio() end

---
---Set the ratio of a gear joint.
---
---@param ratio number # The new ratio of the joint.
function GearJoint:setRatio(ratio) end

---
---Attach multiple bodies together to interact in unique ways.
---
---@class love.Joint: love.Object
local Joint = {}

---
---Explicitly destroys the Joint. An error will occur if you attempt to use the object after calling this function.
---
---In 0.7.2, when you don't have time to wait for garbage collection, this function 
---
---may be used to free the object immediately.
---
function Joint:destroy() end

---
---Get the anchor points of the joint.
---
---@return number x1 # The x-component of the anchor on Body 1.
---@return number y1 # The y-component of the anchor on Body 1.
---@return number x2 # The x-component of the anchor on Body 2.
---@return number y2 # The y-component of the anchor on Body 2.
function Joint:getAnchors() end

---
---Gets the bodies that the Joint is attached to.
---
---@return love.Body bodyA # The first Body.
---@return love.Body bodyB # The second Body.
function Joint:getBodies() end

---
---Gets whether the connected Bodies collide.
---
---@return boolean c # True if they collide, false otherwise.
function Joint:getCollideConnected() end

---
---Returns the reaction force in newtons on the second body
---
---@param x number # How long the force applies. Usually the inverse time step or 1/dt.
---@return number x # The x-component of the force.
---@return number y # The y-component of the force.
function Joint:getReactionForce(x) end

---
---Returns the reaction torque on the second body.
---
---@param invdt number # How long the force applies. Usually the inverse time step or 1/dt.
---@return number torque # The reaction torque on the second body.
function Joint:getReactionTorque(invdt) end

---
---Gets a string representing the type.
---
---@return love.JointType type # A string with the name of the Joint type.
function Joint:getType() end

---
---Returns the Lua value associated with this Joint.
---
---@return any value # The Lua value associated with the Joint.
function Joint:getUserData() end

---
---Gets whether the Joint is destroyed. Destroyed joints cannot be used.
---
---@return boolean destroyed # Whether the Joint is destroyed.
function Joint:isDestroyed() end

---
---Associates a Lua value with the Joint.
---
---To delete the reference, explicitly pass nil.
---
---@param value any # The Lua value to associate with the Joint.
function Joint:setUserData(value) end

---
---Controls the relative motion between two Bodies. Position and rotation offsets can be specified, as well as the maximum motor force and torque that will be applied to reach the target offsets.
---
---@class love.MotorJoint: love.Joint, love.Object
local MotorJoint = {}

---
---Gets the target angular offset between the two Bodies the Joint is attached to.
---
---@return number angleoffset # The target angular offset in radians: the second body's angle minus the first body's angle.
function MotorJoint:getAngularOffset() end

---
---Gets the target linear offset between the two Bodies the Joint is attached to.
---
---@return number x # The x component of the target linear offset, relative to the first Body.
---@return number y # The y component of the target linear offset, relative to the first Body.
function MotorJoint:getLinearOffset() end

---
---Sets the target angluar offset between the two Bodies the Joint is attached to.
---
---@param angleoffset number # The target angular offset in radians: the second body's angle minus the first body's angle.
function MotorJoint:setAngularOffset(angleoffset) end

---
---Sets the target linear offset between the two Bodies the Joint is attached to.
---
---@param x number # The x component of the target linear offset, relative to the first Body.
---@param y number # The y component of the target linear offset, relative to the first Body.
function MotorJoint:setLinearOffset(x, y) end

---
---For controlling objects with the mouse.
---
---@class love.MouseJoint: love.Joint, love.Object
local MouseJoint = {}

---
---Returns the damping ratio.
---
---@return number ratio # The new damping ratio.
function MouseJoint:getDampingRatio() end

---
---Returns the frequency.
---
---@return number freq # The frequency in hertz.
function MouseJoint:getFrequency() end

---
---Gets the highest allowed force.
---
---@return number f # The max allowed force.
function MouseJoint:getMaxForce() end

---
---Gets the target point.
---
---@return number x # The x-component of the target.
---@return number y # The x-component of the target.
function MouseJoint:getTarget() end

---
---Sets a new damping ratio.
---
---@param ratio number # The new damping ratio.
function MouseJoint:setDampingRatio(ratio) end

---
---Sets a new frequency.
---
---@param freq number # The new frequency in hertz.
function MouseJoint:setFrequency(freq) end

---
---Sets the highest allowed force.
---
---@param f number # The max allowed force.
function MouseJoint:setMaxForce(f) end

---
---Sets the target point.
---
---@param x number # The x-component of the target.
---@param y number # The y-component of the target.
function MouseJoint:setTarget(x, y) end

---
---A PolygonShape is a convex polygon with up to 8 vertices.
---
---@class love.PolygonShape: love.Shape, love.Object
local PolygonShape = {}

---
---Get the local coordinates of the polygon's vertices.
---
---This function has a variable number of return values. It can be used in a nested fashion with love.graphics.polygon.
---
---@return number x1 # The x-component of the first vertex.
---@return number y1 # The y-component of the first vertex.
---@return number x2 # The x-component of the second vertex.
---@return number y2 # The y-component of the second vertex.
function PolygonShape:getPoints() end

---
---Restricts relative motion between Bodies to one shared axis.
---
---@class love.PrismaticJoint: love.Joint, love.Object
local PrismaticJoint = {}

---
---Checks whether the limits are enabled.
---
---@return boolean enabled # True if enabled, false otherwise.
function PrismaticJoint:areLimitsEnabled() end

---
---Gets the world-space axis vector of the Prismatic Joint.
---
---@return number x # The x-axis coordinate of the world-space axis vector.
---@return number y # The y-axis coordinate of the world-space axis vector.
function PrismaticJoint:getAxis() end

---
---Get the current joint angle speed.
---
---@return number s # Joint angle speed in meters/second.
function PrismaticJoint:getJointSpeed() end

---
---Get the current joint translation.
---
---@return number t # Joint translation, usually in meters..
function PrismaticJoint:getJointTranslation() end

---
---Gets the joint limits.
---
---@return number lower # The lower limit, usually in meters.
---@return number upper # The upper limit, usually in meters.
function PrismaticJoint:getLimits() end

---
---Gets the lower limit.
---
---@return number lower # The lower limit, usually in meters.
function PrismaticJoint:getLowerLimit() end

---
---Gets the maximum motor force.
---
---@return number f # The maximum motor force, usually in N.
function PrismaticJoint:getMaxMotorForce() end

---
---Returns the current motor force.
---
---@param invdt number # How long the force applies. Usually the inverse time step or 1/dt.
---@return number force # The force on the motor in newtons.
function PrismaticJoint:getMotorForce(invdt) end

---
---Gets the motor speed.
---
---@return number s # The motor speed, usually in meters per second.
function PrismaticJoint:getMotorSpeed() end

---
---Gets the upper limit.
---
---@return number upper # The upper limit, usually in meters.
function PrismaticJoint:getUpperLimit() end

---
---Checks whether the motor is enabled.
---
---@return boolean enabled # True if enabled, false if disabled.
function PrismaticJoint:isMotorEnabled() end

---
---Sets the limits.
---
---@param lower number # The lower limit, usually in meters.
---@param upper number # The upper limit, usually in meters.
function PrismaticJoint:setLimits(lower, upper) end

---
---Enables/disables the joint limit.
---
---@return boolean enable # True if enabled, false if disabled.
function PrismaticJoint:setLimitsEnabled() end

---
---Sets the lower limit.
---
---@param lower number # The lower limit, usually in meters.
function PrismaticJoint:setLowerLimit(lower) end

---
---Set the maximum motor force.
---
---@param f number # The maximum motor force, usually in N.
function PrismaticJoint:setMaxMotorForce(f) end

---
---Enables/disables the joint motor.
---
---@param enable boolean # True to enable, false to disable.
function PrismaticJoint:setMotorEnabled(enable) end

---
---Sets the motor speed.
---
---@param s number # The motor speed, usually in meters per second.
function PrismaticJoint:setMotorSpeed(s) end

---
---Sets the upper limit.
---
---@param upper number # The upper limit, usually in meters.
function PrismaticJoint:setUpperLimit(upper) end

---
---Allows you to simulate bodies connected through pulleys.
---
---@class love.PulleyJoint: love.Joint, love.Object
local PulleyJoint = {}

---
---Get the total length of the rope.
---
---@return number length # The length of the rope in the joint.
function PulleyJoint:getConstant() end

---
---Get the ground anchor positions in world coordinates.
---
---@return number a1x # The x coordinate of the first anchor.
---@return number a1y # The y coordinate of the first anchor.
---@return number a2x # The x coordinate of the second anchor.
---@return number a2y # The y coordinate of the second anchor.
function PulleyJoint:getGroundAnchors() end

---
---Get the current length of the rope segment attached to the first body.
---
---@return number length # The length of the rope segment.
function PulleyJoint:getLengthA() end

---
---Get the current length of the rope segment attached to the second body.
---
---@return number length # The length of the rope segment.
function PulleyJoint:getLengthB() end

---
---Get the maximum lengths of the rope segments.
---
---@return number len1 # The maximum length of the first rope segment.
---@return number len2 # The maximum length of the second rope segment.
function PulleyJoint:getMaxLengths() end

---
---Get the pulley ratio.
---
---@return number ratio # The pulley ratio of the joint.
function PulleyJoint:getRatio() end

---
---Set the total length of the rope.
---
---Setting a new length for the rope updates the maximum length values of the joint.
---
---@param length number # The new length of the rope in the joint.
function PulleyJoint:setConstant(length) end

---
---Set the maximum lengths of the rope segments.
---
---The physics module also imposes maximum values for the rope segments. If the parameters exceed these values, the maximum values are set instead of the requested values.
---
---@param max1 number # The new maximum length of the first segment.
---@param max2 number # The new maximum length of the second segment.
function PulleyJoint:setMaxLengths(max1, max2) end

---
---Set the pulley ratio.
---
---@param ratio number # The new pulley ratio of the joint.
function PulleyJoint:setRatio(ratio) end

---
---Allow two Bodies to revolve around a shared point.
---
---@class love.RevoluteJoint: love.Joint, love.Object
local RevoluteJoint = {}

---
---Checks whether limits are enabled.
---
---@return boolean enabled # True if enabled, false otherwise.
function RevoluteJoint:areLimitsEnabled() end

---
---Get the current joint angle.
---
---@return number angle # The joint angle in radians.
function RevoluteJoint:getJointAngle() end

---
---Get the current joint angle speed.
---
---@return number s # Joint angle speed in radians/second.
function RevoluteJoint:getJointSpeed() end

---
---Gets the joint limits.
---
---@return number lower # The lower limit, in radians.
---@return number upper # The upper limit, in radians.
function RevoluteJoint:getLimits() end

---
---Gets the lower limit.
---
---@return number lower # The lower limit, in radians.
function RevoluteJoint:getLowerLimit() end

---
---Gets the maximum motor force.
---
---@return number f # The maximum motor force, in Nm.
function RevoluteJoint:getMaxMotorTorque() end

---
---Gets the motor speed.
---
---@return number s # The motor speed, radians per second.
function RevoluteJoint:getMotorSpeed() end

---
---Get the current motor force.
---
---@return number f # The current motor force, in Nm.
function RevoluteJoint:getMotorTorque() end

---
---Gets the upper limit.
---
---@return number upper # The upper limit, in radians.
function RevoluteJoint:getUpperLimit() end

---
---Checks whether limits are enabled.
---
---@return boolean enabled # True if enabled, false otherwise.
function RevoluteJoint:hasLimitsEnabled() end

---
---Checks whether the motor is enabled.
---
---@return boolean enabled # True if enabled, false if disabled.
function RevoluteJoint:isMotorEnabled() end

---
---Sets the limits.
---
---@param lower number # The lower limit, in radians.
---@param upper number # The upper limit, in radians.
function RevoluteJoint:setLimits(lower, upper) end

---
---Enables/disables the joint limit.
---
---@param enable boolean # True to enable, false to disable.
function RevoluteJoint:setLimitsEnabled(enable) end

---
---Sets the lower limit.
---
---@param lower number # The lower limit, in radians.
function RevoluteJoint:setLowerLimit(lower) end

---
---Set the maximum motor force.
---
---@param f number # The maximum motor force, in Nm.
function RevoluteJoint:setMaxMotorTorque(f) end

---
---Enables/disables the joint motor.
---
---@param enable boolean # True to enable, false to disable.
function RevoluteJoint:setMotorEnabled(enable) end

---
---Sets the motor speed.
---
---@param s number # The motor speed, radians per second.
function RevoluteJoint:setMotorSpeed(s) end

---
---Sets the upper limit.
---
---@param upper number # The upper limit, in radians.
function RevoluteJoint:setUpperLimit(upper) end

---
---The RopeJoint enforces a maximum distance between two points on two bodies. It has no other effect.
---
---@class love.RopeJoint: love.Joint, love.Object
local RopeJoint = {}

---
---Gets the maximum length of a RopeJoint.
---
---@return number maxLength # The maximum length of the RopeJoint.
function RopeJoint:getMaxLength() end

---
---Sets the maximum length of a RopeJoint.
---
---@param maxLength number # The new maximum length of the RopeJoint.
function RopeJoint:setMaxLength(maxLength) end

---
---Shapes are solid 2d geometrical objects which handle the mass and collision of a Body in love.physics.
---
---Shapes are attached to a Body via a Fixture. The Shape object is copied when this happens. 
---
---The Shape's position is relative to the position of the Body it has been attached to.
---
---@class love.Shape: love.Object
local Shape = {}

---
---Returns the points of the bounding box for the transformed shape.
---
---@param tx number # The translation of the shape on the x-axis.
---@param ty number # The translation of the shape on the y-axis.
---@param tr number # The shape rotation.
---@param childIndex? number # The index of the child to compute the bounding box of.
---@return number topLeftX # The x position of the top-left point.
---@return number topLeftY # The y position of the top-left point.
---@return number bottomRightX # The x position of the bottom-right point.
---@return number bottomRightY # The y position of the bottom-right point.
function Shape:computeAABB(tx, ty, tr, childIndex) end

---
---Computes the mass properties for the shape with the specified density.
---
---@param density number # The shape density.
---@return number x # The x postition of the center of mass.
---@return number y # The y postition of the center of mass.
---@return number mass # The mass of the shape.
---@return number inertia # The rotational inertia.
function Shape:computeMass(density) end

---
---Returns the number of children the shape has.
---
---@return number count # The number of children.
function Shape:getChildCount() end

---
---Gets the radius of the shape.
---
---@return number radius # The radius of the shape.
function Shape:getRadius() end

---
---Gets a string representing the Shape.
---
---This function can be useful for conditional debug drawing.
---
---@return love.ShapeType type # The type of the Shape.
function Shape:getType() end

---
---Casts a ray against the shape and returns the surface normal vector and the line position where the ray hit. If the ray missed the shape, nil will be returned. The Shape can be transformed to get it into the desired position.
---
---The ray starts on the first point of the input line and goes towards the second point of the line. The fourth argument is the maximum distance the ray is going to travel as a scale factor of the input line length.
---
---The childIndex parameter is used to specify which child of a parent shape, such as a ChainShape, will be ray casted. For ChainShapes, the index of 1 is the first edge on the chain. Ray casting a parent shape will only test the child specified so if you want to test every shape of the parent, you must loop through all of its children.
---
---The world position of the impact can be calculated by multiplying the line vector with the third return value and adding it to the line starting point.
---
---hitx, hity = x1 + (x2 - x1) * fraction, y1 + (y2 - y1) * fraction
---
---@param x1 number # The x position of the input line starting point.
---@param y1 number # The y position of the input line starting point.
---@param x2 number # The x position of the input line end point.
---@param y2 number # The y position of the input line end point.
---@param maxFraction number # Ray length parameter.
---@param tx number # The translation of the shape on the x-axis.
---@param ty number # The translation of the shape on the y-axis.
---@param tr number # The shape rotation.
---@param childIndex? number # The index of the child the ray gets cast against.
---@return number xn # The x component of the normal vector of the edge where the ray hit the shape.
---@return number yn # The y component of the normal vector of the edge where the ray hit the shape.
---@return number fraction # The position on the input line where the intersection happened as a factor of the line length.
function Shape:rayCast(x1, y1, x2, y2, maxFraction, tx, ty, tr, childIndex) end

---
---This is particularly useful for mouse interaction with the shapes. By looping through all shapes and testing the mouse position with this function, we can find which shapes the mouse touches.
---
---@param tx number # Translates the shape along the x-axis.
---@param ty number # Translates the shape along the y-axis.
---@param tr number # Rotates the shape.
---@param x number # The x-component of the point.
---@param y number # The y-component of the point.
---@return boolean hit # True if inside, false if outside
function Shape:testPoint(tx, ty, tr, x, y) end

---
---A WeldJoint essentially glues two bodies together.
---
---@class love.WeldJoint: love.Joint, love.Object
local WeldJoint = {}

---
---Returns the damping ratio of the joint.
---
---@return number ratio # The damping ratio.
function WeldJoint:getDampingRatio() end

---
---Returns the frequency.
---
---@return number freq # The frequency in hertz.
function WeldJoint:getFrequency() end

---
---Sets a new damping ratio.
---
---@param ratio number # The new damping ratio.
function WeldJoint:setDampingRatio(ratio) end

---
---Sets a new frequency.
---
---@param freq number # The new frequency in hertz.
function WeldJoint:setFrequency(freq) end

---
---Restricts a point on the second body to a line on the first body.
---
---@class love.WheelJoint: love.Joint, love.Object
local WheelJoint = {}

---
---Gets the world-space axis vector of the Wheel Joint.
---
---@return number x # The x-axis coordinate of the world-space axis vector.
---@return number y # The y-axis coordinate of the world-space axis vector.
function WheelJoint:getAxis() end

---
---Returns the current joint translation speed.
---
---@return number speed # The translation speed of the joint in meters per second.
function WheelJoint:getJointSpeed() end

---
---Returns the current joint translation.
---
---@return number position # The translation of the joint in meters.
function WheelJoint:getJointTranslation() end

---
---Returns the maximum motor torque.
---
---@return number maxTorque # The maximum torque of the joint motor in newton meters.
function WheelJoint:getMaxMotorTorque() end

---
---Returns the speed of the motor.
---
---@return number speed # The speed of the joint motor in radians per second.
function WheelJoint:getMotorSpeed() end

---
---Returns the current torque on the motor.
---
---@param invdt number # How long the force applies. Usually the inverse time step or 1/dt.
---@return number torque # The torque on the motor in newton meters.
function WheelJoint:getMotorTorque(invdt) end

---
---Returns the damping ratio.
---
---@return number ratio # The damping ratio.
function WheelJoint:getSpringDampingRatio() end

---
---Returns the spring frequency.
---
---@return number freq # The frequency in hertz.
function WheelJoint:getSpringFrequency() end

---
---Sets a new maximum motor torque.
---
---@param maxTorque number # The new maximum torque for the joint motor in newton meters.
function WheelJoint:setMaxMotorTorque(maxTorque) end

---
---Starts and stops the joint motor.
---
---@param enable boolean # True turns the motor on and false turns it off.
function WheelJoint:setMotorEnabled(enable) end

---
---Sets a new speed for the motor.
---
---@param speed number # The new speed for the joint motor in radians per second.
function WheelJoint:setMotorSpeed(speed) end

---
---Sets a new damping ratio.
---
---@param ratio number # The new damping ratio.
function WheelJoint:setSpringDampingRatio(ratio) end

---
---Sets a new spring frequency.
---
---@param freq number # The new frequency in hertz.
function WheelJoint:setSpringFrequency(freq) end

---
---A world is an object that contains all bodies and joints.
---
---@class love.World: love.Object
local World = {}

---
---Destroys the world, taking all bodies, joints, fixtures and their shapes with it. 
---
---An error will occur if you attempt to use any of the destroyed objects after calling this function.
---
function World:destroy() end

---
---Returns a table with all bodies.
---
---@return table bodies # A sequence with all bodies.
function World:getBodies() end

---
---Returns the number of bodies in the world.
---
---@return number n # The number of bodies in the world.
function World:getBodyCount() end

---
---Returns functions for the callbacks during the world update.
---
---@return function beginContact # Gets called when two fixtures begin to overlap.
---@return function endContact # Gets called when two fixtures cease to overlap.
---@return function preSolve # Gets called before a collision gets resolved.
---@return function postSolve # Gets called after the collision has been resolved.
function World:getCallbacks() end

---
---Returns the number of contacts in the world.
---
---@return number n # The number of contacts in the world.
function World:getContactCount() end

---
---Returns the function for collision filtering.
---
---@return function contactFilter # The function that handles the contact filtering.
function World:getContactFilter() end

---
---Returns a table with all Contacts.
---
---@return table contacts # A sequence with all Contacts.
function World:getContacts() end

---
---Get the gravity of the world.
---
---@return number x # The x component of gravity.
---@return number y # The y component of gravity.
function World:getGravity() end

---
---Returns the number of joints in the world.
---
---@return number n # The number of joints in the world.
function World:getJointCount() end

---
---Returns a table with all joints.
---
---@return table joints # A sequence with all joints.
function World:getJoints() end

---
---Gets whether the World is destroyed. Destroyed worlds cannot be used.
---
---@return boolean destroyed # Whether the World is destroyed.
function World:isDestroyed() end

---
---Returns if the world is updating its state.
---
---This will return true inside the callbacks from World:setCallbacks.
---
---@return boolean locked # Will be true if the world is in the process of updating its state.
function World:isLocked() end

---
---Gets the sleep behaviour of the world.
---
---@return boolean allow # True if bodies in the world are allowed to sleep, or false if not.
function World:isSleepingAllowed() end

---
---Calls a function for each fixture inside the specified area by searching for any overlapping bounding box (Fixture:getBoundingBox).
---
---@param topLeftX number # The x position of the top-left point.
---@param topLeftY number # The y position of the top-left point.
---@param bottomRightX number # The x position of the bottom-right point.
---@param bottomRightY number # The y position of the bottom-right point.
---@param callback function # This function gets passed one argument, the fixture, and should return a boolean. The search will continue if it is true or stop if it is false.
function World:queryBoundingBox(topLeftX, topLeftY, bottomRightX, bottomRightY, callback) end

---
---Casts a ray and calls a function for each fixtures it intersects. 
---
---@param fixture love.Fixture # The fixture intersecting the ray.
---@param x number # The x position of the intersection point.
---@param y number # The y position of the intersection point.
---@param xn number # The x value of the surface normal vector of the shape edge.
---@param yn number # The y value of the surface normal vector of the shape edge.
---@param fraction number # The position of the intersection on the ray as a number from 0 to 1 (or even higher if the ray length was changed with the return value).
---@return number control # The ray can be controlled with the return value. A positive value sets a new ray length where 1 is the default value. A value of 0 terminates the ray. If the callback function returns -1, the intersection gets ignored as if it didn't happen.
function World:rayCast(fixture, x, y, xn, yn, fraction) end

---
---Sets functions for the collision callbacks during the world update.
---
---Four Lua functions can be given as arguments. The value nil removes a function.
---
---When called, each function will be passed three arguments. The first two arguments are the colliding fixtures and the third argument is the Contact between them. The postSolve callback additionally gets the normal and tangent impulse for each contact point. See notes.
---
---If you are interested to know when exactly each callback is called, consult a Box2d manual
---
---@param beginContact function # Gets called when two fixtures begin to overlap.
---@param endContact function # Gets called when two fixtures cease to overlap. This will also be called outside of a world update, when colliding objects are destroyed.
---@param preSolve function # Gets called before a collision gets resolved.
---@param postSolve function # Gets called after the collision has been resolved.
function World:setCallbacks(beginContact, endContact, preSolve, postSolve) end

---
---Sets a function for collision filtering.
---
---If the group and category filtering doesn't generate a collision decision, this function gets called with the two fixtures as arguments. The function should return a boolean value where true means the fixtures will collide and false means they will pass through each other.
---
---@param filter function # The function handling the contact filtering.
function World:setContactFilter(filter) end

---
---Set the gravity of the world.
---
---@param x number # The x component of gravity.
---@param y number # The y component of gravity.
function World:setGravity(x, y) end

---
---Sets the sleep behaviour of the world.
---
---@param allow boolean # True if bodies in the world are allowed to sleep, or false if not.
function World:setSleepingAllowed(allow) end

---
---Translates the World's origin. Useful in large worlds where floating point precision issues become noticeable at far distances from the origin.
---
---@param x number # The x component of the new origin with respect to the old origin.
---@param y number # The y component of the new origin with respect to the old origin.
function World:translateOrigin(x, y) end

---
---Update the state of the world.
---
---@param dt number # The time (in seconds) to advance the physics simulation.
---@param velocityiterations? number # The maximum number of steps used to determine the new velocities when resolving a collision.
---@param positioniterations? number # The maximum number of steps used to determine the new positions when resolving a collision.
function World:update(dt, velocityiterations, positioniterations) end

---
---The types of a Body. 
---
---@class love.BodyType
---
---Static bodies do not move.
---
---@field static integer
---
---Dynamic bodies collide with all bodies.
---
---@field dynamic integer
---
---Kinematic bodies only collide with dynamic bodies.
---
---@field kinematic integer

---
---Different types of joints.
---
---@class love.JointType
---
---A DistanceJoint.
---
---@field distance integer
---
---A FrictionJoint.
---
---@field friction integer
---
---A GearJoint.
---
---@field gear integer
---
---A MouseJoint.
---
---@field mouse integer
---
---A PrismaticJoint.
---
---@field prismatic integer
---
---A PulleyJoint.
---
---@field pulley integer
---
---A RevoluteJoint.
---
---@field revolute integer
---
---A RopeJoint.
---
---@field rope integer
---
---A WeldJoint.
---
---@field weld integer

---
---The different types of Shapes, as returned by Shape:getType.
---
---@class love.ShapeType
---
---The Shape is a CircleShape.
---
---@field circle integer
---
---The Shape is a PolygonShape.
---
---@field polygon integer
---
---The Shape is a EdgeShape.
---
---@field edge integer
---
---The Shape is a ChainShape.
---
---@field chain integer
