---@meta

---@class bee.file:lightuserdata
local file = {}

---@alias bee.file.readmode integer|"'a'"

---@param mode bee.file.readmode
---@return string
function file:read(mode)
end

---@param buf number|integer|string
function file:write(buf)
end

---@return fun():string
function file:lines()
end

function file:flush()
end

function file:close()
end

---@param mode "'no'"|"'full'"|"'line'"
function file:setvbuf(mode)
end

---@class bee.process
---@field stderr bee.file?
---@field stdout bee.file?
---@field stdin bee.file?
local process = {}

---@return integer exit_code
function process:wait()
end

---@return boolean success
function process:kill()
end

---@return integer process_id
function process:get_id()
end

---@return boolean is_running
function process:is_running()
end

---@return boolean success
function process:resume()
end

---@return any native_handle
function process:native_handle()
end

---@class bee.subprocess
local m = {}

---@alias bee.bee.subprocess.spawn_io_arg boolean|file*|bee.file|"'stderr'"|"'stdout'"

---@class bee.subprocess.spawn.options : string[]
---@field stdin bee.bee.subprocess.spawn_io_arg?
---@field stdout bee.bee.subprocess.spawn_io_arg?
---@field stderr bee.bee.subprocess.spawn_io_arg?
---@field env table<string,string>?
---@field suspended boolean?
---@field detached boolean?

---@param options bee.subprocess.spawn.options
---@return bee.process process
function m.spawn(options)
end

---@param file file*|bee.file
---@return integer offset
---@return string? error_message
function m.peek(file)
end

function m.filemode()
end

---@param name string
---@param value string
---@return boolean success
---@return string? error_message
function m.setenv(name, value)
end

---@return integer current_process_id
function m.get_id()
end

return m
