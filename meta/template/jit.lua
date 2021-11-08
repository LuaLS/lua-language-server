---#if not JIT then DISABLE() end
---@meta

---@version JIT
---@class jitlib
---@field version     string
---@field version_num number
---@field os          string
---@field arch        string
jit = {}

---@overload fun()
---@param func       function|boolean
---@param recursive? boolean
function jit.on(func, recursive) end

---@overload fun()
---@param func       function|boolean
---@param recursive? boolean
function jit.off(func, recursive) end

---@overload fun()
---@overload fun(tr: number)
---@param func       function|boolean
---@param recursive? boolean
function jit.flush(func, recursive) end

---@return boolean status
---@return ...
---@nodiscard
function jit.status() end

return jit
