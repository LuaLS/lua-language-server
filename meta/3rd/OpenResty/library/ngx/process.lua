---@meta
local process = {
  version = require("resty.core.base").version,
}

--- Returns a number value for the nginx master process's process ID (or PID).
---
---@return integer? pid
function process.get_master_pid() end


--- Enables the privileged agent process in Nginx.
---
--- The privileged agent process does not listen on any virtual server ports
--- like those worker processes. And it uses the same system account as the
--- nginx master process, which is usually a privileged account like root.
---
--- The `init_worker_by_lua*` directive handler still runs in the privileged
--- agent process. And one can use the `type()` function provided by this module
--- to check if the current process is a privileged agent.
---
--- In case of failures, returns `nil` and a string describing the error.
---
---@param connections integer sets the maximum number of simultaneous connections that can be opened by the privileged agent process.
---@return boolean ok
---@return string? error
function process.enable_privileged_agent(connections) end


---@alias ngx.process.type
---| '"master"'           # the NGINX master process
---| '"worker"'           # an NGINX worker process
---| '"privileged agent"' # the NGINX privileged agent process
---| '"single"'           # returned when Nginx is running in the single process mode
---| '"signaller"'        # returned when Nginx is running as a signaller process

--- Returns the type of the current NGINX process.
---
---@return ngx.process.type type
function process.type() end


--- Signals the current NGINX worker process to quit gracefully, after all the
--- timers have expired (in time or expired prematurely).
---
--- Note that this API function simply sets the nginx global C variable
--- `ngx_quit` to signal the nginx event loop directly. No UNIX signals or IPC
--- are involved here.
function process.signal_graceful_exit() end


return process