---@meta

---@class debug
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
---@field nparams         integer
---@field isvararg        boolean
---@field func            function
---@field ftransfer       integer
---@field ntransfer       integer
---@field activelines     table

function debug.debug() end

---@param o any
---@return table
function debug.getfenv(o) end

---@param co thread?
---@return function hook
---@return string mask
---@return integer count
function debug.gethook(co) end

---@alias infowhat string
---| '"n"' # `name` 和 `namewhat`
---| '"S"' # `source`，`short_src`，`linedefined`，`lastlinedefined`，和 `what`
---| '"l"' # `currentline`
---| '"t"' # `istailcall`
---| '"u"' # `nups`，`nparams` 和 `isvararg`
---| '"f"' # `func`
---| '"r"' # `ftransfer` 和 `ntransfer`
---| '"L"' # `activelines`

---@overload fun(f: integer|function, what: infowhat?):debuginfo
---@param thread thread
---@param f integer|function
---@param what infowhat?
---@return debuginfo
function debug.getinfo(thread, f, what) end

---@overload fun(f: integer|function, index: integer):string, any
---@param thread thread
---@param f integer|function
---@param index integer
---@return string name
---@return any value
function debug.getlocal(thread, f, index) end

---@param object any
---@return table metatable
function debug.getmetatable(object) end

---@return table
function debug.getregistry() end

---@param f integer|function
---@param up integer
---@return string name
---@return any value
function debug.getupvalue(f, up) end

---@param u userdata
---@param n integer
---@return any
---@return boolean
function debug.getuservalue(u, n) end

---@deprecated
---@param limit integer
---@return integer|boolean
function debug.setcstacklimit(limit) end

---@generic T
---@param object T
---@param env table
---@return T object
function debug.setfenv(object, env) end

---@alias hookmask
---| '"c"'
---| '"r"'
---| '"l"'

---@overload fun(hook: function, mask: hookmask, count: integer?)
---@param thread thread
---@param hook function
---@param mask hookmask
---@param count integer?
function debug.sethook(thread, hook, mask, count) end

---@overload fun(level: integer, index: integer, value: any):string
---@param thread thread
---@param level integer
---@param index integer
---@param value any
---@return string name
function debug.setlocal(thread, level, index, value) end

---@generic T
---@param value T
---@param meta table
---@return T value
function debug.setmetatable(value, meta) end

---@param f function
---@param up integer
---@param value any
---@return string name
function debug.setupvalue(f, up, value) end

---@generic USERDATA
---@param udata USERDATA
---@param value any
---@param n integer
---@return USERDATA udata
function debug.setuservalue(udata, value, n) end

---@param thread thread
---@param message any?
---@param level integer?
---@return string message
function debug.traceback(thread, message, level) end

---@param f function
---@param n integer
---@return lightuserdata id
function debug.upvalueid(f, n) end

---@param f1 function
---@param n1 integer
---@param f2 function
---@param n2 integer
function debug.upvaluejoin(f1, n1, f2, n2) end

return debug
