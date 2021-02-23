---@meta

---@class ccs.ScaleFrame :ccs.Frame
local ScaleFrame={ }
ccs.ScaleFrame=ScaleFrame




---* 
---@param scaleY float
---@return self
function ScaleFrame:setScaleY (scaleY) end
---* 
---@param scaleX float
---@return self
function ScaleFrame:setScaleX (scaleX) end
---* 
---@return float
function ScaleFrame:getScaleY () end
---* 
---@return float
function ScaleFrame:getScaleX () end
---* 
---@param scale float
---@return self
function ScaleFrame:setScale (scale) end
---* 
---@return self
function ScaleFrame:create () end
---* 
---@return ccs.Frame
function ScaleFrame:clone () end
---* 
---@return self
function ScaleFrame:ScaleFrame () end