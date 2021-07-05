---@meta

---@class ccs.BlendFuncFrame :ccs.Frame
local BlendFuncFrame={ }
ccs.BlendFuncFrame=BlendFuncFrame




---* 
---@return cc.BlendFunc
function BlendFuncFrame:getBlendFunc () end
---* 
---@param blendFunc cc.BlendFunc
---@return self
function BlendFuncFrame:setBlendFunc (blendFunc) end
---* 
---@return self
function BlendFuncFrame:create () end
---* 
---@return ccs.Frame
function BlendFuncFrame:clone () end
---* 
---@return self
function BlendFuncFrame:BlendFuncFrame () end