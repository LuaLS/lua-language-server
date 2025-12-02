---@meta bee.thread

---@class bee.thread
local thread = {}

---@param time number
function thread.sleep(time) end

---@deprecated Use bee.channel.create() instead, or use bee-compat module
---@param name string
function thread.newchannel(name) end

---@deprecated Use bee.channel.query() instead, or use bee-compat module
---@param name string
---@return bee.thread.channel
function thread.channel(name) end

---@param script string
---@return userdata
function thread.create(script) end

---@deprecated Use thread.create() instead
---@param script string
---@return bee.thread.thread
function thread.thread(script) end

---@return string?
function thread.errlog() end

---@param handle userdata
function thread.wait(handle) end

---@param name string
function thread.setname(name) end

---@type integer
thread.id = 0

---@class bee.thread.channel
local channel = {}

function channel:push(...) end

---@return boolean, ...
function channel:pop() end

---@return ...
function channel:bpop() end

---@class bee.thread.thread

return thread
