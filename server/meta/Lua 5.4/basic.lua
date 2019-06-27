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
---@param opt string {optional = 'after'} | '"collect"' | '"stop"' | '"restart"' | '"count"' | '"step"' | '"setpause"' | '"setstepmul"' | '"incremental"' | '"generational"' | '"isrunning"'
---@param arg integer {optional = 'self'}
---@return any
function collectgarbage(opt, arg)
end
