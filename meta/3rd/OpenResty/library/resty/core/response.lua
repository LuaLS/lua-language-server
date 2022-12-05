---@meta
local resty_core_response={}
function resty_core_response.set_resp_header() end
resty_core_response.version = require("resty.core.base").version
return resty_core_response