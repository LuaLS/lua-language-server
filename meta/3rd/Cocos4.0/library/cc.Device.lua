---@meta

---@class cc.Device 
local Device={ }
cc.Device=Device




---* To enable or disable accelerometer.
---@param isEnabled boolean
---@return self
function Device:setAccelerometerEnabled (isEnabled) end
---* Sets the interval of accelerometer.
---@param interval float
---@return self
function Device:setAccelerometerInterval (interval) end
---* Controls whether the screen should remain on.<br>
---* param keepScreenOn One flag indicating that the screen should remain on.
---@param keepScreenOn boolean
---@return self
function Device:setKeepScreenOn (keepScreenOn) end
---* Vibrate for the specified amount of time.<br>
---* If vibrate is not supported, then invoking this method has no effect.<br>
---* Some platforms limit to a maximum duration of 5 seconds.<br>
---* Duration is ignored on iOS due to API limitations.<br>
---* param duration The duration in seconds.
---@param duration float
---@return self
function Device:vibrate (duration) end
---* Gets the DPI of device<br>
---* return The DPI of device.
---@return int
function Device:getDPI () end