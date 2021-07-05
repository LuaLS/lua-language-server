---@meta

---@class ccs.SkewFrame :ccs.Frame
local SkewFrame={ }
ccs.SkewFrame=SkewFrame




---* 
---@return float
function SkewFrame:getSkewY () end
---* 
---@param skewx float
---@return self
function SkewFrame:setSkewX (skewx) end
---* 
---@param skewy float
---@return self
function SkewFrame:setSkewY (skewy) end
---* 
---@return float
function SkewFrame:getSkewX () end
---* 
---@return self
function SkewFrame:create () end
---* 
---@return ccs.Frame
function SkewFrame:clone () end
---* 
---@return self
function SkewFrame:SkewFrame () end