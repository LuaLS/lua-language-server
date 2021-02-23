---@meta

---@class ccs.RotationFrame :ccs.Frame
local RotationFrame={ }
ccs.RotationFrame=RotationFrame




---* 
---@param rotation float
---@return self
function RotationFrame:setRotation (rotation) end
---* 
---@return float
function RotationFrame:getRotation () end
---* 
---@return self
function RotationFrame:create () end
---* 
---@return ccs.Frame
function RotationFrame:clone () end
---* 
---@return self
function RotationFrame:RotationFrame () end