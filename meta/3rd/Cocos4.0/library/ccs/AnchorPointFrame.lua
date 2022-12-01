---@meta

---@class ccs.AnchorPointFrame :ccs.Frame
local AnchorPointFrame={ }
ccs.AnchorPointFrame=AnchorPointFrame




---* 
---@param point vec2_table
---@return self
function AnchorPointFrame:setAnchorPoint (point) end
---* 
---@return vec2_table
function AnchorPointFrame:getAnchorPoint () end
---* 
---@return self
function AnchorPointFrame:create () end
---* 
---@return ccs.Frame
function AnchorPointFrame:clone () end
---* 
---@return self
function AnchorPointFrame:AnchorPointFrame () end