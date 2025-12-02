---@meta

---@class bee.sys
local sys = {}

---@return fs.path
function sys.exe_path()
end

---@return fs.path
function sys.dll_path()
end

---@param path fs.path
---@return fs.path?
function sys.fullpath(path)
end

return sys
