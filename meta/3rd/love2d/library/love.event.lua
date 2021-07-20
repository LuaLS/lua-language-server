---@class love.event
love.event = {}

---
---Clears the event queue.
---
function love.event.clear() end

---
---Returns an iterator for messages in the event queue.
---
---@return function i # Iterator function usable in a for loop.
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
---@param n love.event.Event # The name of the event.
---@param a love.event.Variant # First event argument.
---@param b love.event.Variant # Second event argument.
---@param c love.event.Variant # Third event argument.
---@param d love.event.Variant # Fourth event argument.
---@param e love.event.Variant # Fifth event argument.
---@param f love.event.Variant # Sixth event argument.
---@param ... love.event.Variant # Further event arguments may follow.
function love.event.push(n, a, b, c, d, e, f, ...) end

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
---@return love.event.Event n # The name of event.
---@return love.event.Variant a # First event argument.
---@return love.event.Variant b # Second event argument.
---@return love.event.Variant c # Third event argument.
---@return love.event.Variant d # Fourth event argument.
---@return love.event.Variant e # Fifth event argument.
---@return love.event.Variant f # Sixth event argument.
---@return love.event.Variant ... # Further event arguments may follow.
function love.event.wait() end
