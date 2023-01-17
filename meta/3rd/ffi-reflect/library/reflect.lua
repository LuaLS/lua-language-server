---@meta

---@alias ffi.typeinfo.what "int"
---|"void"
---|"float"
---|"enum"
---|"constant"
---|"ptr"
---|"ref"
---|"array"
---|"struct"
---|"union"
---|"func"
---|"field"
---|"bitfield"
---|"typedef"

---@class ffi.typeinfo
---@field what ffi.typeinfo.what

---@class ffi.enuminfo : ffi.typeinfo
---@field name string?
---@field size number|string
---@field alignment number
---@field type ffi.typeinfo
local enuminfo = {}

---@return ffi.constantinfo[]
function enuminfo:values()
end

---@return ffi.constantinfo
function enuminfo:value(name_or_index)
end

---@class ffi.funcinfo : ffi.typeinfo
---@field name string?
---@field sym_name string?
---@field return_type ffi.funcinfo
---@field nargs integer
---@field vararg boolean
---@field sse_reg_params boolean
---@field convention "cdecl"|"thiscall"|"fastcall"|"stdcall"
local funcinfo = {}

---@return ffi.fieldinfo[]
function funcinfo:arguments()
end

---@return ffi.fieldinfo
function funcinfo:argument(name_or_index)
end

---@class ffi.unioninfo : ffi.typeinfo
---@field name string?
---@field size integer
---@field alignment number
---@field const boolean
---@field volatile boolean
---@field transparent boolean
local unioninfo = {}

---@return ffi.typeinfo[]
function unioninfo:members()
end

---@return ffi.typeinfo
function unioninfo:member(name_or_index)
end

---@class ffi.structinfo : ffi.unioninfo
---@field vla boolean

---@class ffi.floatinfo : ffi.typeinfo
---@field size integer
---@field alignment number
---@field const boolean
---@field volatile boolean

---@alias ffi.voidinfo ffi.floatinfo

---@class ffi.intinfo : ffi.floatinfo
---@field bool boolean
---@field unsigned boolean
---@field long boolean

---@class ffi.constantinfo : ffi.typeinfo
---@field name string?
---@field type ffi.typeinfo
---@field value integer

---@class ffi.ptrinfo : ffi.typeinfo
---@field size integer
---@field alignment number
---@field const boolean
---@field volatile boolean
---@field element_type ffi.typeinfo

---@alias ffi.refinfo ffi.ptrinfo

---@class ffi.arrayinfo : ffi.ptrinfo
---@field vla boolean
---@field vector boolean
---@field complex boolean

---@class ffi.fieldinfo : ffi.typeinfo
---@field name string?
---@field offset number
---@field type ffi.typeinfo

---@class ffi.bitfield : ffi.fieldinfo
---@field size integer|string

local reflect = {}

---reflection cdata c defined
---@param v ffi.cdata*
---@return ffi.typeinfo
function reflect.typeof(v)
end

---try get cdata metatable
---@param v ffi.cdata*
---@return table
function reflect.getmetatable(v)
end

return reflect