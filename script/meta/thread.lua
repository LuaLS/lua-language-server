---@meta bee.thread

---@class bee.thread
---@field id integer
local M = {}

---@param script string
---@param ... string
---@return bee.thread.thread
function M.create(script, ...) end

---@param time number
function M.sleep(time) end

---@param thd bee.thread.thread
function M.wait(thd)
end

---@return string?
function M.errlog()
end

---@class bee.thread.thread

return M
