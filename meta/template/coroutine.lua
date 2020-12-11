---@meta

---#DES 'coroutine'
---@class coroutine*
coroutine = {}

---#DES 'coroutine.create'
---@param f function
---@return thread
function coroutine.create(f) end

---#if VERSION >= 5.4 then
---#DES 'coroutine.isyieldable>5.4'
---@param co? thread
---@return boolean
function coroutine.isyieldable(co) end
---#else
---#DES 'coroutine.isyieldable'
---@return boolean
function coroutine.isyieldable() end
---#end

---@version >5.4
---#DES 'coroutine.close'
---@param co thread
---@return boolean noerror
---@return any errorobject
function coroutine.close(co) end

---#DES 'coroutine.resume'
---@param co    thread
---@param val1? any
---@return boolean success
---@return any result
---@return ...
function coroutine.resume(co, val1, ...) end

---#DES 'coroutine.running'
---@return thread running
---@return boolean ismain
function coroutine.running() end

---#DES 'coroutine.status'
---@param co thread
---@return
---| '"running"'   # ---#DESTAIL 'costatus.running'
---| '"suspended"' # ---#DESTAIL 'costatus.suspended'
---| '"normal"'    # ---#DESTAIL 'costatus.normal'
---| '"dead"'      # ---#DESTAIL 'costatus.dead'
function coroutine.status(co) end

---#DES 'coroutine.wrap'
---@param f function
---@return fun(...):...
function coroutine.wrap(f) end

---#DES 'coroutine.yield'
---@return ...
function coroutine.yield(...) end

return coroutine
