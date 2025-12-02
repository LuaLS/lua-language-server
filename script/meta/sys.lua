---@meta bee.sys

---@class bee.sys
local sys = {}

---@return bee.path
function sys.exe_path()
end

---@return bee.path
function sys.dll_path()
end

---@param path bee.path
---@return bee.path?
function sys.fullpath(path)
end

return sys
