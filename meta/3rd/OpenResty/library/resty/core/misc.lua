---@meta
local resty_core_misc={}
function resty_core_misc.register_ngx_magic_key_getter() end
function resty_core_misc.register_ngx_magic_key_setter() end
resty_core_misc._VERSION = require("resty.core.base").version
return resty_core_misc