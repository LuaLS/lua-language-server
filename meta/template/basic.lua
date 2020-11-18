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
---|>'"collect"'      # ---#DESENUM 'cgopt.collect'
---| '"stop"'         # ---#DESENUM 'cgopt.stop'
---| '"restart"'      # ---#DESENUM 'cgopt.restart'
---| '"count"'        # ---#DESENUM 'cgopt.count'
---| '"step"'         # ---#DESENUM 'cgopt.step'
---| '"incremental"'  # ---#DESENUM 'cgopt.incremental'
---| '"generational"' # ---#DESENUM 'cgopt.generational'
---| '"isrunning"'    # ---#DESENUM 'cgopt.isrunning'

---#DES 'collectgarbage'
---@param opt? cgopt
---@return any
function collectgarbage(opt, ...) end

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

---#ALIVE '5.1'
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
---| '"b"'  # ---#DESENUM 'loadmode.b'
---| '"t"'  # ---#DESENUM 'loadmode.t'
---|>'"bt"' # ---#DESENUM 'loadmode.bt'

---#DES 'load'
---@param chunk      string|function
---@param chunkname? string
---@param mode?      loadmode
---@param env?       table
---@return function
---@return string error_message
function load(chunk, chunkname, mode, env) end

---#DES 'loadfile'
---@param filename? string
---@param mode?     loadmode
---@param env?      table
---@return function
---@return string error_message
function loadfile(filename, mode, env) end

---#ALIVE '5.1'
---#DES 'loadstring'
---@param text       string
---@param chunkname? string
---@return function
---@return string error_message
function loadstring(text, chunkname) end

---#ALIVE '5.1'
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

---#ALIVE '5.1'
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

---#ALIVE '>5.4'
---#DES 'warn'
---@param message string
function warn(message, ...) end

---#DES 'xpcall'
---@param f     function
---@param msgh  function
---@param arg1? any
---@return boolean success
---@return any result
---@return ...
function xpcall(f, msgh, arg1, ...) end

---#ALIVE '5.1'
---#DES 'unpack'
---@param list table
---@param i?   integer
---@param j?   integer
function unpack(list, i, j) end
