---@meta
ngx_balancer={}
function ngx_balancer.set_current_peer(addr, port) end
function ngx_balancer.set_timeouts(connect_timeout, send_timeout, read_timeout) end
function ngx_balancer.get_last_failure() end
function ngx_balancer.set_more_tries(count) end
ngx_balancer.version="0.1.17"
return ngx_balancer