---@meta
ngx_errlog={}
function ngx_errlog.get_sys_filter_level() end
function ngx_errlog.set_filter_level(level) end
function ngx_errlog.get_logs(max, logs) end
function ngx_errlog.raw_log(level, msg) end
ngx_errlog.version="0.1.17"
return ngx_errlog