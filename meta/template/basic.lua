---@meta _

---#DES 'arg'
---@type string[]
arg = {}

---#DES 'assert'
---@generic T
---@param v? T
---@param message? any
---@param ... any
---@return T
---@return any ...
function assert(v, message, ...) end

---@alias gcoptions
---|>"collect"      # ---#DESTAIL 'cgopt.collect'
---| "stop"         # ---#DESTAIL 'cgopt.stop'
---| "restart"      # ---#DESTAIL 'cgopt.restart'
---| "count"        # ---#DESTAIL 'cgopt.count'
---| "step"         # ---#DESTAIL 'cgopt.step'
---| "isrunning"    # ---#DESTAIL 'cgopt.isrunning'
---#if VERSION >= 5.4 then
---| "incremental"  # ---#DESTAIL 'cgopt.incremental'
---| "generational" # ---#DESTAIL 'cgopt.generational'
---#else
---| "setpause"     # ---#DESTAIL 'cgopt.setpause'
---| "setstepmul"   # ---#DESTAIL 'cgopt.setstepmul'
---#end

---#if VERSION >= 5.4 then
---#DES 'collectgarbage'
---@param opt? gcoptions
---@param ... any
---@return any
function collectgarbage(opt, ...) end
---#else
---#DES 'collectgarbage'
---@param opt? gcoptions
---@param arg? integer
---@return any
function collectgarbage(opt, arg) end
---#end

---#DES 'dofile'
---@param filename? string
---@return any ...
function dofile(filename) end

---#DES 'error'
---@param message any
---@param level?  integer
function error(message, level) end

---#DES '_G'
---@class _G
_G = {}

---@version 5.1
---#DES 'getfenv'
---@param f? integer|async fun(...):...
---@return table
---@nodiscard
function getfenv(f) end

---#DES 'getmetatable'
---@param object any
---@return table metatable
---@nodiscard
function getmetatable(object) end

---#DES 'ipairs'
---@generic T: table, V
---@param t T
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
function ipairs(t) end

---@alias loadmode
---| "b"  # ---#DESTAIL 'loadmode.b'
---| "t"  # ---#DESTAIL 'loadmode.t'
---|>"bt" # ---#DESTAIL 'loadmode.bt'

---#if VERSION <= 5.1 and not JIT then
---#DES 'load<5.1'
---@param func       function
---@param chunkname? string
---@return function?
---@return string?   error_message
---@nodiscard
function load(func, chunkname) end
---#else
---#DES 'load>5.2'
---@param chunk      string|function
---@param chunkname? string
---@param mode?      loadmode
---@param env?       table
---@return function?
---@return string?   error_message
---@nodiscard
function load(chunk, chunkname, mode, env) end
---#end

---#if VERSION <= 5.1 and not JIT then
---#DES 'loadfile'
---@param filename? string
---@return function?
---@return string?  error_message
---@nodiscard
function loadfile(filename) end
---#else
---#DES 'loadfile'
---@param filename? string
---@param mode?     loadmode
---@param env?      table
---@return function?
---@return string?  error_message
---@nodiscard
function loadfile(filename, mode, env) end
---#end

---@version 5.1
---#DES 'loadstring'
---@param text       string
---@param chunkname? string
---@return function?
---@return string?   error_message
---@nodiscard
function loadstring(text, chunkname) end

---@version 5.1
---@param proxy boolean|table|userdata
---@return userdata
---@nodiscard
function newproxy(proxy) end

---@version 5.1
---#DES 'module'
---@param name string
---@param ...  any
function module(name, ...) end

---#DES 'next'
---@generic K, V
---@param table table<K, V>
---@param index? K
---@return K?
---@return V?
---@nodiscard
function next(table, index) end

---#DES 'pairs'
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
function pairs(t) end

---#DES 'pcall'
---#if VERSION == 5.1 and not JIT then
---@param f     function
---#else
---@param f     async fun(...):...
---#end
---@param arg1? any
---@param ...   any
---@return boolean success
---@return any result
---@return any ...
function pcall(f, arg1, ...) end

---#DES 'print'
---@param ... any
function print(...) end

---#DES 'rawequal'
---@param v1 any
---@param v2 any
---@return boolean
---@nodiscard
function rawequal(v1, v2) end

---#DES 'rawget'
---@param table table
---@param index any
---@return any
---@nodiscard
function rawget(table, index) end

---#DES 'rawlen'
---@param v table|string
---@return integer len
---@nodiscard
function rawlen(v) end

---#DES 'rawset'
---@param table table
---@param index any
---@param value any
---@return table
function rawset(table, index, value) end

---#DES 'select'
---@param index integer|"#"
---@param ...   any
---@return any
---@nodiscard
function select(index, ...) end

---@version 5.1
---#DES 'setfenv'
---@param f     (async fun(...):...)|integer
---@param table table
---@return function
function setfenv(f, table) end


---@class metatable
---@field __mode 'v'|'k'|'kv'|nil
---@field __metatable any|nil
---@field __tostring (fun(t):string)|nil
---@field __gc fun(t)|nil
---@field __add (fun(t1,t2):any)|nil
---@field __sub (fun(t1,t2):any)|nil
---@field __mul (fun(t1,t2):any)|nil
---@field __div (fun(t1,t2):any)|nil
---@field __mod (fun(t1,t2):any)|nil
---@field __pow (fun(t1,t2):any)|nil
---@field __unm (fun(t):any)|nil
---#if VERSION >= 5.3 then
---@field __idiv (fun(t1,t2):any)|nil
---@field __band (fun(t1,t2):any)|nil
---@field __bor (fun(t1,t2):any)|nil
---@field __bxor (fun(t1,t2):any)|nil
---@field __bnot (fun(t):any)|nil
---@field __shl (fun(t1,t2):any)|nil
---@field __shr (fun(t1,t2):any)|nil
---#end
---@field __concat (fun(t1,t2):any)|nil
---@field __len (fun(t):integer)|nil
---@field __eq (fun(t1,t2):boolean)|nil
---@field __lt (fun(t1,t2):boolean)|nil
---@field __le (fun(t1,t2):boolean)|nil
---@field __index table|(fun(t,k):any)|nil
---@field __newindex table|fun(t,k,v)|nil
---@field __call (fun(t,...):...)|nil
---#if VERSION > 5.1 or VERSION == JIT then
---@field __pairs (fun(t):((fun(t,k,v):any,any),any,any))|nil
---#end
---#if VERSION == JIT or VERSION == 5.2 then
---@field __ipairs (fun(t):(fun(t,k,v):(integer|nil),any))|nil
---#end
---#if VERSION >= 5.4 then
---@field __close (fun(t,errobj):any)|nil
---#end

---#DES 'setmetatable'
---@param table      table
---@param metatable? metatable|table
---@return table
function setmetatable(table, metatable) end

---#DES 'tonumber'
---@overload fun(e: string, base: integer):integer
---@param e any
---@return number?
---@nodiscard
function tonumber(e) end

---#DES 'tostring'
---@param v any
---@return string
---@nodiscard
function tostring(v) end

---@alias type
---| "nil"
---| "number"
---| "string"
---| "boolean"
---| "table"
---| "function"
---| "thread"
---| "userdata"
---#if VERSION == JIT then
---| "cdata"
---#end

---#DES 'type'
---@param v any
---@return type type
---@nodiscard
function type(v) end

---#DES '_VERSION'
---#if VERSION == 5.1 then
_VERSION = "Lua 5.1"
---#elseif VERSION == 5.2 then
_VERSION = "Lua 5.2"
---#elseif VERSION == 5.3 then
_VERSION = "Lua 5.3"
---#elseif VERSION == 5.4 then
_VERSION = "Lua 5.4"
---#end

---@version >5.4
---#DES 'warn'
---@param message string
---@param ...     any
function warn(message, ...) end

---#if VERSION == 5.1 and not JIT then
---#DES 'xpcall=5.1'
---@param f     function
---@param err   function
---@return boolean success
---@return any result
---@return any ...
function xpcall(f, err) end
---#else
---#DES 'xpcall>5.2'
---@param f     async fun(...):...
---@param msgh  function
---@param arg1? any
---@param ...   any
---@return boolean success
---@return any result
---@return any ...
function xpcall(f, msgh, arg1, ...) end
---#end

---@version 5.1
---#DES 'unpack'
---@generic T1, T2, T3, T4, T5, T6, T7, T8, T9, T10
---@param list {
--- [1]?: T1,
--- [2]?: T2,
--- [3]?: T3,
--- [4]?: T4,
--- [5]?: T5,
--- [6]?: T6,
--- [7]?: T7,
--- [8]?: T8,
--- [9]?: T9,
--- [10]?: T10,
---}
---@param i?   integer
---@param j?   integer
---@return T1, T2, T3, T4, T5, T6, T7, T8, T9, T10
---@nodiscard
function unpack(list, i, j) end

---@version 5.1
---@generic T1, T2, T3, T4, T5, T6, T7, T8, T9
---@param list {[1]: T1, [2]: T2, [3]: T3, [4]: T4, [5]: T5, [6]: T6, [7]: T7, [8]: T8, [9]: T9 }
---@return T1, T2, T3, T4, T5, T6, T7, T8, T9
---@nodiscard
function unpack(list) end
