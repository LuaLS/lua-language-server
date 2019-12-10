local timer  = require 'timer'

---@class await
local m = {}
m.type = 'await'

m.coTracker = setmetatable({}, { __mode = 'k' })
m.delayQueue = {}
m.delayQueueIndex = 1

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
function m.sleep(time, getVersion)
    if not coroutine.isyieldable() then
        if m.errorHandle then
            m.errorHandle(debug.traceback('Cannot yield'))
        end
        return
    end
    local version = getVersion and getVersion()
    local co = coroutine.running()
    timer.wait(time, function ()
        if version == (getVersion and getVersion()) then
            return m.checkResult(co, coroutine.resume(co))
        else
            coroutine.close(co)
        end
    end)
    return coroutine.yield(getVersion)
end

--- 等待直到唤醒
---@param callback function
function m.wait(callback, ...)
    if not coroutine.isyieldable() then
        return
    end
    local co = coroutine.running()
    callback(function (...)
        return m.checkResult(co, coroutine.resume(co, ...))
    end)
    return coroutine.yield(...)
end

--- 延迟
function m.delay(getVersion)
    if not coroutine.isyieldable() then
        return
    end
    local co = coroutine.running()
    local version = getVersion and getVersion()
    m.delayQueue[#m.delayQueue+1] = function ()
        if version == (getVersion and getVersion()) then
            return m.checkResult(co, coroutine.resume(co))
        else
            coroutine.close(co)
        end
    end
    return coroutine.yield()
end

local function buildInfo(waker)
    local co
    for i = 1, 100 do
        local n, v = debug.getupvalue(waker, i)
        if not n then
            return nil
        end
        if n == 'co' then
            co = v
            break
        end
    end
    if not co then
        return nil
    end
    return debug.traceback(co)
end

--- 步进
function m.step()
    local waker = m.delayQueue[m.delayQueueIndex]
    if waker then
        m.delayQueue[m.delayQueueIndex] = false
        m.delayQueueIndex = m.delayQueueIndex + 1
        local clock = os.clock()
        waker()
        local passed = os.clock() - clock
        if passed > 0.01 then
            log.warn(('Await step takes [%.3f] sec.\n%s'):format(passed, buildInfo(waker)))
        end
        return true
    else
        m.delayQueue = {}
        m.delayQueueIndex = 1
        return false
    end
end

return m
