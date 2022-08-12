---@meta

---@class ccs.ActionRotationFrame :ccs.ActionFrame
local ActionRotationFrame={ }
ccs.ActionRotationFrame=ActionRotationFrame




---* Changes rotate action rotation.<br>
---* param rotation rotate action rotation.
---@param rotation float
---@return self
function ActionRotationFrame:setRotation (rotation) end
---@overload fun(float:float,ccs.ActionFrame:ccs.ActionFrame):cc.ActionInterval
---@overload fun(float:float):cc.ActionInterval
---@param duration float
---@param srcFrame ccs.ActionFrame
---@return cc.ActionInterval
function ActionRotationFrame:getAction (duration,srcFrame) end
---* Gets the rotate action rotation.<br>
---* return the rotate action rotation.
---@return float
function ActionRotationFrame:getRotation () end
---* Default constructor
---@return self
function ActionRotationFrame:ActionRotationFrame () end