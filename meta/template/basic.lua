---@meta

---#DES 'arg'
---@type string[]
arg = {}

---#DES 'assert'
---@generic T
---@param v T
---@param message any
---@return T
function assert(v, message) end

---@alias cgopt
---|>'"collect"'      # ---#DESTAIL 'cgopt.collect'
---| '"stop"'         # ---#DESTAIL 'cgopt.stop'
---| '"restart"'      # ---#DESTAIL 'cgopt.restart'
---| '"count"'        # ---#DESTAIL 'cgopt.count'
---| '"step"'         # ---#DESTAIL 'cgopt.step'
---| '"isrunning"'    # ---#DESTAIL 'cgopt.isrunning'
---#if VERSION >= 5.4 then
---| '"incremental"'  # ---#DESTAIL 'cgopt.incremental'
---| '"generational"' # ---#DESTAIL 'cgopt.generational'
---#else
---| '"setpause"'     # ---#DESTAIL 'cgopt.setpause'
---| '"setstepmul"'   # ---#DESTAIL 'cgopt.setstepmul'
---#end

---#if VERSION >= 5.4 then
---#DES 'collectgarbage'
---@param opt? cgopt
---@return any
function collectgarbage(opt, ...) end
---#else
---#DES 'collectgarbage'
---@param opt? cgopt
---@param arg? integer
---@return any
function collectgarbage(opt, arg) end
---#end

---#DES 'dofile'
---@param filename? string
---@return any
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
---@param f? async fun()
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
---| '"b"'  # ---#DESTAIL 'loadmode.b'
---| '"t"'  # ---#DESTAIL 'loadmode.t'
---|>'"bt"' # ---#DESTAIL 'loadmode.bt'

---#if VERSION <= 5.1 and not JIT then
---#DES 'load<5.1'
---@param func       function
---@param chunkname? string
---@return function
---@return string   error_message
---@nodiscard
function load(func, chunkname) end
---#else
---#DES 'load>5.2'
---@param chunk      string|function
---@param chunkname? string
---@param mode?      loadmode
---@param env?       table
---@return function
---@return string   error_message
---@nodiscard
function load(chunk, chunkname, mode, env) end
---#end

---#if VERSION <= 5.1 and not JIT then
---#DES 'loadfile'
---@param filename? string
---@return function
---@return string   error_message
---@nodiscard
function loadfile(filename) end
---#else
---#DES 'loadfile'
---@param filename? string
---@param mode?     loadmode
---@param env?      table
---@return function
---@return string   error_message
---@nodiscard
function loadfile(filename, mode, env) end
---#end

---@version 5.1
---#DES 'loadstring'
---@param text       string
---@param chunkname? string
---@return function
---@return string error_message
---@nodiscard
function loadstring(text, chunkname) end

---@version 5.1
---#DES 'module'
---@param name string
function module(name, ...) end

---#DES 'next'
---@generic K, V
---@param table table<K, V>
---@param index? K
---@return K
---@return V
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
---@param f     async fun()
---#end
---@param arg1? any
---@return boolean success
---@return any result
---@return ...
function pcall(f, arg1, ...) end

---#DES 'print'
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
---@param index integer|'"#"'
---@return any
---@nodiscard
function select(index, ...) end

---@version 5.1
---#DES 'setfenv'
---@param f     async fun()|integer
---@param table table
---@return function
function setfenv(f, table) end

---#DES 'setmetatable'
---@param table     table
---@param metatable table
---@return table
function setmetatable(table, metatable) end

---#DES 'tonumber'
---@param e     string|number
---@param base? integer
---@return number?
---@nodiscard
function tonumber(e, base) end

---#DES 'tostring'
---@param v any
---@return string
---@nodiscard
function tostring(v) end

---@alias type
---| '"nil"'
---| '"number"'
---| '"string"'
---| '"boolean"'
---| '"table"'
---| '"function"'
---| '"thread"'
---| '"userdata"'

---#DES 'type'
---@param v any
---@return type type
---@nodiscard
function type(v) end

---#DES '_VERSION'
---#if VERSION == 5.1 then
_VERSION = 'Lua 5.1'
---#elseif VERSION == 5.2 then
_VERSION = 'Lua 5.2'
---#elseif VERSION == 5.3 then
_VERSION = 'Lua 5.3'
---#elseif VERSION == 5.4 then
_VERSION = 'Lua 5.4'
---#end

---@version >5.4
---#DES 'warn'
---@param message string
function warn(message, ...) end

---#if VERSION == 5.1 and not JIT then
---#DES 'xpcall=5.1'
---@param f     function
---@param err   function
---@return boolean success
---@return any result
---@return ...
function xpcall(f, err) end
---#else
---#DES 'xpcall>5.2'
---@param f     async fun()
---@param msgh  function
---@param arg1? any
---@return boolean success
---@return any result
---@return ...
function xpcall(f, msgh, arg1, ...) end
---#end

---@version 5.1
---#DES 'unpack'
---@param list table
---@param i?   integer
---@param j?   integer
---@nodiscard
function unpack(list, i, j) end
