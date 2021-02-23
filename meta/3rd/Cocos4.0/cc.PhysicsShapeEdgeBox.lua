---@meta

---@class cc.PhysicsShapeEdgeBox :cc.PhysicsShapeEdgePolygon
local PhysicsShapeEdgeBox={ }
cc.PhysicsShapeEdgeBox=PhysicsShapeEdgeBox




---* Creates a PhysicsShapeEdgeBox with specified value.<br>
---* param   size Size contains this box's width and height.<br>
---* param   material A PhysicsMaterial object, the default value is PHYSICSSHAPE_MATERIAL_DEFAULT.<br>
---* param   border It's a edge's border width.<br>
---* param   offset A Vec2 object, it is the offset from the body's center of gravity in body local coordinates.<br>
---* return  An autoreleased PhysicsShapeEdgeBox object pointer.
---@param size size_table
---@param material cc.PhysicsMaterial
---@param border float
---@param offset vec2_table
---@return self
function PhysicsShapeEdgeBox:create (size,material,border,offset) end
---* Get this box's position offset.<br>
---* return A Vec2 object.
---@return vec2_table
function PhysicsShapeEdgeBox:getOffset () end