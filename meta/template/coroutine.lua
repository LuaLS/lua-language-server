---@meta

---#DES 'coroutine'
---@class coroutinelib
coroutine = {}

---#DES 'coroutine.create'
---@param f async fun()
---@return thread
---@nodiscard
function coroutine.create(f) end

---#if VERSION >= 5.4 then
---#DES 'coroutine.isyieldable>5.4'
---@param co? thread
---@return boolean
---@nodiscard
function coroutine.isyieldable(co) end
---#else
---#DES 'coroutine.isyieldable'
---@return boolean
---@nodiscard
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
---@nodiscard
function coroutine.running() end

---#DES 'coroutine.status'
---@param co thread
---@return
---| '"running"'   # ---#DESTAIL 'costatus.running'
---| '"suspended"' # ---#DESTAIL 'costatus.suspended'
---| '"normal"'    # ---#DESTAIL 'costatus.normal'
---| '"dead"'      # ---#DESTAIL 'costatus.dead'
---@nodiscard
function coroutine.status(co) end

---#DES 'coroutine.wrap'
---@param f async fun()
---@return fun()
---@nodiscard
function coroutine.wrap(f) end

---#DES 'coroutine.yield'
---@async
---@return ...
function coroutine.yield(...) end

return coroutine
