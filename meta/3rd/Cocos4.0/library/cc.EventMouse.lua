---@meta

---@class cc.EventMouse :cc.Event
local EventMouse={ }
cc.EventMouse=EventMouse




---*  Returns the previous touch location in screen coordinates.<br>
---* return The previous touch location in screen coordinates.<br>
---* js NA
---@return vec2_table
function EventMouse:getPreviousLocationInView () end
---*  Returns the current touch location in OpenGL coordinates.<br>
---* return The current touch location in OpenGL coordinates.
---@return vec2_table
function EventMouse:getLocation () end
---*  Get mouse button.<br>
---* return The mouse button.<br>
---* js getButton
---@return int
function EventMouse:getMouseButton () end
---*  Returns the previous touch location in OpenGL coordinates.<br>
---* return The previous touch location in OpenGL coordinates.<br>
---* js NA
---@return vec2_table
function EventMouse:getPreviousLocation () end
---*  Returns the delta of 2 current touches locations in screen coordinates.<br>
---* return The delta of 2 current touches locations in screen coordinates.
---@return vec2_table
function EventMouse:getDelta () end
---*  Set mouse scroll data.<br>
---* param scrollX The scroll data of x axis.<br>
---* param scrollY The scroll data of y axis.
---@param scrollX float
---@param scrollY float
---@return self
function EventMouse:setScrollData (scrollX,scrollY) end
---*  Returns the start touch location in screen coordinates.<br>
---* return The start touch location in screen coordinates.<br>
---* js NA
---@return vec2_table
function EventMouse:getStartLocationInView () end
---*  Returns the start touch location in OpenGL coordinates.<br>
---* return The start touch location in OpenGL coordinates.<br>
---* js NA
---@return vec2_table
function EventMouse:getStartLocation () end
---*  Set mouse button.<br>
---* param button a given mouse button.<br>
---* js setButton
---@param button int
---@return self
function EventMouse:setMouseButton (button) end
---*  Returns the current touch location in screen coordinates.<br>
---* return The current touch location in screen coordinates.
---@return vec2_table
function EventMouse:getLocationInView () end
---*  Get mouse scroll data of y axis.<br>
---* return The scroll data of y axis.
---@return float
function EventMouse:getScrollY () end
---*  Get mouse scroll data of x axis.<br>
---* return The scroll data of x axis.
---@return float
function EventMouse:getScrollX () end
---*  Get the cursor position of x axis.<br>
---* return The x coordinate of cursor position.<br>
---* js getLocationX
---@return float
function EventMouse:getCursorX () end
---*  Get the cursor position of y axis.<br>
---* return The y coordinate of cursor position.<br>
---* js getLocationY
---@return float
function EventMouse:getCursorY () end
---*  Set the cursor position.<br>
---* param x The x coordinate of cursor position.<br>
---* param y The y coordinate of cursor position.<br>
---* js setLocation
---@param x float
---@param y float
---@return self
function EventMouse:setCursorPosition (x,y) end
---*  Constructor.<br>
---* param mouseEventCode A given mouse event type.<br>
---* js ctor
---@param mouseEventCode int
---@return self
function EventMouse:EventMouse (mouseEventCode) end