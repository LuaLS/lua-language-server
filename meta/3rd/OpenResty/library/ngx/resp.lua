---@meta
local resp={}

resp.version = require("resty.core.base").version

--- This function adds specified header with corresponding value to the response of current request.
---
--- The `header_value` could be either a string or a table.
---
--- The ngx.resp.add_header works mostly like:
---
---     `ngx.header.HEADER`
---     Nginx's `add_header` directive.
---
--- However, unlike `ngx.header.HEADER`, this method appends new header to the old one instead of overriding it.
---
--- Unlike `add_header` directive, this method will override the builtin header instead of appending it.
---
---@param key   string
---@param value string|string[]
function resp.add_header(key, value) end

return resp