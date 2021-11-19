---@meta

---
---The `lovr.math` module provides math helpers commonly used for 3D applications.
---
---@class lovr.math
lovr.math = {}

---
---Drains the temporary vector pool, invalidating existing temporary vectors.
---
---This is called automatically at the end of each frame.
---
function lovr.math.drain() end

---
---Converts a color from gamma space to linear space.
---
---@overload fun(color: table):number, number, number
---@overload fun(x: number):number
---@param gr number # The red component of the gamma-space color.
---@param gg number # The green component of the gamma-space color.
---@param gb number # The blue component of the gamma-space color.
---@return number lr # The red component of the resulting linear-space color.
---@return number lg # The green component of the resulting linear-space color.
---@return number lb # The blue component of the resulting linear-space color.
function lovr.math.gammaToLinear(gr, gg, gb) end

---
---Get the seed used to initialize the random generator.
---
---@return number seed # The new seed.
function lovr.math.getRandomSeed() end

---
---Converts a color from linear space to gamma space.
---
---@overload fun(color: table):number, number, number
---@overload fun(x: number):number
---@param lr number # The red component of the linear-space color.
---@param lg number # The green component of the linear-space color.
---@param lb number # The blue component of the linear-space color.
---@return number gr # The red component of the resulting gamma-space color.
---@return number gg # The green component of the resulting gamma-space color.
---@return number gb # The blue component of the resulting gamma-space color.
function lovr.math.linearToGamma(lr, lg, lb) end

---
---Creates a temporary 4D matrix.  This function takes the same arguments as `Mat4:set`.
---
function lovr.math.mat4() end

---
---Creates a new `Curve` from a list of control points.
---
---@overload fun(points: table):lovr.Curve
---@overload fun(n: number):lovr.Curve
---@param x number # The x coordinate of the first control point.
---@param y number # The y coordinate of the first control point.
---@param z number # The z coordinate of the first control point.
---@return lovr.Curve curve # The new Curve.
function lovr.math.newCurve(x, y, z) end

---
---Creates a new 4D matrix.  This function takes the same arguments as `Mat4:set`.
---
function lovr.math.newMat4() end

---
---Creates a new quaternion.  This function takes the same arguments as `Quat:set`.
---
function lovr.math.newQuat() end

---
---Creates a new `RandomGenerator`, which can be used to generate random numbers. If you just want some random numbers, you can use `lovr.math.random`. Individual RandomGenerator objects are useful if you need more control over the random sequence used or need a random generator isolated from other instances.
---
---@overload fun(seed: number):lovr.RandomGenerator
---@overload fun(low: number, high: number):lovr.RandomGenerator
---@return lovr.RandomGenerator randomGenerator # The new RandomGenerator.
function lovr.math.newRandomGenerator() end

---
---Creates a new 2D vector.  This function takes the same arguments as `Vec2:set`.
---
function lovr.math.newVec2() end

---
---Creates a new 3D vector.  This function takes the same arguments as `Vec3:set`.
---
function lovr.math.newVec3() end

---
---Creates a new 4D vector.  This function takes the same arguments as `Vec4:set`.
---
function lovr.math.newVec4() end

---
---Returns a 1D, 2D, 3D, or 4D perlin noise value.  The number will be between 0 and 1, and it will always be 0.5 when the inputs are integers.
---
---@overload fun(x: number, y: number):number
---@overload fun(x: number, y: number, z: number):number
---@overload fun(x: number, y: number, z: number, w: number):number
---@param x number # The x coordinate of the input.
---@return number noise # The noise value, between 0 and 1.
function lovr.math.noise(x) end

---
---Creates a temporary quaternion.  This function takes the same arguments as `Quat:set`.
---
function lovr.math.quat() end

---
---Returns a uniformly distributed pseudo-random number.  This function has improved randomness over Lua's `math.random` and also guarantees that the sequence of random numbers will be the same on all platforms (given the same seed).
---
---@overload fun(high: number):number
---@overload fun(low: number, high: number):number
---@return number x # A pseudo-random number.
function lovr.math.random() end

---
---Returns a pseudo-random number from a normal distribution (a bell curve).  You can control the center of the bell curve (the mean value) and the overall width (sigma, or standard deviation).
---
---@param sigma? number # The standard deviation of the distribution.  This can be thought of how "wide" the range of numbers is or how much variability there is.
---@param mu? number # The average value returned.
---@return number x # A normally distributed pseudo-random number.
function lovr.math.randomNormal(sigma, mu) end

---
---Seed the random generator with a new seed.  Each seed will cause `lovr.math.random` and `lovr.math.randomNormal` to produce a unique sequence of random numbers.  This is done once automatically at startup by `lovr.run`.
---
---@param seed number # The new seed.
function lovr.math.setRandomSeed(seed) end

---
---Creates a temporary 2D vector.  This function takes the same arguments as `Vec2:set`.
---
function lovr.math.vec2() end

---
---Creates a temporary 3D vector.  This function takes the same arguments as `Vec3:set`.
---
function lovr.math.vec3() end

---
---Creates a temporary 4D vector.  This function takes the same arguments as `Vec4:set`.
---
function lovr.math.vec4() end

---
---A Curve is an object that represents a Bézier curve in three dimensions.  Curves are defined by an arbitrary number of control points (note that the curve only passes through the first and last control point).
---
---Once a Curve is created with `lovr.math.newCurve`, you can use `Curve:evaluate` to get a point on the curve or `Curve:render` to get a list of all of the points on the curve.  These points can be passed directly to `lovr.graphics.points` or `lovr.graphics.line` to render the curve.
---
---Note that for longer or more complicated curves (like in a drawing application) it can be easier to store the path as several Curve objects.
---
---@class lovr.Curve
local Curve = {}

---
---Inserts a new control point into the Curve at the specified index.
---
---@param x number # The x coordinate of the control point.
---@param y number # The y coordinate of the control point.
---@param z number # The z coordinate of the control point.
---@param index? number # The index to insert the control point at.  If nil, the control point is added to the end of the list of control points.
function Curve:addPoint(x, y, z, index) end

---
---Returns a point on the Curve given a parameter `t` from 0 to 1.  0 will return the first control point, 1 will return the last point, .5 will return a point in the "middle" of the Curve, etc.
---
---@param t number # The parameter to evaluate the Curve at.
---@return number x # The x position of the point.
---@return number y # The y position of the point.
---@return number z # The z position of the point.
function Curve:evaluate(t) end

---
---Returns a control point of the Curve.
---
---@param index number # The index to retrieve.
---@return number x # The x coordinate of the control point.
---@return number y # The y coordinate of the control point.
---@return number z # The z coordinate of the control point.
function Curve:getPoint(index) end

---
---Returns the number of control points in the Curve.
---
---@return number count # The number of control points.
function Curve:getPointCount() end

---
---Returns a direction vector for the Curve given a parameter `t` from 0 to 1.  0 will return the direction at the first control point, 1 will return the direction at the last point, .5 will return the direction at the "middle" of the Curve, etc.
---
---@param t number # Where on the Curve to compute the direction.
---@return number x # The x position of the point.
---@return number y # The y position of the point.
---@return number z # The z position of the point.
function Curve:getTangent(t) end

---
---Removes a control point from the Curve.
---
---@param index number # The index of the control point to remove.
function Curve:removePoint(index) end

---
---Returns a list of points on the Curve.  The number of points can be specified to get a more or less detailed representation, and it is also possible to render a subsection of the Curve.
---
---@param n? number # The number of points to use.
---@param t1? number # How far along the curve to start rendering.
---@param t2? number # How far along the curve to stop rendering.
---@return table t # A (flat) table of 3D points along the curve.
function Curve:render(n, t1, t2) end

---
---Changes the position of a control point on the Curve.
---
---@param index number # The index to modify.
---@param x number # The new x coordinate.
---@param y number # The new y coordinate.
---@param z number # The new z coordinate.
function Curve:setPoint(index, x, y, z) end

---
---Returns a new Curve created by slicing the Curve at the specified start and end points.
---
---@param t1 number # The starting point to slice at.
---@param t2 number # The ending point to slice at.
---@return lovr.Curve curve # A new Curve.
function Curve:slice(t1, t2) end

---
---A `mat4` is a math type that holds 16 values in a 4x4 grid.
---
---@class lovr.Mat4
local Mat4 = {}

---
---Sets a projection matrix using raw projection angles and clipping planes.
---
---This can be used for asymmetric or oblique projections.
---
---@param left number # The left half-angle of the projection, in radians.
---@param right number # The right half-angle of the projection, in radians.
---@param up number # The top half-angle of the projection, in radians.
---@param down number # The bottom half-angle of the projection, in radians.
---@param near number # The near plane of the projection.
---@param far number # The far plane of the projection.
---@return lovr.Mat4 m # The original matrix.
function Mat4:fov(left, right, up, down, near, far) end

---
---Resets the matrix to the identity, effectively setting its translation to zero, its scale to 1, and clearing any rotation.
---
---@return lovr.Mat4 m # The original matrix.
function Mat4:identity() end

---
---Inverts the matrix, causing it to represent the opposite of its old transform.
---
---@return lovr.Mat4 m # The original matrix.
function Mat4:invert() end

---
---Sets a view transform matrix that moves and orients camera to look at a target point.
---
---This is useful for changing camera position and orientation. The resulting Mat4 matrix can be passed to `lovr.graphics.transform()` directly (without inverting) before rendering the scene.
---
---The lookAt() function produces same result as target() after matrix inversion.
---
---@param from lovr.Vec3 # The position of the viewer.
---@param to lovr.Vec3 # The position of the target.
---@param up? lovr.Vec3 # The up vector of the viewer.
---@return lovr.Mat4 m # The original matrix.
function Mat4:lookAt(from, to, up) end

---
---Multiplies this matrix by another value.  Multiplying by a matrix combines their two transforms together.  Multiplying by a vector applies the transformation from the matrix to the vector and returns the vector.
---
---@overload fun(v3: lovr.Vec3):lovr.Vec3
---@overload fun(v4: lovr.Vec4):lovr.Vec4
---@param n lovr.Mat4 # The matrix.
---@return lovr.Mat4 m # The original matrix, containing the result.
function Mat4:mul(n) end

---
---Sets this matrix to represent an orthographic projection, useful for 2D/isometric rendering.
---
---This can be used with `lovr.graphics.setProjection`, or it can be sent to a `Shader` for use in GLSL.
---
---@param left number # The left edge of the projection.
---@param right number # The right edge of the projection.
---@param top number # The top edge of the projection.
---@param bottom number # The bottom edge of the projection.
---@param near number # The position of the near clipping plane.
---@param far number # The position of the far clipping plane.
---@return lovr.Mat4 m # The original matrix.
function Mat4:orthographic(left, right, top, bottom, near, far) end

---
---Sets this matrix to represent a perspective projection.
---
---This can be used with `lovr.graphics.setProjection`, or it can be sent to a `Shader` for use in GLSL.
---
---@param near number # The near plane.
---@param far number # The far plane.
---@param fov number # The vertical field of view (in radians).
---@param aspect number # The horizontal aspect ratio of the projection (width / height).
---@return lovr.Mat4 m # The original matrix.
function Mat4:perspective(near, far, fov, aspect) end

---
---Rotates the matrix using a quaternion or an angle/axis rotation.
---
---@overload fun(angle: number, ax: number, ay: number, az: number):lovr.Mat4
---@param q lovr.Quat # The rotation to apply to the matrix.
---@return lovr.Mat4 m # The original matrix.
function Mat4:rotate(q) end

---
---Scales the matrix.
---
---@overload fun(sx: number, sy: number, sz: number):lovr.Mat4
---@param scale lovr.Vec3 # The 3D scale to apply.
---@return lovr.Mat4 m # The original matrix.
function Mat4:scale(scale) end

---
---Sets the components of the matrix from separate position, rotation, and scale arguments or an existing matrix.
---
---@overload fun(n: lovr.mat4):lovr.Mat4
---@overload fun(position: lovr.Vec3, scale: lovr.Vec3, rotation: lovr.Quat):lovr.Mat4
---@overload fun(position: lovr.Vec3, rotation: lovr.Quat):lovr.Mat4
---@overload fun(...):lovr.Mat4
---@overload fun(d: number):lovr.Mat4
---@return lovr.Mat4 m # The input matrix.
function Mat4:set() end

---
---Sets a model transform matrix that moves to `from` and orients model towards `to` point.
---
---This is used when rendered model should always point torwards a point of interest. The resulting Mat4 object can be used as model pose.
---
---The target() function produces same result as lookAt() after matrix inversion.
---
---@param from lovr.Vec3 # The position of the viewer.
---@param to lovr.Vec3 # The position of the target.
---@param up? lovr.Vec3 # The up vector of the viewer.
---@return lovr.Mat4 m # The original matrix.
function Mat4:target(from, to, up) end

---
---Translates the matrix.
---
---@overload fun(x: number, y: number, z: number):lovr.Mat4
---@param v lovr.Vec3 # The translation vector.
---@return lovr.Mat4 m # The original matrix.
function Mat4:translate(v) end

---
---Transposes the matrix, mirroring its values along the diagonal.
---
---@return lovr.Mat4 m # The original matrix.
function Mat4:transpose() end

---
---Returns the components of matrix, either as 10 separated numbers representing the position, scale, and rotation, or as 16 raw numbers representing the individual components of the matrix in column-major order.
---
---@param raw boolean # Whether to return the 16 raw components.
function Mat4:unpack(raw) end

---
---A `quat` is a math type that represents a 3D rotation, stored as four numbers.
---
---@class lovr.Quat
local Quat = {}

---
---Conjugates the input quaternion in place, returning the input.  If the quaternion is normalized, this is the same as inverting it.  It negates the (x, y, z) components of the quaternion.
---
---@return lovr.Quat q # The original quaternion.
function Quat:conjugate() end

---
---Creates a new temporary vec3 facing the forward direction, rotates it by this quaternion, and returns the vector.
---
---@return lovr.Vec3 v # The direction vector.
function Quat:direction() end

---
---Returns the length of the quaternion.
---
---@return number length # The length of the quaternion.
function Quat:length() end

---
---Multiplies this quaternion by another value.  If the value is a quaternion, the rotations in the two quaternions are applied sequentially and the result is stored in the first quaternion.  If the value is a vector, then the input vector is rotated by the quaternion and returned.
---
---@overload fun(v3: lovr.vec3):lovr.vec3
---@param r lovr.quat # A quaternion to combine with the original.
---@return lovr.quat q # The original quaternion.
function Quat:mul(r) end

---
---Adjusts the values in the quaternion so that its length becomes 1.
---
---@return lovr.Quat q # The original quaternion.
function Quat:normalize() end

---
---Sets the components of the quaternion.  There are lots of different ways to specify the new components, the summary is:
---
---- Four numbers can be used to specify an angle/axis rotation, similar to other LÖVR functions.
---- Four numbers plus the fifth `raw` flag can be used to set the raw values of the quaternion.
---- An existing quaternion can be passed in to copy its values.
---- A single direction vector can be specified to turn its direction (relative to the default
---  forward direction of "negative z") into a rotation.
---- Two direction vectors can be specified to set the quaternion equal to the rotation between the
---  two vectors.
---- A matrix can be passed in to extract the rotation of the matrix into a quaternion.
---
---@overload fun(r: lovr.quat):lovr.quat
---@overload fun(v: lovr.vec3):lovr.quat
---@overload fun(v: lovr.vec3, u: lovr.vec3):lovr.quat
---@overload fun(m: lovr.mat4):lovr.quat
---@overload fun():lovr.quat
---@param angle? any # The angle to use for the rotation, in radians.
---@param ax? number # The x component of the axis of rotation.
---@param ay? number # The y component of the axis of rotation.
---@param az? number # The z component of the axis of rotation.
---@param raw? boolean # Whether the components should be interpreted as raw `(x, y, z, w)` components.
---@return lovr.quat q # The original quaternion.
function Quat:set(angle, ax, ay, az, raw) end

---
---Performs a spherical linear interpolation between this quaternion and another one, which can be used for smoothly animating between two rotations.
---
---The amount of interpolation is controlled by a parameter `t`.  A `t` value of zero leaves the original quaternion unchanged, whereas a `t` of one sets the original quaternion exactly equal to the target.  A value between `0` and `1` returns a rotation between the two based on the value.
---
---@param r lovr.Quat # The quaternion to slerp towards.
---@param t number # The lerping parameter.
---@return lovr.Quat q # The original quaternion, containing the new lerped values.
function Quat:slerp(r, t) end

---
---Returns the components of the quaternion as numbers, either in an angle/axis representation or as raw quaternion values.
---
---@param raw? boolean # Whether the values should be returned as raw values instead of angle/axis.
---@return number a # The angle in radians, or the x value.
---@return number b # The x component of the rotation axis or the y value.
---@return number c # The y component of the rotation axis or the z value.
---@return number d # The z component of the rotation axis or the w value.
function Quat:unpack(raw) end

---
---A RandomGenerator is a standalone object that can be used to independently generate pseudo-random numbers. If you just need basic randomness, you can use `lovr.math.random` without needing to create a random generator.
---
---@class lovr.RandomGenerator
local RandomGenerator = {}

---
---Returns the seed used to initialize the RandomGenerator.
---
---@return number low # The lower 32 bits of the seed.
---@return number high # The upper 32 bits of the seed.
function RandomGenerator:getSeed() end

---
---Returns the current state of the RandomGenerator.  This can be used with `RandomGenerator:setState` to reliably restore a previous state of the generator.
---
---@return string state # The serialized state.
function RandomGenerator:getState() end

---
---Returns the next uniformly distributed pseudo-random number from the RandomGenerator's sequence.
---
---@overload fun(high: number):number
---@overload fun(low: number, high: number):number
---@return number x # A pseudo-random number.
function RandomGenerator:random() end

---
---Returns a pseudo-random number from a normal distribution (a bell curve).  You can control the center of the bell curve (the mean value) and the overall width (sigma, or standard deviation).
---
---@param sigma? number # The standard deviation of the distribution.  This can be thought of how "wide" the range of numbers is or how much variability there is.
---@param mu? number # The average value returned.
---@return number x # A normally distributed pseudo-random number.
function RandomGenerator:randomNormal(sigma, mu) end

---
---Seed the RandomGenerator with a new seed.  Each seed will cause the RandomGenerator to produce a unique sequence of random numbers.
---
---@overload fun(low: number, high: number)
---@param seed number # The random seed.
function RandomGenerator:setSeed(seed) end

---
---Sets the state of the RandomGenerator, as previously obtained using `RandomGenerator:getState`. This can be used to reliably restore a previous state of the generator.
---
---@param state string # The serialized state.
function RandomGenerator:setState(state) end

---
---A vector object that holds two numbers.
---
---@class lovr.Vec2
local Vec2 = {}

---
---Adds a vector or a number to the vector.
---
---@overload fun(x: number, y: number):lovr.Vec2
---@param u lovr.Vec2 # The other vector.
---@return lovr.Vec2 v # The original vector.
function Vec2:add(u) end

---
---Returns the distance to another vector.
---
---@overload fun(x: number, y: number):number
---@param u lovr.Vec2 # The vector to measure the distance to.
---@return number distance # The distance to `u`.
function Vec2:distance(u) end

---
---Divides the vector by a vector or a number.
---
---@overload fun(x: number, y: number):lovr.Vec2
---@param u lovr.Vec2 # The other vector to divide the components by.
---@return lovr.Vec2 v # The original vector.
function Vec2:div(u) end

---
---Returns the dot product between this vector and another one.
---
---@overload fun(x: number, y: number):number
---@param u lovr.Vec2 # The vector to compute the dot product with.
---@return number dot # The dot product between `v` and `u`.
function Vec2:dot(u) end

---
---Returns the length of the vector.
---
---@return number length # The length of the vector.
function Vec2:length() end

---
---Performs a linear interpolation between this vector and another one, which can be used to smoothly animate between two vectors, based on a parameter value.  A parameter value of `0` will leave the vector unchanged, a parameter value of `1` will set the vector to be equal to the input vector, and a value of `.5` will set the components to be halfway between the two vectors.
---
---@overload fun(x: number, y: number):lovr.Vec2
---@return lovr.Vec2 v # The original vector, containing the new lerped values.
function Vec2:lerp() end

---
---Multiplies the vector by a vector or a number.
---
---@overload fun(x: number, y: number):lovr.Vec2
---@param u lovr.Vec2 # The other vector to multiply the components by.
---@return lovr.Vec2 v # The original vector.
function Vec2:mul(u) end

---
---Adjusts the values in the vector so that its direction stays the same but its length becomes 1.
---
---@return lovr.Vec2 v # The original vector.
function Vec2:normalize() end

---
---Sets the components of the vector, either from numbers or an existing vector.
---
---@overload fun(u: lovr.Vec2):lovr.Vec2
---@param x? number # The new x value of the vector.
---@param y? number # The new y value of the vector.
---@return lovr.Vec2 v # The input vector.
function Vec2:set(x, y) end

---
---Subtracts a vector or a number from the vector.
---
---@overload fun(x: number, y: number):lovr.Vec2
---@param u lovr.Vec2 # The other vector.
---@return lovr.Vec2 v # The original vector.
function Vec2:sub(u) end

---
---Returns the 2 components of the vector as numbers.
---
---@return number x # The x value.
---@return number y # The y value.
function Vec2:unpack() end

---
---A vector object that holds three numbers.
---
---@class lovr.Vec3
local Vec3 = {}

---
---Adds a vector or a number to the vector.
---
---@overload fun(x: number, y: number, z: number):lovr.Vec3
---@param u lovr.Vec3 # The other vector.
---@return lovr.Vec3 v # The original vector.
function Vec3:add(u) end

---
---Sets this vector to be equal to the cross product between this vector and another one.  The new `v` will be perpendicular to both the old `v` and `u`.
---
---@overload fun(x: number, y: number, z: number):lovr.Vec3
---@param u lovr.Vec3 # The vector to compute the cross product with.
---@return lovr.Vec3 v # The original vector, with the cross product as its values.
function Vec3:cross(u) end

---
---Returns the distance to another vector.
---
---@overload fun(x: number, y: number, z: number):number
---@param u lovr.Vec3 # The vector to measure the distance to.
---@return number distance # The distance to `u`.
function Vec3:distance(u) end

---
---Divides the vector by a vector or a number.
---
---@overload fun(x: number, y: number, z: number):lovr.Vec3
---@param u lovr.Vec3 # The other vector to divide the components by.
---@return lovr.Vec3 v # The original vector.
function Vec3:div(u) end

---
---Returns the dot product between this vector and another one.
---
---@overload fun(x: number, y: number, z: number):number
---@param u lovr.Vec3 # The vector to compute the dot product with.
---@return number dot # The dot product between `v` and `u`.
function Vec3:dot(u) end

---
---Returns the length of the vector.
---
---@return number length # The length of the vector.
function Vec3:length() end

---
---Performs a linear interpolation between this vector and another one, which can be used to smoothly animate between two vectors, based on a parameter value.  A parameter value of `0` will leave the vector unchanged, a parameter value of `1` will set the vector to be equal to the input vector, and a value of `.5` will set the components to be halfway between the two vectors.
---
---@overload fun(x: number, y: number, z: number, t: number):lovr.Vec3
---@param u lovr.Vec3 # The vector to lerp towards.
---@param t number # The lerping parameter.
---@return lovr.Vec3 v # The original vector, containing the new lerped values.
function Vec3:lerp(u, t) end

---
---Multiplies the vector by a vector or a number.
---
---@overload fun(x: number, y: number, z: number):lovr.Vec3
---@param u lovr.Vec3 # The other vector to multiply the components by.
---@return lovr.Vec3 v # The original vector.
function Vec3:mul(u) end

---
---Adjusts the values in the vector so that its direction stays the same but its length becomes 1.
---
---@return lovr.Vec3 v # The original vector.
function Vec3:normalize() end

---
---Sets the components of the vector, either from numbers or an existing vector.
---
---@overload fun(u: lovr.Vec3):lovr.Vec3
---@overload fun(m: lovr.Mat4):lovr.Vec3
---@param x? number # The new x value of the vector.
---@param y? number # The new y value of the vector.
---@param z? number # The new z value of the vector.
---@return lovr.Vec3 v # The input vector.
function Vec3:set(x, y, z) end

---
---Subtracts a vector or a number from the vector.
---
---@overload fun(x: number, y: number, z: number):lovr.Vec3
---@param u lovr.Vec3 # The other vector.
---@return lovr.Vec3 v # The original vector.
function Vec3:sub(u) end

---
---Returns the 3 components of the vector as numbers.
---
---@return number x # The x value.
---@return number y # The y value.
---@return number z # The z value.
function Vec3:unpack() end

---
---A vector object that holds four numbers.
---
---@class lovr.Vec4
local Vec4 = {}

---
---Adds a vector or a number to the vector.
---
---@overload fun(x: number, y: number, z: number, w: number):lovr.Vec4
---@param u lovr.Vec4 # The other vector.
---@return lovr.Vec4 v # The original vector.
function Vec4:add(u) end

---
---Returns the distance to another vector.
---
---@overload fun(x: number, y: number, z: number, w: number):number
---@param u lovr.Vec4 # The vector to measure the distance to.
---@return number distance # The distance to `u`.
function Vec4:distance(u) end

---
---Divides the vector by a vector or a number.
---
---@overload fun(x: number, y: number, z: number, w: number):lovr.Vec4
---@param u lovr.Vec4 # The other vector to divide the components by.
---@return lovr.Vec4 v # The original vector.
function Vec4:div(u) end

---
---Returns the dot product between this vector and another one.
---
---@overload fun(x: number, y: number, z: number, w: number):number
---@param u lovr.Vec4 # The vector to compute the dot product with.
---@return number dot # The dot product between `v` and `u`.
function Vec4:dot(u) end

---
---Returns the length of the vector.
---
---@return number length # The length of the vector.
function Vec4:length() end

---
---Performs a linear interpolation between this vector and another one, which can be used to smoothly animate between two vectors, based on a parameter value.  A parameter value of `0` will leave the vector unchanged, a parameter value of `1` will set the vector to be equal to the input vector, and a value of `.5` will set the components to be halfway between the two vectors.
---
---@overload fun(x: number, y: number, z: number, w: number, t: number):lovr.Vec4
---@param u lovr.Vec4 # The vector to lerp towards.
---@param t number # The lerping parameter.
---@return lovr.Vec4 v # The original vector, containing the new lerped values.
function Vec4:lerp(u, t) end

---
---Multiplies the vector by a vector or a number.
---
---@overload fun(x: number, y: number, z: number, w: number):lovr.Vec4
---@param u lovr.Vec4 # The other vector to multiply the components by.
---@return lovr.Vec4 v # The original vector.
function Vec4:mul(u) end

---
---Adjusts the values in the vector so that its direction stays the same but its length becomes 1.
---
---@return lovr.Vec4 v # The original vector.
function Vec4:normalize() end

---
---Sets the components of the vector, either from numbers or an existing vector.
---
---@overload fun(u: lovr.Vec4):lovr.Vec4
---@param x? number # The new x value of the vector.
---@param y? number # The new y value of the vector.
---@param z? number # The new z value of the vector.
---@param w? number # The new w value of the vector.
---@return lovr.Vec4 v # The input vector.
function Vec4:set(x, y, z, w) end

---
---Subtracts a vector or a number from the vector.
---
---@overload fun(x: number, y: number, z: number, w: number):lovr.Vec4
---@param u lovr.Vec4 # The other vector.
---@return lovr.Vec4 v # The original vector.
function Vec4:sub(u) end

---
---Returns the 4 components of the vector as numbers.
---
---@return number x # The x value.
---@return number y # The y value.
---@return number z # The z value.
function Vec4:unpack() end

---
---LÖVR has math objects for vectors, matrices, and quaternions, collectively called "vector objects".  Vectors are useful because they can represent a multidimensional quantity (like a 3D position) using just a single value.
---
---@class lovr.Vectors
local Vectors = {}
