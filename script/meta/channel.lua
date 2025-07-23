---@meta bee.channel

---@class bee.channel
local M = {}

---@param name string
---@return bee.channel.channel
function M.create(name)
end

---@param name string
function M.destroy(name)
end

---@param name string
---@return bee.channel.channel?
function M.query(name)
end

---@class bee.channel.channel
local C = {}

function C:push(...)
end

---@return boolean
---@return ...
function C:pop()
end

---@return bee.fd
function C:fd()
end

return M
