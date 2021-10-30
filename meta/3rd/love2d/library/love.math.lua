---@meta

---
---Provides system-independent mathematical functions.
---
---@class love.math
love.math = {}

---
---Converts a color from 0..255 to 0..1 range.
---
---@param rb number # Red color component in 0..255 range.
---@param gb number # Green color component in 0..255 range.
---@param bb number # Blue color component in 0..255 range.
---@param ab? number # Alpha color component in 0..255 range.
---@return number r # Red color component in 0..1 range.
---@return number g # Green color component in 0..1 range.
---@return number b # Blue color component in 0..1 range.
---@return number a # Alpha color component in 0..1 range or nil if alpha is not specified.
function love.math.colorFromBytes(rb, gb, bb, ab) end

---
---Converts a color from 0..1 to 0..255 range.
---
---@param r number # Red color component.
---@param g number # Green color component.
---@param b number # Blue color component.
---@param a? number # Alpha color component.
---@return number rb # Red color component in 0..255 range.
---@return number gb # Green color component in 0..255 range.
---@return number bb # Blue color component in 0..255 range.
---@return number ab # Alpha color component in 0..255 range or nil if alpha is not specified.
function love.math.colorToBytes(r, g, b, a) end

---
---Compresses a string or data using a specific compression algorithm.
---
---@overload fun(data: love.Data, format: love.CompressedDataFormat, level: number):love.CompressedData
---@param rawstring string # The raw (un-compressed) string to compress.
---@param format? love.CompressedDataFormat # The format to use when compressing the string.
---@param level? number # The level of compression to use, between 0 and 9. -1 indicates the default level. The meaning of this argument depends on the compression format being used.
---@return love.CompressedData compressedData # A new Data object containing the compressed version of the string.
function love.math.compress(rawstring, format, level) end

---
---Decompresses a CompressedData or previously compressed string or Data object.
---
---@overload fun(compressedstring: string, format: love.CompressedDataFormat):string
---@overload fun(data: love.Data, format: love.CompressedDataFormat):string
---@param compressedData love.CompressedData # The compressed data to decompress.
---@return string rawstring # A string containing the raw decompressed data.
function love.math.decompress(compressedData) end

---
---Converts a color from gamma-space (sRGB) to linear-space (RGB). This is useful when doing gamma-correct rendering and you need to do math in linear RGB in the few cases where LÖVE doesn't handle conversions automatically.
---
---Read more about gamma-correct rendering here, here, and here.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---@overload fun(color: table):number, number, number
---@overload fun(c: number):number
---@param r number # The red channel of the sRGB color to convert.
---@param g number # The green channel of the sRGB color to convert.
---@param b number # The blue channel of the sRGB color to convert.
---@return number lr # The red channel of the converted color in linear RGB space.
---@return number lg # The green channel of the converted color in linear RGB space.
---@return number lb # The blue channel of the converted color in linear RGB space.
function love.math.gammaToLinear(r, g, b) end

---
---Gets the seed of the random number generator.
---
---The seed is split into two numbers due to Lua's use of doubles for all number values - doubles can't accurately represent integer  values above 2^53, but the seed can be an integer value up to 2^64.
---
---@return number low # Integer number representing the lower 32 bits of the random number generator's 64 bit seed value.
---@return number high # Integer number representing the higher 32 bits of the random number generator's 64 bit seed value.
function love.math.getRandomSeed() end

---
---Gets the current state of the random number generator. This returns an opaque implementation-dependent string which is only useful for later use with love.math.setRandomState or RandomGenerator:setState.
---
---This is different from love.math.getRandomSeed in that getRandomState gets the random number generator's current state, whereas getRandomSeed gets the previously set seed number.
---
---@return string state # The current state of the random number generator, represented as a string.
function love.math.getRandomState() end

---
---Checks whether a polygon is convex.
---
---PolygonShapes in love.physics, some forms of Meshes, and polygons drawn with love.graphics.polygon must be simple convex polygons.
---
---@overload fun(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number):boolean
---@param vertices table # The vertices of the polygon as a table in the form of {x1, y1, x2, y2, x3, y3, ...}.
---@return boolean convex # Whether the given polygon is convex.
function love.math.isConvex(vertices) end

---
---Converts a color from linear-space (RGB) to gamma-space (sRGB). This is useful when storing linear RGB color values in an image, because the linear RGB color space has less precision than sRGB for dark colors, which can result in noticeable color banding when drawing.
---
---In general, colors chosen based on what they look like on-screen are already in gamma-space and should not be double-converted. Colors calculated using math are often in the linear RGB space.
---
---Read more about gamma-correct rendering here, here, and here.
---
---In versions prior to 11.0, color component values were within the range of 0 to 255 instead of 0 to 1.
---
---@overload fun(color: table):number, number, number
---@overload fun(lc: number):number
---@param lr number # The red channel of the linear RGB color to convert.
---@param lg number # The green channel of the linear RGB color to convert.
---@param lb number # The blue channel of the linear RGB color to convert.
---@return number cr # The red channel of the converted color in gamma sRGB space.
---@return number cg # The green channel of the converted color in gamma sRGB space.
---@return number cb # The blue channel of the converted color in gamma sRGB space.
function love.math.linearToGamma(lr, lg, lb) end

---
---Creates a new BezierCurve object.
---
---The number of vertices in the control polygon determines the degree of the curve, e.g. three vertices define a quadratic (degree 2) Bézier curve, four vertices define a cubic (degree 3) Bézier curve, etc.
---
---@overload fun(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number):love.BezierCurve
---@param vertices table # The vertices of the control polygon as a table in the form of {x1, y1, x2, y2, x3, y3, ...}.
---@return love.BezierCurve curve # A Bézier curve object.
function love.math.newBezierCurve(vertices) end

---
---Creates a new RandomGenerator object which is completely independent of other RandomGenerator objects and random functions.
---
---@overload fun(seed: number):love.RandomGenerator
---@overload fun(low: number, high: number):love.RandomGenerator
---@return love.RandomGenerator rng # The new Random Number Generator object.
function love.math.newRandomGenerator() end

---
---Creates a new Transform object.
---
---@overload fun(x: number, y: number, angle: number, sx: number, sy: number, ox: number, oy: number, kx: number, ky: number):love.Transform
---@return love.Transform transform # The new Transform object.
function love.math.newTransform() end

---
---Generates a Simplex or Perlin noise value in 1-4 dimensions. The return value will always be the same, given the same arguments.
---
---Simplex noise is closely related to Perlin noise. It is widely used for procedural content generation.
---
---There are many webpages which discuss Perlin and Simplex noise in detail.
---
---@overload fun(x: number, y: number):number
---@overload fun(x: number, y: number, z: number):number
---@overload fun(x: number, y: number, z: number, w: number):number
---@param x number # The number used to generate the noise value.
---@return number value # The noise value in the range of 1.
function love.math.noise(x) end

---
---Generates a pseudo-random number in a platform independent manner. The default love.run seeds this function at startup, so you generally don't need to seed it yourself.
---
---@overload fun(max: number):number
---@overload fun(min: number, max: number):number
---@return number number # The pseudo-random number.
function love.math.random() end

---
---Get a normally distributed pseudo random number.
---
---@param stddev? number # Standard deviation of the distribution.
---@param mean? number # The mean of the distribution.
---@return number number # Normally distributed random number with variance (stddev)² and the specified mean.
function love.math.randomNormal(stddev, mean) end

---
---Sets the seed of the random number generator using the specified integer number. This is called internally at startup, so you generally don't need to call it yourself.
---
---@overload fun(low: number, high: number)
---@param seed number # The integer number with which you want to seed the randomization. Must be within the range of 2^53 - 1.
function love.math.setRandomSeed(seed) end

---
---Sets the current state of the random number generator. The value used as an argument for this function is an opaque implementation-dependent string and should only originate from a previous call to love.math.getRandomState.
---
---This is different from love.math.setRandomSeed in that setRandomState directly sets the random number generator's current implementation-dependent state, whereas setRandomSeed gives it a new seed value.
---
---@param state string # The new state of the random number generator, represented as a string. This should originate from a previous call to love.math.getRandomState.
function love.math.setRandomState(state) end

---
---Decomposes a simple convex or concave polygon into triangles.
---
---@overload fun(x1: number, y1: number, x2: number, y2: number, x3: number, y3: number):table
---@param polygon table # Polygon to triangulate. Must not intersect itself.
---@return table triangles # List of triangles the polygon is composed of, in the form of {{x1, y1, x2, y2, x3, y3},  {x1, y1, x2, y2, x3, y3}, ...}.
function love.math.triangulate(polygon) end

---
---A Bézier curve object that can evaluate and render Bézier curves of arbitrary degree.
---
---For more information on Bézier curves check this great article on Wikipedia.
---
---@class love.BezierCurve: love.Object
local BezierCurve = {}

---
---Evaluate Bézier curve at parameter t. The parameter must be between 0 and 1 (inclusive).
---
---This function can be used to move objects along paths or tween parameters. However it should not be used to render the curve, see BezierCurve:render for that purpose.
---
---@param t number # Where to evaluate the curve.
---@return number x # x coordinate of the curve at parameter t.
---@return number y # y coordinate of the curve at parameter t.
function BezierCurve:evaluate(t) end

---
---Get coordinates of the i-th control point. Indices start with 1.
---
---@param i number # Index of the control point.
---@return number x # Position of the control point along the x axis.
---@return number y # Position of the control point along the y axis.
function BezierCurve:getControlPoint(i) end

---
---Get the number of control points in the Bézier curve.
---
---@return number count # The number of control points.
function BezierCurve:getControlPointCount() end

---
---Get degree of the Bézier curve. The degree is equal to number-of-control-points - 1.
---
---@return number degree # Degree of the Bézier curve.
function BezierCurve:getDegree() end

---
---Get the derivative of the Bézier curve.
---
---This function can be used to rotate sprites moving along a curve in the direction of the movement and compute the direction perpendicular to the curve at some parameter t.
---
---@return love.BezierCurve derivative # The derivative curve.
function BezierCurve:getDerivative() end

---
---Gets a BezierCurve that corresponds to the specified segment of this BezierCurve.
---
---@param startpoint number # The starting point along the curve. Must be between 0 and 1.
---@param endpoint number # The end of the segment. Must be between 0 and 1.
---@return love.BezierCurve curve # A BezierCurve that corresponds to the specified segment.
function BezierCurve:getSegment(startpoint, endpoint) end

---
---Insert control point as the new i-th control point. Existing control points from i onwards are pushed back by 1. Indices start with 1. Negative indices wrap around: -1 is the last control point, -2 the one before the last, etc.
---
---@param x number # Position of the control point along the x axis.
---@param y number # Position of the control point along the y axis.
---@param i? number # Index of the control point.
function BezierCurve:insertControlPoint(x, y, i) end

---
---Removes the specified control point.
---
---@param index number # The index of the control point to remove.
function BezierCurve:removeControlPoint(index) end

---
---Get a list of coordinates to be used with love.graphics.line.
---
---This function samples the Bézier curve using recursive subdivision. You can control the recursion depth using the depth parameter.
---
---If you are just interested to know the position on the curve given a parameter, use BezierCurve:evaluate.
---
---@param depth? number # Number of recursive subdivision steps.
---@return table coordinates # List of x,y-coordinate pairs of points on the curve.
function BezierCurve:render(depth) end

---
---Get a list of coordinates on a specific part of the curve, to be used with love.graphics.line.
---
---This function samples the Bézier curve using recursive subdivision. You can control the recursion depth using the depth parameter.
---
---If you are just need to know the position on the curve given a parameter, use BezierCurve:evaluate.
---
---@param startpoint number # The starting point along the curve. Must be between 0 and 1.
---@param endpoint number # The end of the segment to render. Must be between 0 and 1.
---@param depth? number # Number of recursive subdivision steps.
---@return table coordinates # List of x,y-coordinate pairs of points on the specified part of the curve.
function BezierCurve:renderSegment(startpoint, endpoint, depth) end

---
---Rotate the Bézier curve by an angle.
---
---@param angle number # Rotation angle in radians.
---@param ox? number # X coordinate of the rotation center.
---@param oy? number # Y coordinate of the rotation center.
function BezierCurve:rotate(angle, ox, oy) end

---
---Scale the Bézier curve by a factor.
---
---@param s number # Scale factor.
---@param ox? number # X coordinate of the scaling center.
---@param oy? number # Y coordinate of the scaling center.
function BezierCurve:scale(s, ox, oy) end

---
---Set coordinates of the i-th control point. Indices start with 1.
---
---@param i number # Index of the control point.
---@param x number # Position of the control point along the x axis.
---@param y number # Position of the control point along the y axis.
function BezierCurve:setControlPoint(i, x, y) end

---
---Move the Bézier curve by an offset.
---
---@param dx number # Offset along the x axis.
---@param dy number # Offset along the y axis.
function BezierCurve:translate(dx, dy) end

---
---A random number generation object which has its own random state.
---
---@class love.RandomGenerator: love.Object
local RandomGenerator = {}

---
---Gets the seed of the random number generator object.
---
---The seed is split into two numbers due to Lua's use of doubles for all number values - doubles can't accurately represent integer  values above 2^53, but the seed value is an integer number in the range of 2^64 - 1.
---
---@return number low # Integer number representing the lower 32 bits of the RandomGenerator's 64 bit seed value.
---@return number high # Integer number representing the higher 32 bits of the RandomGenerator's 64 bit seed value.
function RandomGenerator:getSeed() end

---
---Gets the current state of the random number generator. This returns an opaque string which is only useful for later use with RandomGenerator:setState in the same major version of LÖVE.
---
---This is different from RandomGenerator:getSeed in that getState gets the RandomGenerator's current state, whereas getSeed gets the previously set seed number.
---
---@return string state # The current state of the RandomGenerator object, represented as a string.
function RandomGenerator:getState() end

---
---Generates a pseudo-random number in a platform independent manner.
---
---@overload fun(max: number):number
---@overload fun(min: number, max: number):number
---@return number number # The pseudo-random number.
function RandomGenerator:random() end

---
---Get a normally distributed pseudo random number.
---
---@param stddev? number # Standard deviation of the distribution.
---@param mean? number # The mean of the distribution.
---@return number number # Normally distributed random number with variance (stddev)² and the specified mean.
function RandomGenerator:randomNormal(stddev, mean) end

---
---Sets the seed of the random number generator using the specified integer number.
---
---@overload fun(low: number, high: number)
---@param seed number # The integer number with which you want to seed the randomization. Must be within the range of 2^53.
function RandomGenerator:setSeed(seed) end

---
---Sets the current state of the random number generator. The value used as an argument for this function is an opaque string and should only originate from a previous call to RandomGenerator:getState in the same major version of LÖVE.
---
---This is different from RandomGenerator:setSeed in that setState directly sets the RandomGenerator's current implementation-dependent state, whereas setSeed gives it a new seed value.
---
---@param state string # The new state of the RandomGenerator object, represented as a string. This should originate from a previous call to RandomGenerator:getState.
function RandomGenerator:setState(state) end

---
---Object containing a coordinate system transformation.
---
---The love.graphics module has several functions and function variants which accept Transform objects.
---
---@class love.Transform: love.Object
local Transform = {}

---
---Applies the given other Transform object to this one.
---
---This effectively multiplies this Transform's internal transformation matrix with the other Transform's (i.e. self * other), and stores the result in this object.
---
---@param other love.Transform # The other Transform object to apply to this Transform.
---@return love.Transform transform # The Transform object the method was called on. Allows easily chaining Transform methods.
function Transform:apply(other) end

---
---Creates a new copy of this Transform.
---
---@return love.Transform clone # The copy of this Transform.
function Transform:clone() end

---
---Gets the internal 4x4 transformation matrix stored by this Transform. The matrix is returned in row-major order.
---
---@return number e1_1 # The first column of the first row of the matrix.
---@return number e1_2 # The second column of the first row of the matrix.
---@return number e4_4 # The fourth column of the fourth row of the matrix.
function Transform:getMatrix() end

---
---Creates a new Transform containing the inverse of this Transform.
---
---@return love.Transform inverse # A new Transform object representing the inverse of this Transform's matrix.
function Transform:inverse() end

---
---Applies the reverse of the Transform object's transformation to the given 2D position.
---
---This effectively converts the given position from the local coordinate space of the Transform into global coordinates.
---
---One use of this method can be to convert a screen-space mouse position into global world coordinates, if the given Transform has transformations applied that are used for a camera system in-game.
---
---@param localX number # The x component of the position with the transform applied.
---@param localY number # The y component of the position with the transform applied.
---@return number globalX # The x component of the position in global coordinates.
---@return number globalY # The y component of the position in global coordinates.
function Transform:inverseTransformPoint(localX, localY) end

---
---Checks whether the Transform is an affine transformation.
---
---@return boolean affine # true if the transform object is an affine transformation, false otherwise.
function Transform:isAffine2DTransform() end

---
---Resets the Transform to an identity state. All previously applied transformations are erased.
---
---@return love.Transform transform # The Transform object the method was called on. Allows easily chaining Transform methods.
function Transform:reset() end

---
---Applies a rotation to the Transform's coordinate system. This method does not reset any previously applied transformations.
---
---@param angle number # The relative angle in radians to rotate this Transform by.
---@return love.Transform transform # The Transform object the method was called on. Allows easily chaining Transform methods.
function Transform:rotate(angle) end

---
---Scales the Transform's coordinate system. This method does not reset any previously applied transformations.
---
---@param sx number # The relative scale factor along the x-axis.
---@param sy? number # The relative scale factor along the y-axis.
---@return love.Transform transform # The Transform object the method was called on. Allows easily chaining Transform methods.
function Transform:scale(sx, sy) end

---
---Directly sets the Transform's internal 4x4 transformation matrix.
---
---@overload fun(layout: love.MatrixLayout, e1_1: number, e1_2: number, ..., e4_4: number):love.Transform
---@overload fun(layout: love.MatrixLayout, matrix: table):love.Transform
---@overload fun(layout: love.MatrixLayout, matrix: table):love.Transform
---@param e1_1 number # The first column of the first row of the matrix.
---@param e1_2 number # The second column of the first row of the matrix.
---@param e4_4 number # The fourth column of the fourth row of the matrix.
---@return love.Transform transform # The Transform object the method was called on. Allows easily chaining Transform methods.
function Transform:setMatrix(e1_1, e1_2, e4_4) end

---
---Resets the Transform to the specified transformation parameters.
---
---@param x number # The position of the Transform on the x-axis.
---@param y number # The position of the Transform on the y-axis.
---@param angle? number # The orientation of the Transform in radians.
---@param sx? number # Scale factor on the x-axis.
---@param sy? number # Scale factor on the y-axis.
---@param ox? number # Origin offset on the x-axis.
---@param oy? number # Origin offset on the y-axis.
---@param kx? number # Shearing / skew factor on the x-axis.
---@param ky? number # Shearing / skew factor on the y-axis.
---@return love.Transform transform # The Transform object the method was called on. Allows easily chaining Transform methods.
function Transform:setTransformation(x, y, angle, sx, sy, ox, oy, kx, ky) end

---
---Applies a shear factor (skew) to the Transform's coordinate system. This method does not reset any previously applied transformations.
---
---@param kx number # The shear factor along the x-axis.
---@param ky number # The shear factor along the y-axis.
---@return love.Transform transform # The Transform object the method was called on. Allows easily chaining Transform methods.
function Transform:shear(kx, ky) end

---
---Applies the Transform object's transformation to the given 2D position.
---
---This effectively converts the given position from global coordinates into the local coordinate space of the Transform.
---
---@param globalX number # The x component of the position in global coordinates.
---@param globalY number # The y component of the position in global coordinates.
---@return number localX # The x component of the position with the transform applied.
---@return number localY # The y component of the position with the transform applied.
function Transform:transformPoint(globalX, globalY) end

---
---Applies a translation to the Transform's coordinate system. This method does not reset any previously applied transformations.
---
---@param dx number # The relative translation along the x-axis.
---@param dy number # The relative translation along the y-axis.
---@return love.Transform transform # The Transform object the method was called on. Allows easily chaining Transform methods.
function Transform:translate(dx, dy) end

---
---The layout of matrix elements (row-major or column-major).
---
---@class love.MatrixLayout
---
---The matrix is row-major:
---
---@field row integer
---
---The matrix is column-major:
---
---@field column integer
