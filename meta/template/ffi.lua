---@meta

---@class ffi.namespace*: table

---@class ffi.cdecl*: string
---@class ffi.ctype*: userdata
local ctype
---@class ffi.cdata*: userdata
---@alias ffi.ct*     ffi.cdecl*|ffi.ctype*|ffi.cdata*
---@class ffi.cb*:    userdata
local cb
---@class ffi.VLA*:   userdata
---@class ffi.VLS*:   userdata

---@version JIT
---@class ffi*
---@field C    ffi.namespace*
---@field os   string
---@field arch string
local ffi = {}

---@param def string
function ffi.cdef(def) end

---@param name    string
---@param global? boolean
---@return ffi.namespace* clib
function ffi.load(name, global) end

---@param ct     ffi.ct*
---@param nelem? integer
---@param init?  any
---@return ffi.cdata* cdata
function ffi.new(ct, nelem, init, ...) end

---@param nelem? integer
---@param init?  any
---@return ffi.cdata* cdata
function ctype(nelem, init, ...) end

---@param ct ffi.ct*
---@return ffi.ctype* ctype
function ffi.typeof(ct) end

---@param ct   ffi.ct*
---@param init any
---@return ffi.cdata* cdata
function ffi.cast(ct, init) end

---@param ct        ffi.ct*
---@param metatable table
---@return ffi.ctype* ctype
function ffi.metatype(ct, metatable) end

---@param cdata     ffi.cdata*
---@param finalizer function
---@return ffi.cdata* cdata
function ffi.gc(cdata, finalizer) end

---@param ct     ffi.ct*
---@param nelem? integer
---@return integer|nil size
function ffi.sizeof(ct, nelem) end

---@param ct ffi.ct*
---@return integer align
function ffi.alignof(ct) end

---@param ct    ffi.ct*
---@param field string
---@return integer  ofs
---@return integer? bpos
---@return integer? bsize
function ffi.offsetof(ct, field) end

---@param ct  ffi.ct*
---@param obj any
---@return boolean status
function ffi.istype(ct, obj) end

---@param newerr? integer
---@return integer err
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
