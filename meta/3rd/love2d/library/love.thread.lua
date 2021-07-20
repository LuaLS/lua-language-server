---@class love.thread
love.thread = {}

---
---Creates or retrieves a named thread channel.
---
---@param name string # The name of the channel you want to create or retrieve.
---@return Channel channel # The Channel object associated with the name.
function love.thread.getChannel(name) end

---
---Create a new unnamed thread channel.
---
---One use for them is to pass new unnamed channels to other threads via Channel:push on a named channel.
---
---@return Channel channel # The new Channel object.
function love.thread.newChannel() end

---
---Creates a new Thread from a filename, string or FileData object containing Lua code.
---
---@param filename string # The name of the Lua file to use as the source.
---@return Thread thread # A new Thread that has yet to be started.
function love.thread.newThread(filename) end
