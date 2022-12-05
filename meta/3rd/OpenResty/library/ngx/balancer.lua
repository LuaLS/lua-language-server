---@meta
local balancer = {
  version = require("resty.core.base").version,
}

--- Sets the peer address (host and port) for the current backend query (which
--- may be a retry).
---
--- Domain names in host do not make sense. You need to use OpenResty libraries
--- like lua-resty-dns to obtain IP address(es) from all the domain names before
--- entering the `balancer_by_lua*` handler (for example, you can perform DNS
--- lookups in an earlier phase like `access_by_lua*` and pass the results to the
--- `balancer_by_lua*` handler via `ngx.ctx`.
---
---@param  addr    string
---@param  port    integer
---@return boolean ok
---@return string? error
function balancer.set_current_peer(addr, port) end


--- Sets the upstream timeout (connect, send and read) in seconds for the
--- current and any subsequent backend requests (which might be a retry).
---
--- If you want to inherit the timeout value of the global nginx.conf
--- configuration (like `proxy_connect_timeout`), then just specify the nil value
--- for the corresponding argument (like the `connect_timeout` argument).
---
--- Zero and negative timeout values are not allowed.
---
--- You can specify millisecond precision in the timeout values by using floating
--- point numbers like 0.001 (which means 1ms).
---
--- Note: `send_timeout` and `read_timeout` are controlled by the same config
--- `proxy_timeout` for `ngx_stream_proxy_module`. To keep API compatibility, this
--- function will use `max(send_timeout, read_timeout)` as the value for setting
--- proxy_timeout.
---
--- Returns `true` when the operation is successful; returns `nil` and a string
--- describing the error otherwise.
---
--- This only affects the current downstream request. It is not a global change.
---
--- For the best performance, you should use the OpenResty bundle.
---
---@param  connect_timeout? number
---@param  send_timeout?    number
---@param  read_timeout?    number
---@return boolean          ok
---@return string?          error
function balancer.set_timeouts(connect_timeout, send_timeout, read_timeout) end

---@alias ngx.balancer.failure
---| '"next"' # Failures due to bad status codes sent from the backend server. The origin's response is same though, which means the backend connection can still be reused for future requests.
---| '"failed"' Fatal errors while communicating to the backend server (like connection timeouts, connection resets, and etc). In this case, the backend connection must be aborted and cannot get reused.

--- Retrieves the failure details about the previous failed attempt (if any) when
--- the next_upstream retrying mechanism is in action. When there was indeed a
--- failed previous attempt, it returned a string describing that attempt's state
--- name, as well as an integer describing the status code of that attempt.
---
--- Possible status codes are those HTTP error status codes like 502 and 504.
---
--- For stream module, `status_code` will always be 0 (`ngx.OK`) and is provided
--- for compatibility reasons.
---
--- When the current attempt is the first attempt for the current downstream
--- request (which means there is no previous attempts at all), this method
--- always returns a single `nil` value.
---
---@return ngx.balancer.failure? state_name
---@return integer?              status_code
function balancer.get_last_failure() end

--- Sets the tries performed when the current attempt (which may be a retry)
--- fails (as determined by directives like proxy_next_upstream, depending on
--- what particular nginx uptream module you are currently using).
--
--- Note that the current attempt is excluded in the count number set here.
---
--- Please note that, the total number of tries in a single downstream request
--- cannot exceed the hard limit configured by directives like
--- `proxy_next_upstream_tries`, depending on what concrete NGINX upstream
--- module you are using. When exceeding this limit, the count value will get
--- reduced to meet the limit and the second return value will be the string
--- "reduced tries due to limit", which is a warning, while the first return
--- value is still a `true` value.
---
---@param  count   integer
---@return boolean ok
---@return string? error
function balancer.set_more_tries(count) end

--- Recreates the request buffer for sending to the upstream server.
---
--- This is useful, for example if you want to change a request header field
--- to the new upstream server on balancer retries.
---
--- Normally this does not work because the request buffer is created once
--- during upstream module initialization and won't be regenerated for subsequent
--- retries. However you can use `proxy_set_header My-Header $my_header` and
--- set the `ngx.var.my_header` variable inside the balancer phase. Calling
--- `recreate_request()` after updating a header field will cause the request
--- buffer to be re-generated and the `My-Header` header will thus contain the
--- new value.
---
--- Warning: because the request buffer has to be recreated and such allocation
--- occurs on the request memory pool, the old buffer has to be thrown away and
--- will only be freed after the request finishes. Do not call this function too
--- often or memory leaks may be noticeable. Even so, a call to this function
--- should be made only if you know the request buffer must be regenerated,
--- instead of unconditionally in each balancer retries.
---
---@return boolean ok
---@return string? error
function balancer.recreate_request() end

return balancer