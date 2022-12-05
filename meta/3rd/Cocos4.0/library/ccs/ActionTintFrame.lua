---@meta

---@class ccs.ActionTintFrame :ccs.ActionFrame
local ActionTintFrame={ }
ccs.ActionTintFrame=ActionTintFrame




---* Gets the tint action color.<br>
---* return the tint action color.
---@return color3b_table
function ActionTintFrame:getColor () end
---* Gets the ActionInterval of ActionFrame.<br>
---* param duration   the duration time of ActionFrame<br>
---* return ActionInterval
---@param duration float
---@return cc.ActionInterval
function ActionTintFrame:getAction (duration) end
---* Changes the tint action color.<br>
---* param ccolor the tint action color
---@param ccolor color3b_table
---@return self
function ActionTintFrame:setColor (ccolor) end
---* Default constructor
---@return self
function ActionTintFrame:ActionTintFrame () end