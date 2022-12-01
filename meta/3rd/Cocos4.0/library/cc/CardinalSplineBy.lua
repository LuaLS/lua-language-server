---@meta

---@class cc.CardinalSplineBy :cc.CardinalSplineTo
local CardinalSplineBy={ }
cc.CardinalSplineBy=CardinalSplineBy




---* 
---@param target cc.Node
---@return self
function CardinalSplineBy:startWithTarget (target) end
---* 
---@return self
function CardinalSplineBy:clone () end
---* 
---@param newPos vec2_table
---@return self
function CardinalSplineBy:updatePosition (newPos) end
---* 
---@return self
function CardinalSplineBy:reverse () end
---* 
---@return self
function CardinalSplineBy:CardinalSplineBy () end