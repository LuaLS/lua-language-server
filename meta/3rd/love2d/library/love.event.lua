---@meta

---@class love.event
love.event = {}

---
---Clears the event queue.
---
function love.event.clear() end

---
---Returns an iterator for messages in the event queue.
---
function love.event.poll() end

---
---Pump events into the event queue.
---
---This is a low-level function, and is usually not called by the user, but by love.run.
---
---Note that this does need to be called for any OS to think you're still running,
---
---and if you want to handle OS-generated events at all (think callbacks).
---
function love.event.pump() end

---
---Adds an event to the event queue.
---
---From 0.10.0 onwards, you may pass an arbitrary amount of arguments with this function, though the default callbacks don't ever use more than six.
---
function love.event.push() end

---
---Adds the quit event to the queue.
---
---The quit event is a signal for the event handler to close LÖVE. It's possible to abort the exit process with the love.quit callback.
---
---@param exitstatus number # The program exit status to use when closing the application.
function love.event.quit(exitstatus) end

---
---Like love.event.poll(), but blocks until there is an event in the queue.
---
function love.event.wait() end
