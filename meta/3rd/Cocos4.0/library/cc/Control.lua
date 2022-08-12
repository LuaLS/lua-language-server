---@meta

---@class cc.Control :cc.Layer
local Control={ }
cc.Control=Control




---*  Tells whether the control is enabled. 
---@param bEnabled boolean
---@return self
function Control:setEnabled (bEnabled) end
---* 
---@return int
function Control:getState () end
---* Sends action messages for the given control events.<br>
---* param controlEvents A bitmask whose set flags specify the control events for<br>
---* which action messages are sent. See "CCControlEvent" for bitmask constants.
---@param controlEvents int
---@return self
function Control:sendActionsForControlEvents (controlEvents) end
---*  A Boolean value that determines the control selected state. 
---@param bSelected boolean
---@return self
function Control:setSelected (bSelected) end
---* 
---@return boolean
function Control:isEnabled () end
---* Updates the control layout using its current internal state.
---@return self
function Control:needsLayout () end
---* 
---@return boolean
function Control:hasVisibleParents () end
---* 
---@return boolean
function Control:isSelected () end
---* Returns a boolean value that indicates whether a touch is inside the bounds<br>
---* of the receiver. The given touch must be relative to the world.<br>
---* param touch A Touch object that represents a touch.<br>
---* return Whether a touch is inside the receiver's rect.
---@param touch cc.Touch
---@return boolean
function Control:isTouchInside (touch) end
---*  A Boolean value that determines whether the control is highlighted. 
---@param bHighlighted boolean
---@return self
function Control:setHighlighted (bHighlighted) end
---* Returns a point corresponding to the touch location converted into the<br>
---* control space coordinates.<br>
---* param touch A Touch object that represents a touch.
---@param touch cc.Touch
---@return vec2_table
function Control:getTouchLocation (touch) end
---* 
---@return boolean
function Control:isHighlighted () end
---*  Creates a Control object 
---@return self
function Control:create () end
---* 
---@param touch cc.Touch
---@param event cc.Event
---@return self
function Control:onTouchMoved (touch,event) end
---* 
---@return boolean
function Control:isOpacityModifyRGB () end
---* 
---@param bOpacityModifyRGB boolean
---@return self
function Control:setOpacityModifyRGB (bOpacityModifyRGB) end
---* 
---@param touch cc.Touch
---@param event cc.Event
---@return self
function Control:onTouchCancelled (touch,event) end
---* 
---@return boolean
function Control:init () end
---* 
---@param touch cc.Touch
---@param event cc.Event
---@return self
function Control:onTouchEnded (touch,event) end
---* 
---@param touch cc.Touch
---@param event cc.Event
---@return boolean
function Control:onTouchBegan (touch,event) end
---* js ctor
---@return self
function Control:Control () end