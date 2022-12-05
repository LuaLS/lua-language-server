---@meta

local shell = {
    version = 0.03,
}


--- Runs a shell command, `cmd`, with an optional stdin.
---
--- The `cmd` argument can either be a single string value (e.g. `"echo 'hello,
--- world'"`) or an array-like Lua table (e.g. `{"echo", "hello, world"}`). The
--- former is equivalent to `{"/bin/sh", "-c", "echo 'hello, world'"}`, but simpler
--- and slightly faster.
---
--- When the `stdin` argument is `nil` or `""`, the stdin device will immediately
--- be closed.
---
--- The `timeout` argument specifies the timeout threshold (in ms) for
--- stderr/stdout reading timeout, stdin writing timeout, and process waiting
--- timeout. The default is 10 seconds as per https://github.com/openresty/lua-resty-core/blob/master/lib/ngx/pipe.md#set_timeouts
---
--- The `max_size` argument specifies the maximum size allowed for each output
--- data stream of stdout and stderr. When exceeding the limit, the `run()`
--- function will immediately stop reading any more data from the stream and return
--- an error string in the `reason` return value: `"failed to read stdout: too much
--- data"`.
---
--- Upon terminating successfully (with a zero exit status), `ok` will be `true`,
--- `reason` will be `"exit"`, and `status` will hold the sub-process exit status.
---
--- Upon terminating abnormally (non-zero exit status), `ok` will be `false`,
--- `reason` will be `"exit"`, and `status` will hold the sub-process exit status.
---
--- Upon exceeding a timeout threshold or any other unexpected error, `ok` will be
--- `nil`, and `reason` will be a string describing the error.
---
--- When a timeout threshold is exceeded, the sub-process will be terminated as
--- such:
---
--- 1. first, by receiving a `SIGTERM` signal from this library,
--- 2. then, after 1ms, by receiving a `SIGKILL` signal from this library.
---
--- Note that child processes of the sub-process (if any) will not be terminated.
--- You may need to terminate these processes yourself.
---
--- When the sub-process is terminated by a UNIX signal, the `reason` return value
--- will be `"signal"` and the `status` return value will hold the signal number.
---
---@param cmd string|string[]
---@param stdin? string
---@param timeout? number
---@param max_size? number
---
---@return boolean ok
---@return string? stdout
---@return string? stderr
---@return string|'"exit"'|'"signal"' reason
---@return number? status
function shell.run(cmd, stdin, timeout, max_size) end


return shell