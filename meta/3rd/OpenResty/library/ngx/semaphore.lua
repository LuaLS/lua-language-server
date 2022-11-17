---@meta

---@class ngx.semaphore
--- sem is the internal c handler
---@field sem userdata
local semaphore = {
  version = require("resty.core.base").version,
}

---Creates and returns a new semaphore instance.
---
---@param  n?             integer   the number of resources the semaphore will begin with (default 0)
---@return ngx.semaphore? semaphore
---@return string?        error
function semaphore.new(n) end


--- Returns the number of resources readily available in the sema semaphore
--- instance (if any).
---
--- When the returned number is negative, it means the number of "light threads"
--- waiting on this semaphore.
---
---@return integer count
function semaphore:count() end


--- Requests a resource from the semaphore instance.
---
--- Returns `true` immediately when there is resources available for the current
--- running "light thread". Otherwise the current "light thread" will enter the
--- waiting queue and yield execution. The current "light thread" will be
--- automatically waken up and the wait function call will return true when there
--- is resources available for it, or return nil and a string describing the error
--- in case of failure (like "timeout").
---
--- The timeout argument specifies the maximum time this function call should
--- wait for (in seconds).
---
--- When the timeout argument is 0, it means "no wait", that is, when there is
--- no readily available "resources" for the current running "light thread",
--- this wait function call returns immediately nil and the error string "timeout".
---
--- You can specify millisecond precision in the timeout value by using floating
--- point numbers like 0.001 (which means 1ms).
---
--- "Light threads" created by different contexts (like request handlers) can
--- wait on the same semaphore instance without problem.
---
---@param  timeout? number
---@return boolean  ok
---@return string|'"timeout"'  error
function semaphore:wait(timeout) end


--- Releases n (default to 1) "resources" to the semaphore instance.
---
--- This will not yield the current running "light thread".
---
--- At most n "light threads" will be waken up when the current running "light thread" later yields (or terminates).
---
---@param n? integer
function semaphore:post(n) end


return semaphore