---@meta

---@class bee.channel
local channelMod = {}

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
function channelMod.create(name)
end

---@param name string
function channelMod.destroy(name)
end

---@param name string
---@return bee.channel.object?
function channelMod.query(name)
end

return channelMod
