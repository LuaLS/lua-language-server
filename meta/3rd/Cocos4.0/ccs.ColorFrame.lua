---@meta

---@class ccs.ColorFrame :ccs.Frame
local ColorFrame={ }
ccs.ColorFrame=ColorFrame




---* 
---@return color3b_table
function ColorFrame:getColor () end
---* 
---@param color color3b_table
---@return self
function ColorFrame:setColor (color) end
---* 
---@return self
function ColorFrame:create () end
---* 
---@return ccs.Frame
function ColorFrame:clone () end
---* 
---@return self
function ColorFrame:ColorFrame () end