---@meta bee.sys

---@class bee.sys
local sys = {}

---@param path fs.path
---@return fs.path
function sys.fullpath(path) end

---@return fs.path
function sys.exe_path() end

return sys
