---@meta

---
---Provides an interface to the user's clock.
---
---
---[Open in Browser](https://love2d.org/wiki/love.timer)
---
---@class love.timer
love.timer = {}

---
---Returns the average delta time (seconds per frame) over the last second.
---
---
---[Open in Browser](https://love2d.org/wiki/love.timer.getAverageDelta)
---
---@return number delta # The average delta time over the last second.
function love.timer.getAverageDelta() end

---
---Returns the time between the last two frames.
---
---
---[Open in Browser](https://love2d.org/wiki/love.timer.getDelta)
---
---@return number dt # The time passed (in seconds).
function love.timer.getDelta() end

---
---Returns the current frames per second.
---
---
---[Open in Browser](https://love2d.org/wiki/love.timer.getFPS)
---
---@return number fps # The current FPS.
function love.timer.getFPS() end

---
---Returns the value of a timer with an unspecified starting time.
---
---This function should only be used to calculate differences between points in time, as the starting time of the timer is unknown.
---
---
---[Open in Browser](https://love2d.org/wiki/love.timer.getTime)
---
---@return number time # The time in seconds. Given as a decimal, accurate to the microsecond.
function love.timer.getTime() end

---
---Pauses the current thread for the specified amount of time.
---
---
---[Open in Browser](https://love2d.org/wiki/love.timer.sleep)
---
---@param s number # Seconds to sleep for.
function love.timer.sleep(s) end

---
---Measures the time between two frames.
---
---Calling this changes the return value of love.timer.getDelta.
---
---
---[Open in Browser](https://love2d.org/wiki/love.timer.step)
---
---@return number dt # The time passed (in seconds).
function love.timer.step() end
