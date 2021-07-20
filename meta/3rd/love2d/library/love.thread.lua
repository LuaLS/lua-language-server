---@class love.thread
love.thread = {}

---
---Creates or retrieves a named thread channel.
---
---@param name string # The name of the channel you want to create or retrieve.
---@return love.thread.Channel channel # The Channel object associated with the name.
function love.thread.getChannel(name) end

---
---Create a new unnamed thread channel.
---
---One use for them is to pass new unnamed channels to other threads via Channel:push on a named channel.
---
---@return love.thread.Channel channel # The new Channel object.
function love.thread.newChannel() end

---
---Creates a new Thread from a filename, string or FileData object containing Lua code.
---
---@param filename string # The name of the Lua file to use as the source.
---@return love.thread.Thread thread # A new Thread that has yet to be started.
function love.thread.newThread(filename) end

---@class love.thread.Channel: love.thread.Object
local Channel = {}

---
---Clears all the messages in the Channel queue.
---
function Channel:clear() end

---
---Retrieves the value of a Channel message and removes it from the message queue.
---
---It waits until a message is in the queue then returns the message value.
---
---@return love.thread.Variant value # The contents of the message.
function Channel:demand() end

---
---Retrieves the number of messages in the thread Channel queue.
---
---@return number count # The number of messages in the queue.
function Channel:getCount() end

---
---Gets whether a pushed value has been popped or otherwise removed from the Channel.
---
---@param id number # An id value previously returned by Channel:push.
---@return boolean hasread # Whether the value represented by the id has been removed from the Channel via Channel:pop, Channel:demand, or Channel:clear.
function Channel:hasRead(id) end

---
---Retrieves the value of a Channel message, but leaves it in the queue.
---
---It returns nil if there's no message in the queue.
---
---@return love.thread.Variant value # The contents of the message.
function Channel:peek() end

---
---Executes the specified function atomically with respect to this Channel.
---
---Calling multiple methods in a row on the same Channel is often useful. However if multiple Threads are calling this Channel's methods at the same time, the different calls on each Thread might end up interleaved (e.g. one or more of the second thread's calls may happen in between the first thread's calls.)
---
---This method avoids that issue by making sure the Thread calling the method has exclusive access to the Channel until the specified function has returned.
---
---@param func function # The function to call, the form of function(channel, arg1, arg2, ...) end. The Channel is passed as the first argument to the function when it is called.
---@param arg1 love.thread.any # Additional arguments that the given function will receive when it is called.
---@param ... love.thread.any # Additional arguments that the given function will receive when it is called.
---@return love.thread.any ret1 # The first return value of the given function (if any.)
---@return love.thread.any ... # Any other return values.
function Channel:performAtomic(func, arg1, ...) end

---
---Retrieves the value of a Channel message and removes it from the message queue.
---
---It returns nil if there are no messages in the queue.
---
---@return love.thread.Variant value # The contents of the message.
function Channel:pop() end

---
---Send a message to the thread Channel.
---
---See Variant for the list of supported types.
---
---@param value love.thread.Variant # The contents of the message.
---@return number id # Identifier which can be supplied to Channel:hasRead
function Channel:push(value) end

---
---Send a message to the thread Channel and wait for a thread to accept it.
---
---See Variant for the list of supported types.
---
---@param value love.thread.Variant # The contents of the message.
---@return boolean success # Whether the message was successfully supplied (always true).
function Channel:supply(value) end

---@class love.thread.Thread: love.thread.Object
local Thread = {}

---
---Retrieves the error string from the thread if it produced an error.
---
---@return string err # The error message, or nil if the Thread has not caused an error.
function Thread:getError() end

---
---Returns whether the thread is currently running.
---
---Threads which are not running can be (re)started with Thread:start.
---
---@return boolean value # True if the thread is running, false otherwise.
function Thread:isRunning() end

---
---Starts the thread.
---
---Beginning with version 0.9.0, threads can be restarted after they have completed their execution.
---
function Thread:start() end

---
---Wait for a thread to finish.
---
---This call will block until the thread finishes.
---
function Thread:wait() end
