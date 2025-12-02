---@meta bee.filesystem

---@class bee.path
---@operator div: bee.path
local path = {}

---@return string
function path:string()
end

---@return bee.path
function path:parent_path()
end

---@return boolean
function path:is_relative()
end

---@return boolean
function path:is_absolute()
end

---@return bee.path
function path:filename()
end

---@return bee.path
function path:remove_filename()
end

---@return bee.path
function path:replace_filename()
end

---@return bee.path
function path:stem()
end

---@return string
function path:extension()
end

---@return bee.path
function path:lexically_normal()
end

---@class fs.status
local fsStatus = {}

---@alias fs.status.typenames 'none' | 'not_found' | 'regular' | 'directory' | 'symlink' | 'block' | 'character' | 'fifo' | 'junction' | 'unknown'

---@return fs.status.typenames
function fsStatus:type()
end

---@class bee.filesystem
local fs = {}

---@class fs.copy_options
---@field overwrite_existing integer
local copy_options

fs.copy_options = copy_options

---@param path string|bee.path
---@return bee.path
function fs.path(path)
end

---@return bee.path
function fs.exe_path()
end

---@param path bee.path
---@return boolean
function fs.exists(path)
end

---@param path bee.path
---@return boolean
function fs.is_directory(path)
end

---@param path bee.path
---@return boolean
function fs.is_regular_file(path)
end

---@param path bee.path
---@return fun():bee.path, fs.status
function fs.pairs(path)
end

---@param path bee.path
---@return bee.path
function fs.canonical(path)
end

---@param path bee.path
---@return bee.path
function fs.absolute(path)
end

---@param path bee.path | string
function fs.create_directories(path)
end

---@param path bee.path | string
function fs.create_directory(path)
end

---@param path bee.path
---@return fs.status
function fs.symlink_status(path)
end

---@param path bee.path
---@return fs.status
function fs.status(path)
end

---@param path bee.path
---@return fs.status.typenames
function fs.type(path)
end

---@param path bee.path | string
---@return boolean
function fs.remove(path)
end

---@param path bee.path | string
---@return boolean
function fs.remove_all(path)
end

---@param source bee.path
---@param target bee.path
---@param options? integer | `fs.copy_options.overwrite_existing`
function fs.copy_file(source, target, options)
end

---@param oldPath bee.path
---@param newPath bee.path
function fs.rename(oldPath, newPath)
end

---@return bee.path
function fs.current_path()
end

return fs
