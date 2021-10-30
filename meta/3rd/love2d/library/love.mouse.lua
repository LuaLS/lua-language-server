---@meta

---
---Provides an interface to the user's mouse.
---
---@class love.mouse
love.mouse = {}

---
---Gets the current Cursor.
---
---@return love.Cursor cursor # The current cursor, or nil if no cursor is set.
function love.mouse.getCursor() end

---
---Returns the current position of the mouse.
---
---@return number x # The position of the mouse along the x-axis.
---@return number y # The position of the mouse along the y-axis.
function love.mouse.getPosition() end

---
---Gets whether relative mode is enabled for the mouse.
---
---If relative mode is enabled, the cursor is hidden and doesn't move when the mouse does, but relative mouse motion events are still generated via love.mousemoved. This lets the mouse move in any direction indefinitely without the cursor getting stuck at the edges of the screen.
---
---The reported position of the mouse is not updated while relative mode is enabled, even when relative mouse motion events are generated.
---
---@return boolean enabled # True if relative mode is enabled, false if it's disabled.
function love.mouse.getRelativeMode() end

---
---Gets a Cursor object representing a system-native hardware cursor.
---
---Hardware cursors are framerate-independent and work the same way as normal operating system cursors. Unlike drawing an image at the mouse's current coordinates, hardware cursors never have visible lag between when the mouse is moved and when the cursor position updates, even at low framerates.
---
---@param ctype love.CursorType # The type of system cursor to get. 
---@return love.Cursor cursor # The Cursor object representing the system cursor type.
function love.mouse.getSystemCursor(ctype) end

---
---Returns the current x-position of the mouse.
---
---@return number x # The position of the mouse along the x-axis.
function love.mouse.getX() end

---
---Returns the current y-position of the mouse.
---
---@return number y # The position of the mouse along the y-axis.
function love.mouse.getY() end

---
---Gets whether cursor functionality is supported.
---
---If it isn't supported, calling love.mouse.newCursor and love.mouse.getSystemCursor will cause an error. Mobile devices do not support cursors.
---
---@return boolean supported # Whether the system has cursor functionality.
function love.mouse.isCursorSupported() end

---
---Checks whether a certain mouse button is down.
---
---This function does not detect mouse wheel scrolling; you must use the love.wheelmoved (or love.mousepressed in version 0.9.2 and older) callback for that. 
---
---@param button number # The index of a button to check. 1 is the primary mouse button, 2 is the secondary mouse button and 3 is the middle button. Further buttons are mouse dependant.
---@return boolean down # True if any specified button is down.
function love.mouse.isDown(button) end

---
---Checks if the mouse is grabbed.
---
---@return boolean grabbed # True if the cursor is grabbed, false if it is not.
function love.mouse.isGrabbed() end

---
---Checks if the cursor is visible.
---
---@return boolean visible # True if the cursor to visible, false if the cursor is hidden.
function love.mouse.isVisible() end

---
---Creates a new hardware Cursor object from an image file or ImageData.
---
---Hardware cursors are framerate-independent and work the same way as normal operating system cursors. Unlike drawing an image at the mouse's current coordinates, hardware cursors never have visible lag between when the mouse is moved and when the cursor position updates, even at low framerates.
---
---The hot spot is the point the operating system uses to determine what was clicked and at what position the mouse cursor is. For example, the normal arrow pointer normally has its hot spot at the top left of the image, but a crosshair cursor might have it in the middle.
---
---@overload fun(filename: string, hotx: number, hoty: number):love.Cursor
---@overload fun(fileData: love.FileData, hotx: number, hoty: number):love.Cursor
---@param imageData love.ImageData # The ImageData to use for the new Cursor.
---@param hotx? number # The x-coordinate in the ImageData of the cursor's hot spot.
---@param hoty? number # The y-coordinate in the ImageData of the cursor's hot spot.
---@return love.Cursor cursor # The new Cursor object.
function love.mouse.newCursor(imageData, hotx, hoty) end

---
---Sets the current mouse cursor.
---
---@overload fun()
---@param cursor love.Cursor # The Cursor object to use as the current mouse cursor.
function love.mouse.setCursor(cursor) end

---
---Grabs the mouse and confines it to the window.
---
---@param grab boolean # True to confine the mouse, false to let it leave the window.
function love.mouse.setGrabbed(grab) end

---
---Sets the current position of the mouse. Non-integer values are floored.
---
---@param x number # The new position of the mouse along the x-axis.
---@param y number # The new position of the mouse along the y-axis.
function love.mouse.setPosition(x, y) end

---
---Sets whether relative mode is enabled for the mouse.
---
---When relative mode is enabled, the cursor is hidden and doesn't move when the mouse does, but relative mouse motion events are still generated via love.mousemoved. This lets the mouse move in any direction indefinitely without the cursor getting stuck at the edges of the screen.
---
---The reported position of the mouse may not be updated while relative mode is enabled, even when relative mouse motion events are generated.
---
---@param enable boolean # True to enable relative mode, false to disable it.
function love.mouse.setRelativeMode(enable) end

---
---Sets the current visibility of the cursor.
---
---@param visible boolean # True to set the cursor to visible, false to hide the cursor.
function love.mouse.setVisible(visible) end

---
---Sets the current X position of the mouse.
---
---Non-integer values are floored.
---
---@param x number # The new position of the mouse along the x-axis.
function love.mouse.setX(x) end

---
---Sets the current Y position of the mouse.
---
---Non-integer values are floored.
---
---@param y number # The new position of the mouse along the y-axis.
function love.mouse.setY(y) end

---
---Represents a hardware cursor.
---
---@class love.Cursor: love.Object
local Cursor = {}

---
---Gets the type of the Cursor.
---
---@return love.CursorType ctype # The type of the Cursor.
function Cursor:getType() end

---
---Types of hardware cursors.
---
---@class love.CursorType
---
---The cursor is using a custom image.
---
---@field image integer
---
---An arrow pointer.
---
---@field arrow integer
---
---An I-beam, normally used when mousing over editable or selectable text.
---
---@field ibeam integer
---
---Wait graphic.
---
---@field wait integer
---
---Small wait cursor with an arrow pointer.
---
---@field waitarrow integer
---
---Crosshair symbol.
---
---@field crosshair integer
---
---Double arrow pointing to the top-left and bottom-right.
---
---@field sizenwse integer
---
---Double arrow pointing to the top-right and bottom-left.
---
---@field sizenesw integer
---
---Double arrow pointing left and right.
---
---@field sizewe integer
---
---Double arrow pointing up and down.
---
---@field sizens integer
---
---Four-pointed arrow pointing up, down, left, and right.
---
---@field sizeall integer
---
---Slashed circle or crossbones.
---
---@field no integer
---
---Hand symbol.
---
---@field hand integer
