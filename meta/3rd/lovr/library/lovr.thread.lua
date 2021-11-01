---@meta

---
---The `lovr.thread` module provides functions for creating threads and communicating between them.
---
---These are operating system level threads, which are different from Lua coroutines.
---
---Threads are useful for performing expensive background computation without affecting the framerate or performance of the main thread.  Some examples of this include asset loading, networking and network requests, and physics simulation.
---
---Threads come with some caveats:
---
---- Threads run in a bare Lua environment.  The `lovr` module (and any of lovr's modules) need to
---  be required before they can be used.
---  - To get `require` to work properly, add `require 'lovr.filesystem'` to the thread code.
---- Threads are completely isolated from other threads.  They do not have access to the variables
---  or functions of other threads, and communication between threads must be coordinated through
---  `Channel` objects.
---- The graphics module (or any functions that perform rendering) cannot be used in a thread.
---  Note that this includes creating graphics objects like Models and Textures.  There are "data"
---  equivalent `ModelData` and `Image` objects that can be used in threads though.
---- `lovr.event.pump` cannot be called from a thread.
---- Crashes or problems can happen if two threads access the same object at the same time, so
---  special care must be taken to coordinate access to objects from multiple threads.
---
---@class lovr.thread
lovr.thread = {}

---
---Returns a named Channel for communicating between threads.
---
---@param name string # The name of the Channel to get.
---@return lovr.Channel channel # The Channel with the specified name.
function lovr.thread.getChannel(name) end

---
---Creates a new Thread from Lua code.
---
---@overload fun(filename: string):lovr.Thread
---@overload fun(blob: lovr.Blob):lovr.Thread
---@param code string # The code to run in the Thread.
---@return lovr.Thread thread # The new Thread.
function lovr.thread.newThread(code) end
