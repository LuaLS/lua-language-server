---@meta

---@class coroutine*
coroutine = {}

---@param f function
---@return thread
function coroutine.create(f) end

---@param co? thread
---@return boolean
function coroutine.isyieldable(co) end

---@param co thread
---@return boolean noerror
---@return any errorobject
function coroutine.close(co) end

---@param co    thread
---@param val1? any
---@return boolean success
---@return any result
---@return ...
function coroutine.resume(co, val1, ...) end

---@return thread running
---@return boolean ismain
function coroutine.running() end

---@param co thread
---@return
---| '"running"'
---| '"suspended"'
---| '"normal"'
---| '"dead"'
function coroutine.status(co) end

---@param f function
---@return ...
function coroutine.wrap(f) end

---@return ...
function coroutine.yield(...) end

return coroutine
