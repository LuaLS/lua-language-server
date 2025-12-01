---@meta

---@class bee.select
local select = {}

---Read event flag
select.SELECT_READ = 1

---Write event flag
select.SELECT_WRITE = 2

---@class bee.select.selector
local selector = {}

---Add a file descriptor to the selector
---@param fd any # File descriptor (socket, file handle, etc.)
---@param events integer # Event flags (SELECT_READ | SELECT_WRITE)
---@param callback? any # Optional callback data
---@return boolean success
function selector:event_add(fd, events, callback) end

---Modify event flags for a file descriptor
---@param fd any # File descriptor
---@param events integer # New event flags (SELECT_READ | SELECT_WRITE)
---@param callback? any # Optional callback data
---@return boolean success
function selector:event_mod(fd, events, callback) end

---Remove a file descriptor from the selector
---@param fd any # File descriptor
---@return boolean success
function selector:event_del(fd) end

---Wait for events on registered file descriptors
---@param timeout? integer # Timeout in milliseconds (ms), -1 for infinite wait, default 0 (non-blocking)
---@return fun():any, integer # Iterator function returning (callback_data, event_flags)
function selector:wait(timeout) end

---Close the selector and release resources
function selector:close() end

---Create a new selector instance
---@return bee.select.selector
function select.create() end

return select
