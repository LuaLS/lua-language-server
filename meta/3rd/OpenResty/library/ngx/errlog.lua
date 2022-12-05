---@meta
local errlog = {
  version = require("resty.core.base").version,
}

--- Return the nginx core's error log filter level (defined via the `error_log` configuration directive in nginx.conf) as an integer value.
---@return ngx.log.level
function errlog.get_sys_filter_level() end


--- Specifies the filter log level, only to capture and buffer the error logs with a log level no lower than the specified level.
---
--- If we don't call this API, all of the error logs will be captured by default.
---
--- In case of error, `nil` will be returned as well as a string describing the error.
---
--- This API should always work with directive `lua_capture_error_log`.
---
---@param  level   ngx.log.level
---@return boolean ok
---@return string? err
function errlog.set_filter_level(level) end


--- Fetches the captured nginx error log messages if any in the global data buffer specified by ngx_lua's `lua_capture_error_log` directive. Upon return, this Lua function also removes those messages from that global capturing buffer to make room for future new error log data.
---
--- In case of error, nil will be returned as well as a string describing the error.
---
--- The optional max argument is a number that when specified, will prevent `get_logs()` from adding more than max messages to the res array.
---
---```lua
--- for i = 1, 20 do
---    ngx.log(ngx.ERR, "test")
--- end
---
--- local errlog = require "ngx.errlog"
--- local res = errlog.get_logs(10)
--- -- the number of messages in the `res` table is 10 and the `res` table
--- -- has 30 elements.
---```
---
--- The resulting table has the following structure:
---
---```
--- { level1, time1, msg1, level2, time2, msg2, ... }
---```
---
--- The levelX values are constants defined below:
---
--- https://github.com/openresty/lua-nginx-module/#nginx-log-level-constants
---
--- The timeX values are UNIX timestamps in seconds with millisecond precision. The sub-second part is presented as the decimal part. The time format is exactly the same as the value returned by ngx.now. It is also subject to NGINX core's time caching.
---
--- The msgX values are the error log message texts.
---
--- So to traverse this array, the user can use a loop like this:
---
---```lua
---
--- for i = 1, #res, 3 do
---     local level = res[i]
---     if not level then
---         break
---     end
---
---     local time = res[i + 1]
---     local msg = res[i + 2]
---
---     -- handle the current message with log level in `level`,
---     -- log time in `time`, and log message body in `msg`.
--- end
---```
---
--- Specifying max <= 0 disables this behavior, meaning that the number of results won't be limited.
---
--- The optional 2th argument res can be a user-supplied Lua table to hold the result instead of creating a brand new table. This can avoid unnecessary table dynamic allocations on hot Lua code paths. It is used like this:
---
---```lua
--- local errlog = require "ngx.errlog"
--- local new_tab = require "table.new"
---
--- local buffer = new_tab(100 * 3, 0)  -- for 100 messages
---
--- local errlog = require "ngx.errlog"
--- local res, err = errlog.get_logs(0, buffer)
--- if res then
---     -- res is the same table as `buffer`
---     for i = 1, #res, 3 do
---         local level = res[i]
---         if not level then
---             break
---         end
---         local time = res[i + 1]
---         local msg  = res[i + 2]
---         ...
---     end
--- end
---```
---
--- When provided with a res table, `get_logs()` won't clear the table for performance reasons, but will rather insert a trailing nil value after the last table element.
---
--- When the trailing nil is not enough for your purpose, you should clear the table yourself before feeding it into the `get_logs()` function.
---
---@param  max     number
---@param  res?    table
---@return table?  res
---@return string? err
function errlog.get_logs(max, res) end

--- Log msg to the error logs with the given logging level.
---
--- Just like the ngx.log API, the log_level argument can take constants like ngx.ERR and ngx.WARN. Check out Nginx log level constants for details.
---
--- However, unlike the ngx.log API which accepts variadic arguments, this function only accepts a single string as its second argument msg.
---
--- This function differs from ngx.log in the way that it will not prefix the written logs with any sort of debug information (such as the caller's file and line number).
---@param level ngx.log.level
---@param msg   string
function errlog.raw_log(level, msg) end


return errlog