---@meta

local m = {}

---@enum bee.filesystem.copy_options
local copy_options = {
    none = 0,
    skip_existing = 1,
    overwrite_existing = 2,
    update_existing = 4,
    recursive = 8,
    copy_symlinks = 16,
    skip_symlinks = 32,
    directories_only = 64,
    create_symlinks = 128,
    create_hard_links = 256,
    __in_recursive_copy = 512,
}

---@alias bee.filesystem.path_arg string|bee.filesystem.path

---@class bee.filesystem.path
---@operator div(any):bee.filesystem.path
---@operator concat(any):bee.filesystem.path
local path = {}

---@return string
function path:string()
end

---@return bee.filesystem.path
function path:filename()
end

---@return bee.filesystem.path
function path:parent_path()
end

---@return bee.filesystem.path
function path:stem()
end

---@return bee.filesystem.path
function path:extension()
end

---@return boolean
function path:is_absolute()
end

---@return boolean
function path:is_relative()
end

---@return bee.filesystem.path
function path:remove_filename()
end

---@param filename bee.filesystem.path_arg
---@return bee.filesystem.path
function path:replace_filename(filename)
end

---@param extension bee.filesystem.path_arg
---@return bee.filesystem.path
function path:replace_extension(extension)
end

---@param path bee.filesystem.path_arg
---@return boolean
function path:equal_extension(path)
end

---@return bee.filesystem.path
function path:lexically_normal()
end

---@class bee.filesystem.file_status
local file_status = {}

---@alias bee.filesystem.file_type
---| "'none'"
---| "'not_found'"
---| "'regular'"
---| "'directory'"
---| "'symlink'"
---| "'block'"
---| "'character'"
---| "'fifo'"
---| "'socket'"
---| "'junction'"
---| "'unknown'"

---@return bee.filesystem.file_type
function file_status:type()
end

---@return boolean
function file_status:exists()
end

---@return boolean
function file_status:is_directory()
end

---@return boolean
function file_status:is_regular_file()
end

---@class bee.filesystem.directory_entry
local directory_entry = {}

---@return bee.filesystem.path
function directory_entry:path()
end

---@return bee.filesystem.file_status
function directory_entry:status()
end

---@return bee.filesystem.file_status
function directory_entry:symlink_status()
end

---@return bee.filesystem.file_type
function directory_entry:type()
end

---@return boolean
function directory_entry:exists()
end

---@return boolean
function directory_entry:is_directory()
end

---@return boolean
function directory_entry:is_regular_file()
end

---@return bee.filesystem.path
function m.path(path)
end

---@return bee.filesystem.file_status
function m.status(path)
end

---@return bee.filesystem.file_status
function m.symlink_status(path)
end

---@return boolean
function m.exists(path)
end

---@return boolean
function m.is_directory(path)
end

---@return boolean
function m.is_regular_file(path)
end

function m.create_directory(path)
end

function m.create_directories(path)
end

function m.rename(from, to)
end

function m.remove(path)
end

function m.remove_all(path)
end

---@return bee.filesystem.path
function m.current_path()
end

---@param options bee.filesystem.copy_options
function m.copy(from, to, options)
end

---@param options bee.filesystem.copy_options
function m.copy_file(from, to, options)
end

function m.absolute(path)
end

function m.canonical(path)
end

function m.relative(path)
end

function m.last_write_time(path)
end

function m.permissions(path)
end

function m.create_symlink(target, link)
end

function m.create_directory_symlink(target, link)
end

function m.create_hard_link(target, link)
end

---@return bee.filesystem.path
function m.temp_directory_path()
end

---@return fun(table: bee.filesystem.path[]): bee.filesystem.path
function m.pairs(path)
end

---@return bee.filesystem.path
function m.exe_path()
end

---@return bee.filesystem.path
function m.dll_path()
end

---@return bee.file
function m.filelock(path)
end

---@return bee.filesystem.path
function m.fullpath(path)
end

return m
