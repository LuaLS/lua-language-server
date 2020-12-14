local timer = require 'timer'
local util  = require 'utility'

---@class await
local m = {}
m.type = 'await'

m.coMap = setmetatable({}, { __mode = 'k' })
m.idMap = {}
m.delayQueue = {}
m.delayQueueIndex = 1
m.watchList = {}
m._enable = true

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
function m.call(callback, ...)
    local co = coroutine.create(callback)
    local closers = {}
    m.coMap[co] = {
        closers  = closers,
        priority = false,
    }
    for i = 1, select('#', ...) do
        local id = select(i, ...)
        if not id then
            break
        end
        m.setID(id, co)
    end

    local currentCo = coroutine.running()
    local current = m.coMap[currentCo]
    if current then
        for closer in pairs(current.closers) do
            closers[closer] = true
            closer(co)
        end
    end
    return m.checkResult(co, coroutine.resume(co))
end

--- 创建一个任务，并挂起当前线程，当任务完成后再延续当前线程/若任务被关闭，则返回nil
function m.await(callback, ...)
    if not coroutine.isyieldable() then
        return callback(...)
    end
    return m.wait(function (resume, ...)
        m.call(function ()
            local returnNil <close> = resume
            resume(callback())
        end, ...)
    end, ...)
end

--- 设置一个id，用于批量关闭任务
function m.setID(id, co)
    co = co or coroutine.running()
    if not m.idMap[id] then
        m.idMap[id] = setmetatable({}, { __mode = 'k' })
    end
    m.idMap[id][co] = true
end

--- 根据id批量关闭任务
function m.close(id)
    local map = m.idMap[id]
    if not map then
        return
    end
    local count = 0
    for co in pairs(map) do
        map[co] = nil
        coroutine.close(co)
        count = count + 1
    end
    --log.debug('Close await:', id, count)
end

function m.hasID(id, co)
    co = co or coroutine.running()
    return m.idMap[id] and m.idMap[id][co] ~= nil
end

--- 休眠一段时间
---@param time number
function m.sleep(time)
    if not coroutine.isyieldable() then
        if m.errorHandle then
            m.errorHandle(debug.traceback('Cannot yield'))
        end
        return
    end
    local co = coroutine.running()
    timer.wait(time, function ()
        if coroutine.status(co) ~= 'suspended' then
            return
        end
        return m.checkResult(co, coroutine.resume(co))
    end)
    return coroutine.yield()
end

--- 等待直到唤醒
---@param callback function
function m.wait(callback, ...)
    if not coroutine.isyieldable() then
        return
    end
    local co = coroutine.running()
    local resumed
    callback(function (...)
        if resumed then
            return
        end
        resumed = true
        if coroutine.status(co) ~= 'suspended' then
            return
        end
        return m.checkResult(co, coroutine.resume(co, ...))
    end, ...)
    return coroutine.yield()
end

--- 延迟
function m.delay()
    if not m._enable then
        return
    end
    if not coroutine.isyieldable() then
        return
    end
    local co = coroutine.running()
    local current = m.coMap[co]
    if m.onWatch('delay', co) == false then
        return
    end
    -- TODO
    if current.priority then
        return
    end
    m.delayQueue[#m.delayQueue+1] = function ()
        if coroutine.status(co) ~= 'suspended' then
            return
        end
        return m.checkResult(co, coroutine.resume(co))
    end
    return coroutine.yield()
end

local function warnStepTime(passed, waker)
    if passed < 1 then
        log.warn(('Await step takes [%.3f] sec.'):format(passed))
        return
    end
    for i = 1, 100 do
        local name, v = debug.getupvalue(waker, i)
        if not name then
            return
        end
        if name == 'co' then
            log.warn(debug.traceback(v, ('[fire]Await step takes [%.3f] sec.'):format(passed)))
            return
        end
    end
end

--- 步进
function m.step()
    local resume = m.delayQueue[m.delayQueueIndex]
    if resume then
        m.delayQueue[m.delayQueueIndex] = false
        m.delayQueueIndex = m.delayQueueIndex + 1
        local clock = os.clock()
        resume()
        local passed = os.clock() - clock
        if passed > 0.1 then
            warnStepTime(passed, resume)
        end
        return true
    else
        m.delayQueue = {}
        m.delayQueueIndex = 1
        return false
    end
end

function m.setPriority(n)
    m.coMap[coroutine.running()].priority = true
end

function m.enable()
    m._enable = true
end

function m.disable()
    m._enable = false
end

--- 注册事件
function m.watch(callback)
    m.watchList[#m.watchList+1] = callback
end

function m.onWatch(ev, ...)
    for _, callback in ipairs(m.watchList) do
        local res = callback(ev, ...)
        if res ~= nil then
            return res
        end
    end
end

return m
