---@meta

---@class ccs.ActionFadeFrame :ccs.ActionFrame
local ActionFadeFrame={ }
ccs.ActionFadeFrame=ActionFadeFrame




---* Gets the fade action opacity.<br>
---* return the fade action opacity.
---@return int
function ActionFadeFrame:getOpacity () end
---* Gets the ActionInterval of ActionFrame.<br>
---* param duration   the duration time of ActionFrame<br>
---* return ActionInterval
---@param duration float
---@return cc.ActionInterval
function ActionFadeFrame:getAction (duration) end
---* Changes the fade action opacity.<br>
---* param opacity the fade action opacity
---@param opacity int
---@return self
function ActionFadeFrame:setOpacity (opacity) end
---* Default constructor
---@return self
function ActionFadeFrame:ActionFadeFrame () end