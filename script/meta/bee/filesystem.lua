---@meta

---@class fs.path
---@operator div: fs.path
local fsPath = {}

---@return string
function fsPath:string()
end

---@return fs.path
function fsPath:parent_path()
end

---@return boolean
function fsPath:is_relative()
end

---@return fs.path
function fsPath:filename()
end

---@return fs.path
function fsPath:stem()
end

---@return string
function fsPath:extension()
end

---@class fs.status
local fsStatus = {}

---@return 'none' | 'not_found' | 'regular' | 'directory' | 'symlink' | 'block' | 'character' | 'fifo' | 'junction' | 'unknown'
function fsStatus:type()
end

---@class bee.filesystem
local fs = {}

---@class fs.copy_options
---@field overwrite_existing integer
local copy_options

fs.copy_options = copy_options

---@param path string|fs.path
---@return fs.path
function fs.path(path)
end

---@return fs.path
function fs.exe_path()
end

---@param path fs.path
---@return boolean
function fs.exists(path)
end

---@param path fs.path
---@return boolean
function fs.is_directory(path)
end

---@param path fs.path
---@return fun():fs.path, fs.status
function fs.pairs(path)
end

---@param path fs.path
---@return fs.path
function fs.canonical(path)
end

---@param path fs.path
---@return fs.path
function fs.fullpath(path)
end

---@param path fs.path
---@return fs.path
function fs.absolute(path)
end

---@param path fs.path
function fs.create_directories(path)
end

---@param path fs.path
---@return fs.status
function fs.symlink_status(path)
end

---@param path fs.path
---@return boolean
function fs.remove(path)
end

---@param source fs.path
---@param target fs.path
---@param options? integer | `fs.copy_options.overwrite_existing`
function fs.copy_file(source, target, options)
end

---@param oldPath fs.path
---@param newPath fs.path
function fs.rename(oldPath, newPath)
end

---@return fs.path
function fs.current_path()
end

---@param path fs.path
---@param base fs.path
---@return fs.path
function fs.relative(path, base)
end

return fs
