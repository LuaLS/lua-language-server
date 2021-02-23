---@meta

---@class cc.PhysicsShapeCircle :cc.PhysicsShape
local PhysicsShapeCircle={ }
cc.PhysicsShapeCircle=PhysicsShapeCircle




---* Get the circle's radius.<br>
---* return A float number.
---@return float
function PhysicsShapeCircle:getRadius () end
---* Creates a PhysicsShapeCircle with specified value.<br>
---* param   radius A float number, it is the circle's radius.<br>
---* param   material A PhysicsMaterial object, the default value is PHYSICSSHAPE_MATERIAL_DEFAULT.<br>
---* param   offset A Vec2 object, it is the offset from the body's center of gravity in body local coordinates.<br>
---* return  An autoreleased PhysicsShapeCircle object pointer.
---@param radius float
---@param material cc.PhysicsMaterial
---@param offset vec2_table
---@return self
function PhysicsShapeCircle:create (radius,material,offset) end
---* Calculate the area of a circle with specified radius.<br>
---* param radius A float number<br>
---* return A float number
---@param radius float
---@return float
function PhysicsShapeCircle:calculateArea (radius) end
---* Calculate the moment of a circle with specified value.<br>
---* param mass A float number<br>
---* param radius A float number<br>
---* param offset A Vec2 object, it is the offset from the body's center of gravity in body local coordinates.<br>
---* return A float number
---@param mass float
---@param radius float
---@param offset vec2_table
---@return float
function PhysicsShapeCircle:calculateMoment (mass,radius,offset) end
---* Get this circle's position offset.<br>
---* return A Vec2 object.
---@return vec2_table
function PhysicsShapeCircle:getOffset () end
---* Calculate the moment for a circle.<br>
---* return A float number.
---@return float
function PhysicsShapeCircle:calculateDefaultMoment () end