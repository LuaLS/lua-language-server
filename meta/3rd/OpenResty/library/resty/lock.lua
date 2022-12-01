---@meta

--- lua-resty-lock
---
--- https://github.com/openresty/lua-resty-lock
---
---@class resty.lock : table
local lock = {
  _VERSION = "0.08",
}


---@class resty.lock.opts : table
---
--- Specifies expiration time (in seconds) for the lock entry in the shared memory
--- dictionary. You can specify up to 0.001 seconds. Default to 30 (seconds). Even
--- if the invoker does not call unlock or the object holding the lock is not GC'd,
--- the lock will be released after this time. So deadlock won't happen even when the
--- worker process holding the lock crashes.
---@field exptime  number
---
--- Specifies the maximal waiting time (in seconds) for the lock method calls on
--- the current object instance. You can specify up to 0.001 seconds. Default to 5
--- (seconds). This option value cannot be bigger than `exptime`. This timeout is
--- to prevent a lock method call from waiting forever. You can specify 0 to make
--- the lock method return immediately without waiting if it cannot acquire the
--- lock right away.
---@field timeout  number
---
--- Specifies the initial step (in seconds) of sleeping when waiting for the lock.
--- Default to 0.001 (seconds). When the lock method is waiting on a busy lock, it
--- sleeps by steps. The step size is increased by a ratio (specified by the ratio
--- option) until reaching the step size limit (specified by the max_step option).
---@field step     number
---
--- Specifies the step increasing ratio. Default to 2, that is, the step size
--- doubles at each waiting iteration.
---@field ratio    number
---
--- Specifies the maximal step size (i.e., sleep interval, in seconds) allowed.
--- See also the step and ratio options). Default to 0.5 (seconds).
---@field max_step number


--- Creates a new lock object instance by specifying the shared dictionary name
--- (created by `lua_shared_dict`) and an optional options table `opts`.
---
---@param  dict_name   string
---@param  opts?       resty.lock.opts
---@return resty.lock? lock
---@return string?     err
function lock.new(_, dict_name, opts) end

--- Tries to lock a key across all the Nginx worker processes in the current
--- NGINX server instance. Different keys are different locks.
---
--- The length of the key string must not be larger than 65535 bytes.
---
--- Returns the waiting time (in seconds) if the lock is successfully acquired.
--- Otherwise returns `nil` and a string describing the error.
---
--- The waiting time is not from the wallclock, but rather is from simply adding
--- up all the waiting "steps". A nonzero elapsed return value indicates that
--- someone else has just hold this lock. But a zero return value cannot gurantee
--- that no one else has just acquired and released the lock.
---
--- When this method is waiting on fetching the lock, no operating system threads
--- will be blocked and the current Lua "light thread" will be automatically yielded
--- behind the scene.
---
--- It is strongly recommended to always call the unlock() method to actively
--- release the lock as soon as possible.
---
--- If the `unlock()` method is never called after this method call, the lock
--- will get released when
---
---   The current `resty.lock` object instance is collected automatically by the Lua GC.
---   OR
---   The exptime for the lock entry is reached.
---
--- Common errors for this method call is
---
---   "timeout" : The timeout threshold specified by the timeout option of the new method is exceeded.
---   "locked" : The current `resty.lock` object instance is already holding a lock (not necessarily of the same key).
---
--- Other possible errors are from ngx_lua's shared dictionary API.
---
--- It is required to create different `resty.lock` instances for multiple
--- simultaneous locks (i.e., those around different keys).
---
---@param  key     string
---@return number? elapsed
---@return string? error
function lock:lock(key) end

--- Releases the lock held by the current `resty.lock` object instance.
---
--- Returns 1 on success. Returns `nil` and a string describing the error otherwise.
---
--- If you call unlock when no lock is currently held, the error "unlocked" will
--- be returned.
---
---@return boolean ok
---@return string? error
function lock:unlock() end

--- Sets the TTL of the lock held by the current `resty.lock` object instance.
--- This will reset the timeout of the lock to timeout seconds if it is given,
--- otherwise the timeout provided while calling new will be used.
---
--- Note that the timeout supplied inside this function is independent from the
--- timeout provided while calling new. Calling `expire()` will not change the
--- timeout value specified inside new and subsequent `expire(nil)` call will
--- still use the timeout number from new.
---
--- Returns true on success. Returns `nil` and a string describing the error
--- otherwise.
---
--- If you call expire when no lock is currently held, the error "unlocked" will
--- be returned.
---
---@param  timeout? number
---@return boolean  ok
---@return string?  error
function lock:expire(timeout) end

return lock