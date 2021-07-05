---@meta

---@class ccs.ActionScaleFrame :ccs.ActionFrame
local ActionScaleFrame={ }
ccs.ActionScaleFrame=ActionScaleFrame




---* Changes the scale action scaleY.<br>
---* param rotation the scale action scaleY.
---@param scaleY float
---@return self
function ActionScaleFrame:setScaleY (scaleY) end
---* Changes the scale action scaleX.<br>
---* param the scale action scaleX.
---@param scaleX float
---@return self
function ActionScaleFrame:setScaleX (scaleX) end
---* Gets the scale action scaleY.<br>
---* return the scale action scaleY.
---@return float
function ActionScaleFrame:getScaleY () end
---* Gets the scale action scaleX.<br>
---* return the scale action scaleX.
---@return float
function ActionScaleFrame:getScaleX () end
---* Gets the ActionInterval of ActionFrame.<br>
---* param duration   the duration time of ActionFrame<br>
---* return ActionInterval
---@param duration float
---@return cc.ActionInterval
function ActionScaleFrame:getAction (duration) end
---* Default constructor
---@return self
function ActionScaleFrame:ActionScaleFrame () end