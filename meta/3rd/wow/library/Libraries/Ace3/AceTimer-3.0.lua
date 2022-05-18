---@meta
---@class AceTimerObj
---@field object table The object that the timer is registered on (self)
---@fiel func function Callback function
---@field looping boolean If true, the timer will loop
---@field argsCount number number of arguments to pass to the callback function
---@field delay number delay in seconds
---@field ends number GetTime() + delay,

---@class AceTimer-3.0
local AceTimer = {}

---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-timer-3-0#title-1)
function AceTimer:CancelAllTimers() end

---@param id AceTimerObj The id of the timer, as returned by `:ScheduleTimer` or `:ScheduleRepeatingTimer`
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-timer-3-0#title-2)
function AceTimer:CancelTimer(id) end

---@param func function Callback function for the timer pulse (funcref or method name).
---@param delay number Delay for the timer, in seconds.
---@param ... any An optional, unlimited amount of arguments to pass to the callback function.
---@return AceTimerObj
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-timer-3-0#title-3)
function AceTimer:ScheduleRepeatingTimer(func, delay, ...) end

---@param func function callback Callback function for the timer pulse (funcref or method name).
---@param delay number Delay for the timer, in seconds.
---@param ... any An optional, unlimited amount of arguments to pass to the callback function.
---@return AceTimerObj
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-timer-3-0#title-4)
function AceTimer:ScheduleTimer(func, delay, ...) end

---@param id AceTimerObj The id of the timer, as returned by `:ScheduleTimer` or `:ScheduleRepeatingTimer`
---@return number -- The time left on the timer.
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-timer-3-0#title-5)
function AceTimer:TimeLeft(id) end
