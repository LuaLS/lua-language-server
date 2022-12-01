---@meta

---@class cc.PhysicsShapePolygon :cc.PhysicsShape
local PhysicsShapePolygon={ }
cc.PhysicsShapePolygon=PhysicsShapePolygon




---* Get this polygon's points array count.<br>
---* return An integer number.
---@return int
function PhysicsShapePolygon:getPointsCount () end
---* Get a point of this polygon's points array.<br>
---* param i A index of this polygon's points array.<br>
---* return A point value.
---@param i int
---@return vec2_table
function PhysicsShapePolygon:getPoint (i) end
---* Calculate the moment for a polygon.<br>
---* return A float number.
---@return float
function PhysicsShapePolygon:calculateDefaultMoment () end
---* Get this polygon's center position.<br>
---* return A Vec2 object.
---@return vec2_table
function PhysicsShapePolygon:getCenter () end