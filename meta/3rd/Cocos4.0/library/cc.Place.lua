---@meta

---@class cc.Place :cc.ActionInstant
local Place={ }
cc.Place=Place




---*  Initializes a Place action with a position 
---@param pos vec2_table
---@return boolean
function Place:initWithPosition (pos) end
---*  Creates a Place action with a position.<br>
---* param pos  A certain position.<br>
---* return  An autoreleased Place object.
---@param pos vec2_table
---@return self
function Place:create (pos) end
---* 
---@return self
function Place:clone () end
---* param time In seconds.
---@param time float
---@return self
function Place:update (time) end
---* 
---@return self
function Place:reverse () end
---* 
---@return self
function Place:Place () end