---@meta

---
---The `lovr.system` provides information about the current operating system, and platform, and hardware.
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
---Requests permission to use a feature.  Usually this will pop up a dialog box that the user needs to confirm.  Once the permission request has been acknowledged, the `lovr.permission` callback will be called with the result.  Currently, this is only used for requesting microphone access on Android devices.
---
---@param permission lovr.Permission # The permission to request.
function lovr.system.requestPermission(permission) end

---
---These are the different permissions that need to be requested using `lovr.system.requestPermission` on some platforms.
---
---@class lovr.Permission
---
---Requests microphone access.
---
---@field audiocapture integer
