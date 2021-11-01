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
