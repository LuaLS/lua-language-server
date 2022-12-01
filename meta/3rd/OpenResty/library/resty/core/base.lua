---@meta
local resty_core_base = {}

---@param ... string
function resty_core_base.allows_subsystem(...) end

---@param t table
function resty_core_base.clear_tab(t) end

---@return userdata
function resty_core_base.get_errmsg_ptr() end

---@return userdata
function resty_core_base.get_request() end

---@return userdata
function resty_core_base.get_size_ptr() end

---@param size number
---@param must_alloc? boolean
---@return userdata
function resty_core_base.get_string_buf(size, must_alloc) end

---@return number
function resty_core_base.get_string_buf_size() end

---@param narr number
---@param nrec number
---@return table
function resty_core_base.new_tab(narr, nrec) end

---@param tb table
---@param key any
---@return any
function resty_core_base.ref_in_table(tb, key) end

---@param size number
function resty_core_base.set_string_buf_size(size) end

resty_core_base.FFI_OK = 0
resty_core_base.FFI_NO_REQ_CTX = -100
resty_core_base.FFI_BAD_CONTEXT = -101
resty_core_base.FFI_ERROR = -1
resty_core_base.FFI_AGAIN = -2
resty_core_base.FFI_BUSY = -3
resty_core_base.FFI_DONE = -4
resty_core_base.FFI_DECLINED = -5

resty_core_base.version = "0.1.23"

return resty_core_base