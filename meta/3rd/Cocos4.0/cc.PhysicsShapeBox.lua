---@meta

---@class cc.PhysicsShapeBox :cc.PhysicsShapePolygon
local PhysicsShapeBox={ }
cc.PhysicsShapeBox=PhysicsShapeBox




---* Get this box's width and height.<br>
---* return An Size object.
---@return size_table
function PhysicsShapeBox:getSize () end
---* Creates a PhysicsShapeBox with specified value.<br>
---* param   size Size contains this box's width and height.<br>
---* param   material A PhysicsMaterial object, the default value is PHYSICSSHAPE_MATERIAL_DEFAULT.<br>
---* param   offset A Vec2 object, it is the offset from the body's center of gravity in body local coordinates.<br>
---* return  An autoreleased PhysicsShapeBox object pointer.
---@param size size_table
---@param material cc.PhysicsMaterial
---@param offset vec2_table
---@param radius float
---@return self
function PhysicsShapeBox:create (size,material,offset,radius) end
---* Get this box's position offset.<br>
---* return A Vec2 object.
---@return vec2_table
function PhysicsShapeBox:getOffset () end