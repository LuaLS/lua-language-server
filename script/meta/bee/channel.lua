---@meta

---@class bee.channel
local channel_mod = {}

---@class bee.channel.object
local channel = {}

---@param ... any
function channel:push(...)
end

---@return boolean success
---@return ...
function channel:pop()
end

---@return userdata
function channel:fd()
end

---@param name string
---@return bee.channel.object
function channel_mod.create(name)
end

---@param name string
function channel_mod.destroy(name)
end

---@param name string
---@return bee.channel.object?
function channel_mod.query(name)
end

return channel_mod
