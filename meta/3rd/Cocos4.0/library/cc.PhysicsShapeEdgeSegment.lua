---@meta

---@class cc.PhysicsShapeEdgeSegment :cc.PhysicsShape
local PhysicsShapeEdgeSegment={ }
cc.PhysicsShapeEdgeSegment=PhysicsShapeEdgeSegment




---* Get this edge's end position.<br>
---* return A Vec2 object.
---@return vec2_table
function PhysicsShapeEdgeSegment:getPointB () end
---* Get this edge's begin position.<br>
---* return A Vec2 object.
---@return vec2_table
function PhysicsShapeEdgeSegment:getPointA () end
---* Creates a PhysicsShapeEdgeSegment with specified value.<br>
---* param   a It's the edge's begin position.<br>
---* param   b It's the edge's end position.<br>
---* param   material A PhysicsMaterial object, the default value is PHYSICSSHAPE_MATERIAL_DEFAULT.<br>
---* param   border It's a edge's border width.<br>
---* return  An autoreleased PhysicsShapeEdgeSegment object pointer.
---@param a vec2_table
---@param b vec2_table
---@param material cc.PhysicsMaterial
---@param border float
---@return self
function PhysicsShapeEdgeSegment:create (a,b,material,border) end
---* Get this edge's center position.<br>
---* return A Vec2 object.
---@return vec2_table
function PhysicsShapeEdgeSegment:getCenter () end