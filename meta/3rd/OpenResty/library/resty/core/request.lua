---@meta
local resty_core_request={}
resty_core_request.version = require("resty.core.base").version
function resty_core_request.set_req_header(name, value, override) end
return resty_core_request