---@meta
local pipe={}
pipe._gc_ref_c_opt="-c"

pipe.version = require("resty.core.base").version

--- Creates and returns a new sub-process instance we can communicate with later.
---
--- For example:
---
---```lua
--- local ngx_pipe = require "ngx.pipe"
--- local proc, err = ngx_pipe.spawn({"sh", "-c", "sleep 0.1 && exit 2"})
--- if not proc then
---     ngx.say(err)
---     return
--- end
---```
---
--- In case of failure, this function returns nil and a string describing the error.
---
--- The sub-process will be killed via SIGKILL if it is still alive when the instance is collected by the garbage collector.
---
--- Note that args should either be a single level array-like Lua table with string values, or just a single string.
---
--- Some more examples:
---
---```lua
--- local proc, err = ngx_pipe.spawn({"ls", "-l"})
---
--- local proc, err = ngx_pipe.spawn({"perl", "-e", "print 'hello, wolrd'"})
---
---```
---
--- If args is specified as a string, it will be executed by the operating system shell, just like os.execute. The above example could thus be rewritten as:
---
---```lua
--- local ngx_pipe = require "ngx.pipe"
--- local proc, err = ngx_pipe.spawn("sleep 0.1 && exit 2")
--- if not proc then
---     ngx.say(err)
---     return
--- end
---```
---
--- In the shell mode, you should be very careful about shell injection attacks when interpolating variables into command string, especially variables from untrusted sources. Please make sure that you escape those variables while assembling the command string. For this reason, it is highly recommended to use the multi-arguments form (args as a table) to specify each command-line argument explicitly.
---
--- Since by default, Nginx does not pass along the PATH system environment variable, you will need to configure the env PATH directive if you wish for it to be respected during the searching of sub-processes:
---
---```nginx
--- env PATH;
--- ...
--- content_by_lua_block {
---     local ngx_pipe = require "ngx.pipe"
---
---     local proc = ngx_pipe.spawn({'ls'})
--- }
---```
---
--- The optional table argument opts can be used to control the behavior of spawned processes. For instance:
---
---```lua
--- local opts = {
---     merge_stderr = true,
---     buffer_size = 256,
---     environ = {"PATH=/tmp/bin", "CWD=/tmp/work"}
--- }
--- local proc, err = ngx_pipe.spawn({"sh", "-c", ">&2 echo data"}, opts)
--- if not proc then
---     ngx.say(err)
---     return
--- end
---```
---
---
---@param  args           string[]|string
---@param  opts?          ngx.pipe.spawn.opts
---@return ngx.pipe.proc? proc
---@return string?        error
function pipe.spawn(args, opts) end


--- Options for ngx.pipe.spawn()
---
---@class ngx.pipe.spawn.opts : table
---
--- when set to true, the output to stderr will be redirected to stdout in the spawned process. This is similar to doing 2>&1 in a shell.
---@field merge_stderr boolean
---
--- specifies the buffer size used by reading operations, in bytes. The default buffer size is 4096.
---@field buffer_size  number
---
--- specifies environment variables for the spawned process. The value must be a single-level, array-like Lua table with string values.
---@field environ string[]
---
--- specifies the write timeout threshold, in milliseconds. The default threshold is 10000. If the threshold is 0, the write operation will never time out.
---@field write_timeout number
---
--- specifies the stdout read timeout threshold, in milliseconds. The default threshold is 10000. If the threshold is 0, the stdout read operation will never time out.
---@field stdout_read_timeout number
---
--- specifies the stderr read timeout threshold, in milliseconds. The default threshold is 10000. If the threshold is 0, the stderr read operation will never time out.
---@field stderr_read_timeout number
---
--- specifies the wait timeout threshold, in milliseconds. The default threshold is 10000. If the threshold is 0, the wait operation will never time out.
---@field wait_timeout number


---@class ngx.pipe.proc : table
local proc = {}

--- Respectively sets: the write timeout threshold, stdout read timeout threshold, stderr read timeout threshold, and wait timeout threshold. All timeouts are in milliseconds.
---
--- The default threshold for each timeout is 10 seconds.
---
--- If the specified timeout argument is `nil`, the corresponding timeout threshold will not be changed. For example:
---
---```lua
--- local proc, err = ngx_pipe.spawn({"sleep", "10s"})
---
--- -- only change the wait_timeout to 0.1 second.
--- proc:set_timeouts(nil, nil, nil, 100)
---
--- -- only change the send_timeout to 0.1 second.
--- proc:set_timeouts(100)
---```
---
--- If the specified timeout argument is 0, the corresponding operation will never time out.
---
---@param write_timeout?       number
---@param stdout_read_timeout? number
---@param stderr_read_timeout? number
---@param wait_timeout?        number
function proc:set_timeouts(write_timeout, stdout_read_timeout, stderr_read_timeout, wait_timeout) end

--- Waits until the current sub-process exits.
---
--- It is possible to control how long to wait via set_timeouts. The default timeout is 10 seconds.
---
--- If process exited with status code zero, the ok return value will be true.
---
--- If process exited abnormally, the ok return value will be false.
---
--- The second return value, reason, will be a string. Its values may be:
---
---     exit: the process exited by calling exit(3), _exit(2), or by returning from main(). In this case, status will be the exit code.
---     signal: the process was terminated by a signal. In this case, status will be the signal number.
---
--- Note that only one light thread can wait on a process at a time. If another light thread tries to wait on a process, the return values will be `nil` and the error string "pipe busy waiting".
---
--- If a thread tries to wait an exited process, the return values will be `nil` and the error string "exited".
---
---@return boolean             ok
---@return '"exit"'|'"signal"' reason
---@return number              status
function proc:wait() end


--- Returns the pid number of the sub-process.
---@return number pid
function proc:pid() end


--- Sends a signal to the sub-process.
---
--- Note that the signum argument should be signal's numerical value. If the specified signum is not a number, an error will be thrown.
---
--- You should use lua-resty-signal's `signum()` function to convert signal names to signal numbers in order to ensure portability of your application.
---
--- In case of success, this method returns true. Otherwise, it returns `nil` and a string describing the error.
---
--- Killing an exited sub-process will return `nil` and the error string "exited".
---
--- Sending an invalid signal to the process will return `nil` and the error string "invalid signal".
---
---@param  signum  integer
---@return boolean ok
---@return string? error
function proc:kill(signum) end

---Closes the specified direction of the current sub-process.
---
---The direction argument should be one of these three values: stdin, stdout and stderr.
---
---In case of success, this method returns true. Otherwise, it returns `nil` and a string describing the error.
---
---If the `merge_stderr` option is specified in spawn, closing the stderr direction will return `nil` and the error string "merged to stdout".
---
---Shutting down a direction when a light thread is waiting on it (such as during reading or writing) will abort the light thread and return true.
---
---Shutting down directions of an exited process will return `nil` and the error string "closed".
---
---It is fine to shut down the same direction of the same stream multiple times; no side effects are to be expected.
---
---@param direction '"stdin"'|'"stdout"'|'"stderr"'
---@return boolean ok
---@return string? error
function proc:shutdown(direction) end

--- Writes data to the current sub-process's stdin stream.
---
--- The data argument can be a string or a single level array-like Lua table with string values.
---
--- This method is a synchronous and non-blocking operation that will not return until all the data has been flushed to the sub-process's stdin buffer, or an error occurs.
---
--- In case of success, it returns the total number of bytes that have been sent. Otherwise, it returns `nil` and a string describing the error.
---
--- The timeout threshold of this write operation can be controlled by the `set_timeouts` method. The default timeout threshold is 10 seconds.
---
--- When a timeout occurs, the data may be partially written into the sub-process's stdin buffer and read by the sub-process.
---
--- Only one light thread is allowed to write to the sub-process at a time. If another light thread tries to write to it, this method will return `nil` and the error string "pipe busy writing".
---
--- If the write operation is aborted by the shutdown method, it will return `nil` and the error string "aborted".
---
--- Writing to an exited sub-process will return `nil` and the error string "closed".
---
---@param  data     string
---@return integer? nbytes
---@return string?  error
function proc:write(data) end

--- Reads all data from the current sub-process's stderr stream until it is closed.
---
--- This method is a synchronous and non-blocking operation, just like the write method.
---
--- The timeout threshold of this reading operation can be controlled by `set_timeouts`. The default timeout is 10 seconds.
---
--- In case of success, it returns the data received. Otherwise, it returns three values: `nil`, a string describing the error, and, optionally, the partial data received so far.
---
--- When `merge_stderr` is specified in spawn, calling `stderr_read_all` will return `nil` and the error string "merged to stdout".
---
--- Only one light thread is allowed to read from a sub-process's stderr or stdout stream at a time. If another thread tries to read from the same stream, this method will return `nil` and the error string "pipe busy reading".
---
--- If the reading operation is aborted by the shutdown method, it will return `nil` and the error string "aborted".
---
--- Streams for stdout and stderr are separated, so at most two light threads may be reading from a sub-process at a time (one for each stream).
---
--- The same way, a light thread may read from a stream while another light thread is writing to the sub-process stdin stream.
---
--- Reading from an exited process's stream will return `nil` and the error string "closed".
---
---@return string? data
---@return string? error
---@return string? partial
function proc:stderr_read_all() end

--- Similar to the `stderr_read_all` method, but reading from the stdout stream of the sub-process.
---@return string? data
---@return string? error
---@return string? partial
function proc:stdout_read_all() end

--- Reads from stderr like `stderr_read_all`, but only reads a single line of data.
---
--- When `merge_stderr` is specified in spawn, calling `stderr_read_line` will return `nil` plus the error string "merged to stdout".
---
--- When the data stream is truncated without a new-line character, it returns 3 values: `nil`, the error string "closed", and the partial data received so far.
---
--- The line should be terminated by a Line Feed (LF) character (ASCII 10), optionally preceded by a Carriage Return (CR) character (ASCII 13). The CR and LF characters are not included in the returned line data.
---@return string? data
---@return string? error
---@return string? partial
function proc:stderr_read_line() end

--- Similar to `stderr_read_line`, but reading from the stdout stream of the sub-process.
---@return string? data
---@return string? error
---@return string? partial
function proc:stdout_read_line() end

--- Reads from stderr like `stderr_read_all`, but only reads the specified number of bytes.
---
--- If `merge_stderr` is specified in spawn, calling `stderr_read_bytes` will return `nil` plus the error string "merged to stdout".
---
--- If the data stream is truncated (fewer bytes of data available than requested), this method returns 3 values: `nil`, the error string "closed", and the partial data string received so far.
---
---@param  len     number
---@return string? data
---@return string? error
---@return string? partial
function proc:stderr_read_bytes(len) end

--- Similar to `stderr_read_bytes`, but reading from the stdout stream of the sub-process.
---
---@param  len     number
---@return string? data
---@return string? error
---@return string? partial
function proc:stdout_read_bytes(len) end


--- Reads from stderr like `stderr_read_all`, but returns immediately when any amount of data is received.
---
--- At most max bytes are received.
---
--- If `merge_stderr` is specified in spawn, calling `stderr_read_any` will return `nil` plus the error string "merged to stdout".
---
--- If the received data is more than `max` bytes, this method will return with exactly `max` bytes of data. The remaining data in the underlying receive buffer can be fetched with a subsequent reading operation.
---@param  max     number
---@return string? data
---@return string? error
function proc:stderr_read_any(max) end

--- Similar to `stderr_read_any`, but reading from the stdout stream of the sub-process.
---
---@param  max     number
---@return string? data
---@return string? error
function proc:stdout_read_any(max) end

return pipe