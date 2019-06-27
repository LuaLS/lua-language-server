--- 独立版Lua的启动参数。
arg = {}

--- 如果其参数 `v` 的值为假，它就调用 `error`。
---@overload fun(v:any):any
---@param v any
---@param message any {optional = 'self'}
---@return any
function assert(v, message)
end

---@overload fun()
---@overload fun(opt:string):any
---@param opt string {optional = 'after'}
---| '"collect"'        {comment = '做一次完整的垃圾收集循环。', default = true}
---| '"stop"'           {comment = '停止垃圾收集器的运行。'}
---| '"restart"'        {comment = '重启垃圾收集器的自动运行。'}
---| '"count"'          {comment = '以 K 字节数为单位返回 Lua 使用的总内存数。'}
---| '"step"'           {comment = '单步运行垃圾收集器。'}
---| '"setpause"'       {comment = '设置收集器的 `间歇率`。'}
---| '"setstepmul"'     {comment = '设置收集器的 `步进倍率`。'}
---| '"incremental"'    {comment = '改变收集器模式为增量模式。'}
---| '"generational"'   {comment = '改变收集器模式为分代模式。'}
---| '"isrunning"'      {comment = '返回表示收集器是否在工作的布尔值。'}
---@param arg integer {optional = 'self'}
---@return any
function collectgarbage(opt, arg)
end
