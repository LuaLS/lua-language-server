---#if not JIT then DISABLE() end
---@meta ffi

---@class ffi.namespace*: table
---@field [string] function

---@class ffi.ctype*: userdata
---@overload fun(init?: any, ...): ffi.cdata*
---@overload fun(nelem?: integer, init?: any, ...): ffi.cdata*
local ctype

---@class ffi.cdecl*: string
---@class ffi.cdata*: userdata
---@alias ffi.ct*     ffi.ctype*|ffi.cdecl*|ffi.cdata*
---@class ffi.cb*:    ffi.cdata*
local cb
---@class ffi.VLA*:   userdata
---@class ffi.VLS*:   userdata

---@version JIT
---@class ffilib
---@field C    ffi.namespace*
---@field os   string
---@field arch string
local ffi = {}

---@param def     string
---@param params? any
function ffi.cdef(def, params, ...) end

---@param name    string
---@param global? boolean
---@return ffi.namespace* clib
---@nodiscard
function ffi.load(name, global) end

---@overload fun(ct: ffi.ct*, init: any, ...)
---@param ct     ffi.ct*
---@param nelem? integer
---@param init?  any
---@return ffi.cdata* cdata
---@nodiscard
function ffi.new(ct, nelem, init, ...) end

---@param ct      ffi.ct*
---@param params? any
---@return ffi.ctype* ctype
---@nodiscard
function ffi.typeof(ct, params, ...) end

---@param ct   ffi.ct*
---@param init any
---@return ffi.cdata* cdata
---@nodiscard
function ffi.cast(ct, init) end

---@param ct        ffi.ct*
---@param metatable table
---@return ffi.ctype* ctype
function ffi.metatype(ct, metatable) end

---@param cdata     ffi.cdata*
---@param finalizer? function
---@return ffi.cdata* cdata
function ffi.gc(cdata, finalizer) end

---@param ct     ffi.ct*
---@param nelem? integer
---@return integer|nil size
---@nodiscard
function ffi.sizeof(ct, nelem) end

---@param ct ffi.ct*
---@return integer align
---@nodiscard
function ffi.alignof(ct) end

---@param ct    ffi.ct*
---@param field string
---@return integer  ofs
---@return integer? bpos
---@return integer? bsize
---@nodiscard
function ffi.offsetof(ct, field) end

---@param ct  ffi.ct*
---@param obj any
---@return boolean status
---@nodiscard
function ffi.istype(ct, obj) end

---@param newerr? integer
---@return integer err
---@nodiscard
function ffi.errno(newerr) end

---@param ptr  any
---@param len? integer
---@return string str
function ffi.string(ptr, len) end

---@overload fun(dst: any, str: string)
---@param dst any
---@param src any
---@param len integer
function ffi.copy(dst, src, len) end

---@param dst any
---@param len integer
---@param c?  any
function ffi.fill(dst, len, c) end

---@param param string
---@return boolean status
function ffi.abi(param) end

function cb:free() end

---@param func function
function cb:set(func) end

return ffi
