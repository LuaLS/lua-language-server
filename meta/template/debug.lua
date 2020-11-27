---@meta

---#DES 'debug'
---@class debug*
debug = {}

---@class debuginfo
---@field name            string
---@field namewhat        string
---@field source          string
---@field short_src       string
---@field linedefined     integer
---@field lastlinedefined integer
---@field what            string
---@field currentline     integer
---@field istailcall      boolean
---@field nups            integer
---#if VERSION >= 5.2 then
---@field nparams         integer
---@field isvararg        boolean
---#end
---@field func            function
---#if VERSION >= 5.4 then
---@field ftransfer       integer
---@field ntransfer       integer
---#end
---@field activelines     table

---#DES 'debug.debug'
function debug.debug() end

---@version 5.1
---#DES 'debug.getfenv'
---@param o any
---@return table
function debug.getfenv(o) end

---#DES 'debug.gethook'
---@param co? thread
---@return function hook
---@return string mask
---@return integer count
function debug.gethook(co) end

---@alias infowhat string
---|+'"n"'     # ---#DESTAIL 'infowhat.n'
---|+'"S"'     # ---#DESTAIL 'infowhat.S'
---|+'"l"'     # ---#DESTAIL 'infowhat.l'
---|+'"t"'     # ---#DESTAIL 'infowhat.t'
---#if VERSION <= 5.1 then
---|+'"u<5.1"' # ---#DESTAIL 'infowhat.u<5.1'
---#else
---|+'"u>5.2"' # ---#DESTAIL 'infowhat.u>5.2'
---#end
---|+'"f"'     # ---#DESTAIL 'infowhat.f'
---#if VERSION >= 5.4 then
---|+'"r"'     # ---#DESTAIL 'infowhat.r'
---#end
---|+'"L"'     # ---#DESTAIL 'infowhat.L'

---#DES 'debug.getinfo'
---@overload fun(f: integer|function, what?: infowhat):debuginfo
---@param thread thread
---@param f      integer|function
---@param what?  infowhat
---@return debuginfo
function debug.getinfo(thread, f, what) end

---#DES 'debug.getlocal<5.1'
---@overload fun(level: integer, index: integer):string, any
---@param thread  thread
---@param level   integer
---@param index   integer
---@return string name
---@return any    value
function debug.getlocal(thread, level, index) end

---#DES 'debug.getlocal>5.2'
---@overload fun(f: integer|function, index: integer):string, any
---@param thread  thread
---@param f       integer|function
---@param index   integer
---@return string name
---@return any    value
function debug.getlocal(thread, f, index) end

---#DES 'debug.getmetatable'
---@param object any
---@return table metatable
function debug.getmetatable(object) end

---#DES 'debug.getregistry'
---@return table
function debug.getregistry() end

---#DES 'debug.getupvalue'
---@param f  function
---@param up integer
---@return string name
---@return any    value
function debug.getupvalue(f, up) end

---#if VERSION >= 5.4 then
---#DES 'debug.getuservalue>5.4'
---@param u userdata
---@param n integer
---@return any
---@return boolean
function debug.getuservalue(u, n) end
---#else
---#DES 'debug.getuservalue<5.3'
---@param u userdata
---@return any
function debug.getuservalue(u) end
---#end

---#DES 'debug.setcstacklimit'
---@deprecated
---@param limit integer
---@return integer|boolean
function debug.setcstacklimit(limit) end

---#DES 'debug.setfenv'
---@version 5.1
---@generic T
---@param object T
---@param env    table
---@return T object
function debug.setfenv(object, env) end

---@alias hookmask string
---|+'"c"' # ---#DESTAIL 'hookmask.c'
---|+'"r"' # ---#DESTAIL 'hookmask.r'
---|+'"l"' # ---#DESTAIL 'hookmask.l'

---#DES 'debug.sethook'
---@overload fun(hook: function, mask: hookmask, count?: integer)
---@param thread thread
---@param hook   function
---@param mask   hookmask
---@param count? integer
function debug.sethook(thread, hook, mask, count) end

---#DES 'debug.setlocal'
---@overload fun(level: integer, index: integer, value: any):string
---@param thread thread
---@param level  integer
---@param index  integer
---@param value  any
---@return string name
function debug.setlocal(thread, level, index, value) end

---#DES 'debug.setmetatable'
---@generic T
---@param value T
---@param meta  table
---@return T value
function debug.setmetatable(value, meta) end

---#DES 'debug.setupvalue'
---@param f     function
---@param up    integer
---@param value any
---@return string name
function debug.setupvalue(f, up, value) end

---#if VERSION >= 5.4 then
---#DES 'debug.setuservalue>5.4'
---@param udata userdata
---@param value any
---@param n     integer
---@return userdata udata
function debug.setuservalue(udata, value, n) end
---#else
---#DES 'debug.setuservalue<5.3'
---@param udata userdata
---@param value any
---@return userdata udata
function debug.setuservalue(udata, value) end
---#end

---#DES 'debug.traceback'
---@param thread   thread
---@param message? any
---@param level?   integer
---@return string  message
function debug.traceback(thread, message, level) end

---@version >5.2
---#DES 'debug.upvalueid'
---@param f function
---@param n integer
---@return lightuserdata id
function debug.upvalueid(f, n) end

---@version >5.2
---#DES 'debug.upvaluejoin'
---@param f1 function
---@param n1 integer
---@param f2 function
---@param n2 integer
function debug.upvaluejoin(f1, n1, f2, n2) end

return debug
