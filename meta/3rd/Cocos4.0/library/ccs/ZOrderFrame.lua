---@meta

---@class ccs.ZOrderFrame :ccs.Frame
local ZOrderFrame={ }
ccs.ZOrderFrame=ZOrderFrame




---* 
---@return int
function ZOrderFrame:getZOrder () end
---* 
---@param zorder int
---@return self
function ZOrderFrame:setZOrder (zorder) end
---* 
---@return self
function ZOrderFrame:create () end
---* 
---@return ccs.Frame
function ZOrderFrame:clone () end
---* 
---@return self
function ZOrderFrame:ZOrderFrame () end