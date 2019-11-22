--- 独立版Lua的启动参数。
arg = {}

--- 如果其参数 `v` 的值为假，它就调用 `error`。
---@overload fun(v:any):any
---@param v any
---@param message any {optional = 'self'}
---@return any
function assert(v, message) end

---@overload fun()
---@overload fun(opt:GCOption):any
---@param opt GCOption {optional = 'after'}
---@param arg integer {optional = 'self'}
---@return any
function collectgarbage(opt, arg) end

--- 打开该名字的文件，并执行文件中的 Lua 代码块。
---@overload fun():any
---@param filename string {optional = 'self', special = 'dofile:1'}
---@return any
function dofile(filename) end

--- 中止上一次保护函数调用，将错误对象 `message` 返回。
---@overload fun(message:any)
---@param message any
---@param level integer {optional = 'self'}
function error(message, level) end

--- 内部储存有全局环境。
_G = {}

--- 返回该对象的元表。
---@param object any
---@return table {name = 'metatable'}
function getmetatable(object) end

--- 能迭代表 `t` 中序列的键值对。
---|```lua
---|for i, v in ipairs(t) do
---|    -- body
---|end
---|```
---@param t table
---@return         {name = 'iterator'}
---@return table   {name = 't'}
---@return integer {name = 'i'}
function ipairs(t)
    --- 返回该键的下一个键及其关联的值。
    ---@overload fun(t:table):integer,any
    ---@param t table
    ---@param index any {optional = 'self'}
    ---@return integer {name = 'index'}
    ---@return any     {name = 'value'}
    local function iterator(t, index) end

    return iterator, t, nil
end

--- 加载一个代码块。
---@overload fun():function,string
---@overload fun(chunk:string|function):function,string
---@overload fun(chunk:string|function, chunkname:string):function,string
---@overload fun(chunk:string|function, chunkname:string, mode:loadOption):function,string
---@param chunk     string|function
---@param chunkname string          {optional = 'after'}
---@param mode      loadOption      {optional = 'after'}
---@param env       table           {optional = 'self'}
---@return        {name = 'init'}
---@return string {name = 'errMessage', optional = 'self'}
function load(chunk, chunkname, mode, env)
    return function (...) end
end

--- 从文件中获取代码块。
---@overload fun():function,string
---@overload fun(filename:string):function,string
---@overload fun(filename:string, mode:loadOption):function,string
---@param filename  string      {optional = 'after', special = 'loadfile:1'}
---@param mode      loadOption  {optional = 'after'}
---@param env       table       {optional = 'self'}
---@return          {name = 'init'}
---@return string   {name = 'errMessage', optional = 'self'}
function loadfile(filename, mode, env)
    return function (...) end
end

--- 返回该键的下一个键及其关联的值。
---@overload fun(t:table):any, any
---@param t table
---@param index any {optional = 'self'}
---@return any {name = 'key'}
---@return any {name = 'value'}
function next(t, index) end

--- 能迭代表 `t` 中的所有键值对。
---|```lua
---|for k, v in pairs(t) do
---|    -- body
---|end
---|```
---@param t table
---@return       {name = 'next'}
---@return table {name = 't'}
---@return any   {name = 'key'}
function pairs(t)
    --- 返回该键的下一个键及其关联的值。
    ---@overload fun(t:table):any, any
    ---@param t table
    ---@param index any {optional = 'self'}
    ---@return any {name = 'key'}
    ---@return any {name = 'value'}
    local function next(t, index) end

    return next, t, nil
end

--- 传入参数，以 *保护模式* 调用函数 `f` 。
---@param f function    {special = 'pcall:1'}
---@param arg1 any      {optional = 'after'}
---@return boolean      {name = 'success'}
---@return              {name = 'result'}
function pcall(f, arg1, ...)
end

--- 接收任意数量的参数，并将它们的值打印到 `stdout`。
function print(...)
end

--- 在不触发任何元方法的情况下 检查 `v1` 是否和 `v2` 相等。
---@param v1 any
---@param v2 any
---@return boolean
function rawequal(v1, v2)
end

--- 加载一个模块，返回该模块的返回值（`nil`时为`true`）。
---@param modname string {special = 'require:1'}
---@return any
---@return {name = 'loaderdata'}
function require(modname)
end

--- 当前解释器版本号。
_VERSION = 'Lua 5.4'
