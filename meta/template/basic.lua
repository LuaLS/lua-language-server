---@type table
arg = {}

---@generic T
---@param v T
---@param message any
---@return T
function assert(v, message) end

---@alias cgopt54
---| '"stop"'
---| '"restart"'
---| '"count"'
---| '"step"'
---| '"incremental"'
---| '"generational"'
---| '"isrunning"'

---@param opt cgopt54?
---@return any
function collectgarbage(opt, ...) end

---@param filename string?
---@return any
function dofile(filename) end

---@param message any
---@param level integer?
function error(message, level) end

---@class _G
_G = {}

---#if VERSION >= 5.2 then
---@deprecated
---#end
---@param f function?
---@return table
function getfenv(f) end

---@param object any
---@return table metatable
function getmetatable(object) end

---@param t table
---@return fun(t: table, i: integer?):integer, any iterator
---@return table t
---@return integer i
function ipairs(t) end

---@alias loadmode
---| '"b"''
---| '"t"'
---|>'"bt"'

---@param chunk string|function
---@param chunkname string?
---@param mode loadmode?
---@param env table?
---@return function
---@return string error_message
function load(chunk, chunkname, mode, env) end

---@param filename string?
---@param mode loadmode?
---@param env table?
---@return function
---@return string error_message
function loadfile(filename, mode, env) end

---#if VERSION >= 5.2 then
---@deprecated
---#end
---@param text string
---@param chunkname string?
---@return function
---@return string error_message
function loadstring(text, chunkname) end

---#if VERSION >= 5.2 then
---@deprecated
---#end
---@param name string
function module(name, ...) end

---@param table table
---@param index any?
---@return any key
---@return any value
function next(table, index) end

---@param t table
---@return function next
---@return table
---@return nil
function pairs(t)
    return next
end

---@param f function
---@param arg1 any?
---@return boolean success
---@return any result
---@return ...
function pcall(f, arg1, ...) end

function print(...) end

---@param v1 any
---@param v2 any
---@return boolean
function rawequal(v1, v2) end

---@param table table
---@param index any
---@return any
function rawget(table, index) end

---@param v table|string
---@return integer len
function rawlen(v) end

---@param table table
---@param index any
---@param value any
---@return table
function rawset(table, index, value) end

---@param index integer|'"#"'
---@return any
function select(index, ...) end

---#if VERSION >= 5.2 then
---@deprecated
---#end
---@param f function|integer
---@param table table
---@return function
function setfenv(f, table) end

---@param table table
---@param metatable table
---@return table
function setmetatable(table, metatable) end

---@param e string|number
---@param base integer?
---@return number|nil
function tonumber(e, base) end

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

---@param v any
---@return type type
function type(v) end

---#if VERSION == 5.1 then
_VERSION = 'Lua 5.1'
---#elseif VERSION == 5.2 then
_VERSION = 'Lua 5.2'
---#elseif VERSION == 5.3 then
_VERSION = 'Lua 5.3'
---#elseif VERSION == 5.4 then
_VERSION = 'Lua 5.4'
---#end

---@param message string
function warn(message, ...) end

---@param f function
---@param msgh function
---@param arg1 any?
---@return boolean success
---@return any result
---@return ...
function xpcall(f, msgh, arg1, ...) end

---@param modname string
---@return any
---@return any loaderdata
function require(modname) end

---#if VERSION >= 5.2 then
---@deprecated
---#end
---@param list table
---@param i integer?
---@param j integer?
function unpack(list, i, j) end
