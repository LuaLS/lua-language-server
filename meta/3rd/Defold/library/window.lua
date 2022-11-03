---Window API documentation
---Functions and constants to access the window, window event listeners
---and screen dimming.
---@class window
window = {}
---dimming mode off
window.DIMMING_OFF = nil
---dimming mode on
window.DIMMING_ON = nil
---dimming mode unknown
window.DIMMING_UNKNOWN = nil
---deiconified window event
window.WINDOW_EVENT_DEICONIFIED = nil
---focus gained window event
window.WINDOW_EVENT_FOCUS_GAINED = nil
---focus lost window event
window.WINDOW_EVENT_FOCUS_LOST = nil
---iconify window event
window.WINDOW_EVENT_ICONFIED = nil
---resized window event
window.WINDOW_EVENT_RESIZED = nil
--- Returns the current dimming mode set on a mobile device.
---The dimming mode specifies whether or not a mobile device should dim the screen after a period without user interaction.
---On platforms that does not support dimming, window.DIMMING_UNKNOWN is always returned.
---@return constant # The mode for screen dimming
function window.get_dim_mode() end

---This returns the current lock state of the mouse cursor
---@return boolean # The lock state
function window.get_mouse_lock() end

---This returns the current window size (width and height).
---@return number # The window width
---@return number # The window height
function window.get_size() end

--- Sets the dimming mode on a mobile device.
---The dimming mode specifies whether or not a mobile device should dim the screen after a period without user interaction. The dimming mode will only affect the mobile device while the game is in focus on the device, but not when the game is running in the background.
---This function has no effect on platforms that does not support dimming.
---@param mode constant # The mode for screen dimming
function window.set_dim_mode(mode) end

---Sets a window event listener.
---@param callback fun(self: object, event: constant, data: table) # A callback which receives info about window events. Pass an empty function or nil if you no longer wish to receive callbacks.
function window.set_listener(callback) end

---Set the locking state for current mouse cursor on a PC platform.
---This function locks or unlocks the mouse cursor to the center point of the window. While the cursor is locked,
---mouse position updates will still be sent to the scripts as usual.
---@param flag boolean # The lock state for the mouse cursor
function window.set_mouse_lock(flag) end




return window