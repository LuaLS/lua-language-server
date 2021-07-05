---@meta

---@class ccs.VisibleFrame :ccs.Frame
local VisibleFrame={ }
ccs.VisibleFrame=VisibleFrame




---* 
---@return boolean
function VisibleFrame:isVisible () end
---* 
---@param visible boolean
---@return self
function VisibleFrame:setVisible (visible) end
---* 
---@return self
function VisibleFrame:create () end
---* 
---@return ccs.Frame
function VisibleFrame:clone () end
---* 
---@return self
function VisibleFrame:VisibleFrame () end