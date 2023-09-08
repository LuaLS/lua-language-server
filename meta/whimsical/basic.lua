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
---@return any ... => args[reti + 1]
---@throw => args[1].isFalsy
---@narrow v => args[1].truly
function assert(v, message, ...) end

--[[@@@
---@overload fun(opt: 'collect')                  # ---#DESTAIL 'cgopt.collect'
---@overload fun(opt: 'stop')                     # ---#DESTAIL 'cgopt.stop'
---@overload fun(opt: 'restart')                  # ---#DESTAIL 'cgopt.restart'
---@overload fun(opt: 'count'): integer           # ---#DESTAIL 'cgopt.count'
---@overload fun(opt: 'step'): boolean            # ---#DESTAIL 'cgopt.step'
---@overload fun(opt: 'isrunning'): boolean       # ---#DESTAIL 'cgopt.isrunning'
---#if VERSION >= 5.4 then
---@overload fun(opt: 'incremental'
    , pause?: integer
    , stepmul?: integer
    , stepsize?: integer)                         # ---#DESTAIL 'cgopt.incremental'
---@overload fun(opt: 'generational'
    , minor?: integer
    , major?: integer)                            # ---#DESTAIL 'cgopt.generational'
---#end
---@overload fun(opt: 'setpause', arg: integer)   # ---#DESTAIL 'cgopt.setpause'
---@overload fun(opt: 'setstepmul', arg: integer) # ---#DESTAIL 'cgopt.setstepmul'
---@prototype
]]
function collectgarbage(...) end

---#DES 'dofile'
---@param filename? string
---@return any
---@custom dofile
function dofile(filename) end

---#DES 'error'
---@param message any
---@param level?  integer
---@throw
function error(message, level) end
