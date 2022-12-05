---@meta
local req = {}

req.version = require("resty.core.base").version

---This method adds the specified header and its value to the current request. It works similarly as ngx.req.set_header, with the exception that when the header already exists, the specified value(s) will be appended instead of overriden.
---
---When the specified `header_name` is a builtin header (e.g. User-Agent), this method will override its values.
---
---The `header_value` argument can either be a string or a non-empty, array-like table. A nil or empty table value will cause this function to throw an error.
---
---@param header_name string            must be a non-empty string.
---@param header_value string|string[]
function req.add_header(header_name, header_value) end

return req
