---@meta

---@class bee.thread
local thread = {}

---@param time integer
function thread.sleep(time) end

---@param name string
function thread.newchannel(name) end

---@param name string
---@return bee.thread.channel
function thread.channel(name) end

---@param script string
---@return bee.thread.thread
function thread.create(script) end

---@return string?
function thread.errlog() end

---@class bee.thread.channel
local channel = {}

function channel:push(...) end

---@return ...
function channel:pop() end

---@return ...
function channel:bpop() end

---@class bee.thread.thread

return thread
