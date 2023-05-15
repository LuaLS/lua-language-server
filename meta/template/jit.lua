---#if not JIT then DISABLE() end
---@meta jit

---@version JIT
---@class jitlib
---@field version     string
---@field version_num number
---@field os          'Windows'|'Linux'|'OSX'|'BSD'|'POSIX'|'Other'
---@field arch        'x86'|'x64'|'arm'|'arm64'|'arm64be'|'ppc'|'ppc64'|'ppc64le'|'mips'|'mipsel'|'mips64'|'mips64el'|string
jit = {}

---@overload fun(...):...
---@param func       function|boolean
---@param recursive? boolean
function jit.on(func, recursive)
end

---@overload fun(...):...
---@param func       function|boolean
---@param recursive? boolean
function jit.off(func, recursive)
end

---@overload fun(...):...
---@overload fun(tr: number)
---@param func       function|boolean
---@param recursive? boolean
function jit.flush(func, recursive)
end

---@return boolean status
---@return string ...
---@nodiscard
function jit.status()
end

jit.opt = {}

---@param ... any flags
function jit.opt.start(...)
end

return jit
