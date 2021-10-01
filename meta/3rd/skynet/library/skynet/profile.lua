---@meta
--- profile 模块可以帮助统计一个消息处理使用的系统时间
--- 使用 skynet 内置的 profile 记时而不用系统带的 os.time 是因为 profile 可以剔除阻塞调用的时间，准确统计出当前 coroutine 真正的开销。
--- > profile.start() 和 profile.stop() 必须在 skynet 线程中调用（记录当前线程），如果在 skynet [[Coroutine]] 中调用的话，请传入指定的 skynet 线程对象，通常可通过 skynet.coroutine.thread() 获得。
--- 若是需要多服务的跟踪，请使用 
--- skynet.trace() 在一个消息处理流程中，如果调用了这个 api ，将开启消息跟踪日志。每次调用都会生成一个唯一 tag ，所有当前执行流，和调用到的其它服务，都会计入日志中。具体解释，可以参考
local profile = {}

---开始，返回的时间单位是 秒
---@return number time
function profile.start()

end
---结束，返回的时间单位是秒
---@return number time
function profile.stop()

end
function profile.resume()

end
function profile.resume_co()

end
function profile.yield()

end
function profile.yield_co()

end
return profile
