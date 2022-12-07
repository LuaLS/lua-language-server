---@meta

---
---Provides access to information about the user's system.
---
---
---[Open in Browser](https://love2d.org/wiki/love.system)
---
---@class love.system
love.system = {}

---
---Gets text from the clipboard.
---
---
---[Open in Browser](https://love2d.org/wiki/love.system.getClipboardText)
---
---@return string text # The text currently held in the system's clipboard.
function love.system.getClipboardText() end

---
---Gets the current operating system. In general, LÖVE abstracts away the need to know the current operating system, but there are a few cases where it can be useful (especially in combination with os.execute.)
---
---
---[Open in Browser](https://love2d.org/wiki/love.system.getOS)
---
---@return string osString # The current operating system. 'OS X', 'Windows', 'Linux', 'Android' or 'iOS'.
function love.system.getOS() end

---
---Gets information about the system's power supply.
---
---
---[Open in Browser](https://love2d.org/wiki/love.system.getPowerInfo)
---
---@return love.PowerState state # The basic state of the power supply.
---@return number percent # Percentage of battery life left, between 0 and 100. nil if the value can't be determined or there's no battery.
---@return number seconds # Seconds of battery life left. nil if the value can't be determined or there's no battery.
function love.system.getPowerInfo() end

---
---Gets the amount of logical processor in the system.
---
---
---[Open in Browser](https://love2d.org/wiki/love.system.getProcessorCount)
---
---@return number processorCount # Amount of logical processors.
function love.system.getProcessorCount() end

---
---Gets whether another application on the system is playing music in the background.
---
---Currently this is implemented on iOS and Android, and will always return false on other operating systems. The t.audio.mixwithsystem flag in love.conf can be used to configure whether background audio / music from other apps should play while LÖVE is open.
---
---
---[Open in Browser](https://love2d.org/wiki/love.system.hasBackgroundMusic)
---
---@return boolean backgroundmusic # True if the user is playing music in the background via another app, false otherwise.
function love.system.hasBackgroundMusic() end

---
---Opens a URL with the user's web or file browser.
---
---
---[Open in Browser](https://love2d.org/wiki/love.system.openURL)
---
---@param url string # The URL to open. Must be formatted as a proper URL.
---@return boolean success # Whether the URL was opened successfully.
function love.system.openURL(url) end

---
---Puts text in the clipboard.
---
---
---[Open in Browser](https://love2d.org/wiki/love.system.setClipboardText)
---
---@param text string # The new text to hold in the system's clipboard.
function love.system.setClipboardText(text) end

---
---Causes the device to vibrate, if possible. Currently this will only work on Android and iOS devices that have a built-in vibration motor.
---
---
---[Open in Browser](https://love2d.org/wiki/love.system.vibrate)
---
---@param seconds? number # The duration to vibrate for. If called on an iOS device, it will always vibrate for 0.5 seconds due to limitations in the iOS system APIs.
function love.system.vibrate(seconds) end

---
---The basic state of the system's power supply.
---
---
---[Open in Browser](https://love2d.org/wiki/PowerState)
---
---@alias love.PowerState
---
---Cannot determine power status.
---
---| "unknown"
---
---Not plugged in, running on a battery.
---
---| "battery"
---
---Plugged in, no battery available.
---
---| "nobattery"
---
---Plugged in, charging battery.
---
---| "charging"
---
---Plugged in, battery is fully charged.
---
---| "charged"
