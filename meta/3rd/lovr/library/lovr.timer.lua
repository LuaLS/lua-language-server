---@meta

---
---The `lovr.timer` module provides a few functions that deal with time.  All times are measured in seconds.
---
---@class lovr.timer
lovr.timer = {}

---
---Returns the average delta over the last second.
---
---@return number delta # The average delta, in seconds.
function lovr.timer.getAverageDelta() end

---
---Returns the time between the last two frames.  This is the same value as the `dt` argument provided to `lovr.update`.
---
---@return number dt # The delta time, in seconds.
function lovr.timer.getDelta() end

---
---Returns the current frames per second, averaged over the last 90 frames.
---
---@return number fps # The current FPS.
function lovr.timer.getFPS() end

---
---Returns the time since some time in the past.  This can be used to measure the difference between two points in time.
---
---@return number time # The current time, in seconds.
function lovr.timer.getTime() end

---
---Sleeps the application for a specified number of seconds.  While the game is asleep, no code will be run, no graphics will be drawn, and the window will be unresponsive.
---
---@param duration number # The number of seconds to sleep for.
function lovr.timer.sleep(duration) end

---
---Steps the timer, returning the new delta time.  This is called automatically in `lovr.run` and it's used to calculate the new `dt` to pass to `lovr.update`.
---
---@return number delta # The amount of time since the last call to this function, in seconds.
function lovr.timer.step() end
