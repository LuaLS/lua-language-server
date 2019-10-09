local timer  = require 'timer'

---@class task
local m = {}
m.type = 'task'

m.coTracker = setmetatable({}, { __mode = 'k' })

--- 设置错误处理器
---@param errHandle function {comment = '当有错误发生时，会以错误堆栈为参数调用该函数'}
function m.setErrorHandle(errHandle)
    m.errorHandle = errHandle
end

function m.checkResult(co, ...)
    local suc, err = ...
    if not suc and m.errorHandle then
        m.errorHandle(debug.traceback(co, err))
    end
    return ...
end

--- 创建一个任务
function m.create(callback, ...)
    local co = coroutine.create(callback)
    m.coTracker[co] = true
    return m.checkResult(co, coroutine.resume(co, ...))
end

--- 休眠一段时间
---@param time number
function m.sleep(time, ...)
    local co, main = coroutine.running()
    if main then
        if m.errorHandle then
            m.errorHandle(debug.traceback('Cant sleep in main thread'))
        end
        return
    end
    timer.wait(time, function ()
        return m.checkResult(co, coroutine.resume(co))
    end)
    return coroutine.yield(...)
end

--- 等待直到唤醒
---@param waker function
function m.wait(waker, ...)
    local co, main = coroutine.running()
    if main then
        if m.errorHandle then
            m.errorHandle(debug.traceback('Cant wait in main thread'))
        end
        return
    end
    waker(function (...)
        return m.checkResult(co, coroutine.resume(co, ...))
    end)
    return coroutine.yield(...)
end

return m
