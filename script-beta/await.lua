local timer  = require 'timer'

---@class await
local m = {}
m.type = 'await'

m.coTracker  = setmetatable({}, { __mode = 'k' })
m.coPriority = setmetatable({}, { __mode = 'k' })
m.coDelayer  = setmetatable({}, { __mode = 'k' })
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

--- 对当前任务设置一个延迟检查器，当延迟前后检查器的返回值不同时，放弃此任务
function m.setDelayer(callback)
    local co = coroutine.running()
    m.coDelayer[co] = callback
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
    local delayer = m.coDelayer[co]
    local dVersion = delayer and delayer()
    timer.wait(time, function ()
        if  version == (getVersion and getVersion())
        and dVersion == (delayer and delayer()) then
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
    -- TODO
    if m.coPriority[co] then
        return
    end
    local version = getVersion and getVersion()
    local delayer = m.coDelayer[co]
    local dVersion = delayer and delayer()
    m.delayQueue[#m.delayQueue+1] = function ()
        if  version == (getVersion and getVersion())
        and dVersion == (delayer and delayer()) then
            return m.checkResult(co, coroutine.resume(co))
        else
            coroutine.close(co)
        end
    end
    return coroutine.yield()
end

local function getCo(waker)
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
    return co
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
        if passed > 0.1 then
            log.warn(('Await step takes [%.3f] sec.'):format(passed))
        end
        return true
    else
        m.delayQueue = {}
        m.delayQueueIndex = 1
        return false
    end
end

function m.setPriority(n)
    m.coPriority[coroutine.running()] = n
end

return m
