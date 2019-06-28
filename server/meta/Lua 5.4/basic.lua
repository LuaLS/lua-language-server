--- 独立版Lua的启动参数。
arg = {}

--- 如果其参数 `v` 的值为假，它就调用 `error`。
---@overload fun(v:any):any
---@param v any
---@param message any {optional = 'self'}
---@return any
function assert(v, message) end

---@alias GCOption string
---| > '"collect"'        # 做一次完整的垃圾收集循环。
---|   '"stop"'           # 停止垃圾收集器的运行。
---|   '"restart"'        # 重启垃圾收集器的自动运行。
---|   '"count"'          # 以 K 字节数为单位返回 Lua 使用的总内存数。
---|   '"step"'           # 单步运行垃圾收集器。
---|   '"setpause"'       # 设置收集器的 `间歇率`。
---|   '"setstepmul"'     # 设置收集器的 `步进倍率`。
---|   '"incremental"'    # 改变收集器模式为增量模式。
---|   '"generational"'   # 改变收集器模式为分代模式。
---|   '"isrunning"'      # 返回表示收集器是否在工作的布尔值。
---@overload fun()
---@overload fun(opt:GCOption):any
---@param opt GCOption {optional = 'after'}
---@param arg integer {optional = 'self'}
---@return any
function collectgarbage(opt, arg) end

--- 打开该名字的文件，并执行文件中的 Lua 代码块。
---@param filename string {optional = 'self', special = 'dofile:1'}
---@return any
function dofile(filename) end

--- 内部储存有全局环境。
_G = {}

--- 返回该键的下一个键及其关联的值。
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
    ---@param t table
    ---@param index any {optional = 'self'}
    ---@return any {name = 'key'}
    ---@return any {name = 'value'}
    local function next(t, index) end

    return next, t, nil
end

--- 当前解释器版本号。
_VERSION = 'Lua 5.4'
