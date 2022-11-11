---Vector math API documentation
---Functions for mathematical operations on vectors, matrices and quaternions.
---
---
--- * The vector types (vmath.vector3 and vmath.vector4) supports addition and subtraction
---  with vectors of the same type. Vectors can be negated and multiplied (scaled) or divided by numbers.
---
--- * The quaternion type (vmath.quat) supports multiplication with other quaternions.
---
--- * The matrix type (vmath.matrix4) can be multiplied with numbers, other matrices
---  and vmath.vector4 values.
---
--- * All types performs equality comparison by each component value.
---
---The following components are available for the various types:
---
---  vector3
---x, y and z. Example: v.y
---  vector4
---x, y, z, and w. Example: v.w
---  quaternion
---x, y, z, and w. Example: q.w
---  matrix4
---m00 to m33 where the first number is the row (starting from 0) and the second
---number is the column. Columns can be accessed with c0 to c3, returning a vector4.
---Example: m.m21 which is equal to m.c1.z
---  vector
---indexed by number 1 to the vector length. Example: v[3]

---@class vmath
vmath = {}
---Calculates the conjugate of a quaternion. The result is a
---quaternion with the same magnitudes but with the sign of
---the imaginary (vector) parts changed:
---q* = [w, -v]
---@param q1 quaternion # quaternion of which to calculate the conjugate
---@return quaternion # the conjugate
function vmath.conj(q1) end

---Given two linearly independent vectors P and Q, the cross product,
---P ? Q, is a vector that is perpendicular to both P and Q and
---therefore normal to the plane containing them.
---If the two vectors have the same direction (or have the exact
---opposite direction from one another, i.e. are not linearly independent)
---or if either one has zero length, then their cross product is zero.
---@param v1 vector3 # first vector
---@param v2 vector3 # second vector
---@return vector3 # a new vector representing the cross product
function vmath.cross(v1, v2) end

---The returned value is a scalar defined as:
---P ? Q = |P| |Q| cos ?
---where ? is the angle between the vectors P and Q.
---
---
--- * If the dot product is positive then the angle between the vectors is below 90 degrees.
---
--- * If the dot product is zero the vectors are perpendicular (at right-angles to each other).
---
--- * If the dot product is negative then the angle between the vectors is more than 90 degrees.
---@param v1 vector3|vector4 # first vector
---@param v2 vector3|vector4 # second vector
---@return number # dot product
function vmath.dot(v1, v2) end

---The resulting matrix is the inverse of the supplied matrix.
--- For ortho-normal matrices, e.g. regular object transformation,
---use vmath.ortho_inv() instead.
---The specialized inverse for ortho-normalized matrices is much faster
---than the general inverse.
---@param m1 matrix4 # matrix to invert
---@return matrix4 # inverse of the supplied matrix
function vmath.inv(m1) end

---Returns the length of the supplied vector or quaternion.
---If you are comparing the lengths of vectors or quaternions, you should compare
---the length squared instead as it is slightly more efficient to calculate
---(it eliminates a square root calculation).
---@param v vector3|vector4|quat # value of which to calculate the length
---@return number # length
function vmath.length(v) end

---Returns the squared length of the supplied vector or quaternion.
---@param v vector3|vector4|quat # value of which to calculate the squared length
---@return number # squared length
function vmath.length_sqr(v) end

---Linearly interpolate between two vectors. The function
---treats the vectors as positions and interpolates between
---the positions in a straight line. Lerp is useful to describe
---transitions from one place to another over time.
--- The function does not clamp t between 0 and 1.
---@param t number # interpolation parameter, 0-1
---@param v1 vector3|vector4 # vector to lerp from
---@param v2 vector3|vector4 # vector to lerp to
---@return vector3|vector4 # the lerped vector
function vmath.lerp(t, v1, v2) end

---Linearly interpolate between two quaternions. Linear
---interpolation of rotations are only useful for small
---rotations. For interpolations of arbitrary rotations,
---vmath.slerp <> yields much better results.
--- The function does not clamp t between 0 and 1.
---@param t number # interpolation parameter, 0-1
---@param q1 quaternion # quaternion to lerp from
---@param q2 quaternion # quaternion to lerp to
---@return quaternion # the lerped quaternion
function vmath.lerp(t, q1, q2) end

---Linearly interpolate between two values. Lerp is useful
---to describe transitions from one value to another over time.
--- The function does not clamp t between 0 and 1.
---@param t number # interpolation parameter, 0-1
---@param n1 number # number to lerp from
---@param n2 number # number to lerp to
---@return number # the lerped number
function vmath.lerp(t, n1, n2) end

---The resulting identity matrix describes a transform with
---no translation or rotation.
---@return matrix4 # identity matrix
function vmath.matrix4() end

---Creates a new matrix with all components set to the
---corresponding values from the supplied matrix. I.e.
---the function creates a copy of the given matrix.
---@param m1 matrix4 # existing matrix
---@return matrix4 # matrix which is a copy of the specified matrix
function vmath.matrix4(m1) end

---The resulting matrix describes a rotation around the axis by the specified angle.
---@param v vector3 # axis
---@param angle number # angle in radians
---@return matrix4 # matrix represented by axis and angle
function vmath.matrix4_axis_angle(v, angle) end

---The resulting matrix describes the same rotation as the quaternion, but does not have any translation (also like the quaternion).
---@param q quaternion # quaternion to create matrix from
---@return matrix4 # matrix represented by quaternion
function vmath.matrix4_from_quat(q) end

---Constructs a frustum matrix from the given values. The left, right,
---top and bottom coordinates of the view cone are expressed as distances
---from the center of the near clipping plane. The near and far coordinates
---are expressed as distances from the tip of the view frustum cone.
---@param left number # coordinate for left clipping plane
---@param right number # coordinate for right clipping plane
---@param bottom number # coordinate for bottom clipping plane
---@param top number # coordinate for top clipping plane
---@param near number # coordinate for near clipping plane
---@param far number # coordinate for far clipping plane
---@return matrix4 # matrix representing the frustum
function vmath.matrix4_frustum(left, right, bottom, top, near, far) end

---The resulting matrix is created from the supplied look-at parameters.
---This is useful for constructing a view matrix for a camera or
---rendering in general.
---@param eye vector3 # eye position
---@param look_at vector3 # look-at position
---@param up vector3 # up vector
---@return matrix4 # look-at matrix
function vmath.matrix4_look_at(eye, look_at, up) end

---Creates an orthographic projection matrix.
---This is useful to construct a projection matrix for a camera or rendering in general.
---@param left number # coordinate for left clipping plane
---@param right number # coordinate for right clipping plane
---@param bottom number # coordinate for bottom clipping plane
---@param top number # coordinate for top clipping plane
---@param near number # coordinate for near clipping plane
---@param far number # coordinate for far clipping plane
---@return matrix4 # orthographic projection matrix
function vmath.matrix4_orthographic(left, right, bottom, top, near, far) end

---Creates a perspective projection matrix.
---This is useful to construct a projection matrix for a camera or rendering in general.
---@param fov number # angle of the full vertical field of view in radians
---@param aspect number # aspect ratio
---@param near number # coordinate for near clipping plane
---@param far number # coordinate for far clipping plane
---@return matrix4 # perspective projection matrix
function vmath.matrix4_perspective(fov, aspect, near, far) end

---The resulting matrix describes a rotation around the x-axis
---by the specified angle.
---@param angle number # angle in radians around x-axis
---@return matrix4 # matrix from rotation around x-axis
function vmath.matrix4_rotation_x(angle) end

---The resulting matrix describes a rotation around the y-axis
---by the specified angle.
---@param angle number # angle in radians around y-axis
---@return matrix4 # matrix from rotation around y-axis
function vmath.matrix4_rotation_y(angle) end

---The resulting matrix describes a rotation around the z-axis
---by the specified angle.
---@param angle number # angle in radians around z-axis
---@return matrix4 # matrix from rotation around z-axis
function vmath.matrix4_rotation_z(angle) end

---The resulting matrix describes a translation of a point
---in euclidean space.
---@param position vector3|vector4 # position vector to create matrix from
---@return matrix4 # matrix from the supplied position vector
function vmath.matrix4_translation(position) end

---Performs an element wise multiplication between two vectors of the same type
---The returned value is a vector defined as (e.g. for a vector3):
---v = vmath.mul_per_elem(a, b) = vmath.vector3(a.x * b.x, a.y * b.y, a.z * b.z)
---@param v1 vector3|vector4 # first vector
---@param v2 vector3|vector4 # second vector
---@return vector3|vector4 # multiplied vector
function vmath.mul_per_elem(v1, v2) end

---Normalizes a vector, i.e. returns a new vector with the same
---direction as the input vector, but with length 1.
--- The length of the vector must be above 0, otherwise a
---division-by-zero will occur.
---@param v1 vector3|vector4|quat # vector to normalize
---@return vector3|vector4|quat # new normalized vector
function vmath.normalize(v1) end

---The resulting matrix is the inverse of the supplied matrix.
---The supplied matrix has to be an ortho-normal matrix, e.g.
---describe a regular object transformation.
--- For matrices that are not ortho-normal
---use the general inverse vmath.inv() instead.
---@param m1 matrix4 # ortho-normalized matrix to invert
---@return matrix4 # inverse of the supplied matrix
function vmath.ortho_inv(m1) end

---Calculates the extent the projection of the first vector onto the second.
---The returned value is a scalar p defined as:
---p = |P| cos ? / |Q|
---where ? is the angle between the vectors P and Q.
---@param v1 vector3 # vector to be projected on the second
---@param v2 vector3 # vector onto which the first will be projected, must not have zero length
---@return number # the projected extent of the first vector onto the second
function vmath.project(v1, v2) end

---Creates a new identity quaternion. The identity
---quaternion is equal to:
---vmath.quat(0, 0, 0, 1)
---@return quaternion # new identity quaternion
function vmath.quat() end

---Creates a new quaternion with all components set to the
---corresponding values from the supplied quaternion. I.e.
---This function creates a copy of the given quaternion.
---@param q1 quaternion # existing quaternion
---@return quaternion # new quaternion
function vmath.quat(q1) end

---Creates a new quaternion with the components set
---according to the supplied parameter values.
---@param x number # x coordinate
---@param y number # y coordinate
---@param z number # z coordinate
---@param w number # w coordinate
---@return quaternion # new quaternion
function vmath.quat(x, y, z, w) end

---The resulting quaternion describes a rotation of angle
---radians around the axis described by the unit vector v.
---@param v vector3 # axis
---@param angle number # angle
---@return quaternion # quaternion representing the axis-angle rotation
function vmath.quat_axis_angle(v, angle) end

---The resulting quaternion describes the rotation from the
---identity quaternion (no rotation) to the coordinate system
---as described by the given x, y and z base unit vectors.
---@param x vector3 # x base vector
---@param y vector3 # y base vector
---@param z vector3 # z base vector
---@return quaternion # quaternion representing the rotation of the specified base vectors
function vmath.quat_basis(x, y, z) end

---The resulting quaternion describes the rotation that,
---if applied to the first vector, would rotate the first
---vector to the second. The two vectors must be unit
---vectors (of length 1).
--- The result is undefined if the two vectors point in opposite directions
---@param v1 vector3 # first unit vector, before rotation
---@param v2 vector3 # second unit vector, after rotation
---@return quaternion # quaternion representing the rotation from first to second vector
function vmath.quat_from_to(v1, v2) end

---The resulting quaternion describes a rotation of angle
---radians around the x-axis.
---@param angle number # angle in radians around x-axis
---@return quaternion # quaternion representing the rotation around the x-axis
function vmath.quat_rotation_x(angle) end

---The resulting quaternion describes a rotation of angle
---radians around the y-axis.
---@param angle number # angle in radians around y-axis
---@return quaternion # quaternion representing the rotation around the y-axis
function vmath.quat_rotation_y(angle) end

---The resulting quaternion describes a rotation of angle
---radians around the z-axis.
---@param angle number # angle in radians around z-axis
---@return quaternion # quaternion representing the rotation around the z-axis
function vmath.quat_rotation_z(angle) end

---Returns a new vector from the supplied vector that is
---rotated by the rotation described by the supplied
---quaternion.
---@param q quaternion # quaternion
---@param v1 vector3 # vector to rotate
---@return vector3 # the rotated vector
function vmath.rotate(q, v1) end

---Spherically interpolates between two vectors. The difference to
---lerp is that slerp treats the vectors as directions instead of
---positions in space.
---The direction of the returned vector is interpolated by the angle
---and the magnitude is interpolated between the magnitudes of the
---from and to vectors.
--- Slerp is computationally more expensive than lerp.
---The function does not clamp t between 0 and 1.
---@param t number # interpolation parameter, 0-1
---@param v1 vector3|vector4 # vector to slerp from
---@param v2 vector3|vector4 # vector to slerp to
---@return vector3|vector4 # the slerped vector
function vmath.slerp(t, v1, v2) end

---Slerp travels the torque-minimal path maintaining constant
---velocity, which means it travels along the straightest path along
---the rounded surface of a sphere. Slerp is useful for interpolation
---of rotations.
---Slerp travels the torque-minimal path, which means it travels
---along the straightest path the rounded surface of a sphere.
--- The function does not clamp t between 0 and 1.
---@param t number # interpolation parameter, 0-1
---@param q1 quaternion # quaternion to slerp from
---@param q2 quaternion # quaternion to slerp to
---@return quaternion # the slerped quaternion
function vmath.slerp(t, q1, q2) end

---Creates a vector of arbitrary size. The vector is initialized
---with numeric values from a table.
--- The table values are converted to floating point
---values. If a value cannot be converted, a 0 is stored in that
---value position in the vector.
---@param t table # table of numbers
---@return vector # new vector
function vmath.vector(t) end

---Creates a new zero vector with all components set to 0.
---@return vector3 # new zero vector
function vmath.vector3() end

---Creates a new vector with all components set to the
---supplied scalar value.
---@param n number # scalar value to splat
---@return vector3 # new vector
function vmath.vector3(n) end

---Creates a new vector with all components set to the
---corresponding values from the supplied vector. I.e.
---This function creates a copy of the given vector.
---@param v1 vector3 # existing vector
---@return vector3 # new vector
function vmath.vector3(v1) end

---Creates a new vector with the components set to the
---supplied values.
---@param x number # x coordinate
---@param y number # y coordinate
---@param z number # z coordinate
---@return vector3 # new vector
function vmath.vector3(x, y, z) end

---Creates a new zero vector with all components set to 0.
---@return vector4 # new zero vector
function vmath.vector4() end

---Creates a new vector with all components set to the
---supplied scalar value.
---@param n number # scalar value to splat
---@return vector4 # new vector
function vmath.vector4(n) end

---Creates a new vector with all components set to the
---corresponding values from the supplied vector. I.e.
---This function creates a copy of the given vector.
---@param v1 vector4 # existing vector
---@return vector4 # new vector
function vmath.vector4(v1) end

---Creates a new vector with the components set to the
---supplied values.
---@param x number # x coordinate
---@param y number # y coordinate
---@param z number # z coordinate
---@param w number # w coordinate
---@return vector4 # new vector
function vmath.vector4(x, y, z, w) end




return vmath