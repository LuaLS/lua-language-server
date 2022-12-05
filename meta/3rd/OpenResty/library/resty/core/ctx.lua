---@meta
local resty_core_ctx={}
resty_core_ctx._VERSION = require("resty.core.base").version

---@param ctx? table
---@return table
function resty_core_ctx.get_ctx_table(ctx) end

return resty_core_ctx