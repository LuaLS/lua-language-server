---@meta

---#DES 'arg'
---@type table
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
---@param f? function
---@return table
function getfenv(f) end

---#DES 'getmetatable'
---@param object any
---@return table metatable
function getmetatable(object) end

---#DES 'ipairs'
---@param t table
---@return fun(t: table, i?: integer):integer, any iterator
---@return table t
---@return integer i
function ipairs(t) end

---@alias loadmode
---| '"b"'  # ---#DESTAIL 'loadmode.b'
---| '"t"'  # ---#DESTAIL 'loadmode.t'
---|>'"bt"' # ---#DESTAIL 'loadmode.bt'

---#if VERSION <= 5.1 then
---#DES 'load<5.1'
---@param func       function
---@param chunkname? string
---@return function
---@return string   error_message
function load(func, chunkname) end
---#else
---#DES 'load>5.2'
---@param chunk      string|function
---@param chunkname? string
---@param mode?      loadmode
---@param env?       table
---@return function
---@return string   error_message
function load(chunk, chunkname, mode, env) end
---#end

---#if VERSION <= 5.1 then
---#DES 'loadfile'
---@param filename? string
---@return function
---@return string   error_message
function loadfile(filename) end
---#else
---#DES 'loadfile'
---@param filename? string
---@param mode?     loadmode
---@param env?      table
---@return function
---@return string   error_message
function loadfile(filename, mode, env) end
---#end

---@version 5.1
---#DES 'loadstring'
---@param text       string
---@param chunkname? string
---@return function
---@return string error_message
function loadstring(text, chunkname) end

---@version 5.1
---#DES 'module'
---@param name string
function module(name, ...) end

---#DES 'next'
---@param table  table
---@param index? any
---@return any key
---@return any value
function next(table, index) end

---#DES 'paris'
---@param t table
---@return function next
---@return table
---@return nil
function pairs(t)
    return next
end

---#DES 'pcall'
---@param f     function
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
function rawequal(v1, v2) end

---#DES 'rawget'
---@param table table
---@param index any
---@return any
function rawget(table, index) end

---#DES 'rawlen'
---@param v table|string
---@return integer len
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
function select(index, ...) end

---@version 5.1
---#DES 'setfenv'
---@param f     function|integer
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
function tonumber(e, base) end

---#DES 'tostring'
---@param v any
---@return string
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
---@param f     function
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
function unpack(list, i, j) end
