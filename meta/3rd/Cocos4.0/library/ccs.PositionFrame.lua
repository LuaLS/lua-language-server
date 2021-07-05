---@meta

---@class ccs.PositionFrame :ccs.Frame
local PositionFrame={ }
ccs.PositionFrame=PositionFrame




---* 
---@return float
function PositionFrame:getX () end
---* 
---@return float
function PositionFrame:getY () end
---* 
---@param position vec2_table
---@return self
function PositionFrame:setPosition (position) end
---* 
---@param x float
---@return self
function PositionFrame:setX (x) end
---* 
---@param y float
---@return self
function PositionFrame:setY (y) end
---* 
---@return vec2_table
function PositionFrame:getPosition () end
---* 
---@return self
function PositionFrame:create () end
---* 
---@return ccs.Frame
function PositionFrame:clone () end
---* 
---@return self
function PositionFrame:PositionFrame () end