---@class fspath
---@operator div: fspath
local fsPath = {}

---@return string
function fsPath:string()
end

---@return fspath
function fsPath:parent_path()
end

---@return boolean
function fsPath:is_relative()
end

---@return fspath
function fsPath:filename()
end

local fs = {}

---@param path string
---@return fspath
function fs.path(path)
end

return fs
