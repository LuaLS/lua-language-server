---@meta

---@class ccs.AlphaFrame :ccs.Frame
local AlphaFrame={ }
ccs.AlphaFrame=AlphaFrame




---* 
---@return unsigned_char
function AlphaFrame:getAlpha () end
---* 
---@param alpha unsigned_char
---@return self
function AlphaFrame:setAlpha (alpha) end
---* 
---@return self
function AlphaFrame:create () end
---* 
---@return ccs.Frame
function AlphaFrame:clone () end
---* 
---@return self
function AlphaFrame:AlphaFrame () end