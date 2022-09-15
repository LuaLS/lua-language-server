---@meta

---
---The `lovr.system` provides information about the current platform and hardware.
---
---@class lovr.system
lovr.system = {}

---
---Returns the number of logical cores on the system.
---
---@return number cores # The number of logical cores on the system.
function lovr.system.getCoreCount() end

---
---Returns the current operating system.
---
---@return string os # Either "Windows", "macOS", "Linux", "Android" or "Web".
function lovr.system.getOS() end

---
---Returns the window pixel density.
---
---High DPI windows will usually return 2.0 to indicate that there are 2 pixels for every window coordinate in each axis.
---
---On a normal display, 1.0 is returned, indicating that window coordinates match up with pixels 1:1.
---
---@return number density # The pixel density of the window.
function lovr.system.getWindowDensity() end

---
---Returns the dimensions of the desktop window.
---
---
---### NOTE:
---If the window is not open, this will return zeros.
---
---@return number width # The width of the desktop window.
---@return number height # The height of the desktop window.
function lovr.system.getWindowDimensions() end

---
---Returns the height of the desktop window.
---
---
---### NOTE:
---If the window is not open, this will return zero.
---
---@return number width # The height of the desktop window.
function lovr.system.getWindowHeight() end

---
---Returns the width of the desktop window.
---
---
---### NOTE:
---If the window is not open, this will return zero.
---
---@return number width # The width of the desktop window.
function lovr.system.getWindowWidth() end

---
---Returns whether a key on the keyboard is pressed.
---
---@param key lovr.KeyCode # The key.
---@return boolean down # Whether the key is currently pressed.
function lovr.system.isKeyDown(key) end

---
---Returns whether the desktop window is open.
---
---`t.window` can be set to `nil` in `lovr.conf` to disable automatic opening of the window.
---
---In this case, the window can be opened manually using `lovr.system.openWindow`.
---
---@return boolean open # Whether the desktop window is open.
function lovr.system.isWindowOpen() end

---
---Opens the desktop window.
---
---If the window is already open, this function does nothing.
---
---
---### NOTE:
---By default, the window is opened automatically, but this can be disabled by setting `t.window` to `nil` in `conf.lua`.
---
---@param options {width: number, height: number, fullscreen: boolean, resizable: boolean, title: string, icon: string} # Window options.
function lovr.system.openWindow(options) end

---
---Requests permission to use a feature.
---
---Usually this will pop up a dialog box that the user needs to confirm.
---
---Once the permission request has been acknowledged, the `lovr.permission` callback will be called with the result.
---
---Currently, this is only used for requesting microphone access on Android devices.
---
---@param permission lovr.Permission # The permission to request.
function lovr.system.requestPermission(permission) end

---
---These are the different permissions that need to be requested using `lovr.system.requestPermission` on some platforms.
---
---@alias lovr.Permission
---
---Requests microphone access.
---
---| "audiocapture"
