local timer = require 'timer'

local wkmt = { __mode = 'k' }

---@class await
local m = {}
m.type = 'await'

m.coMap = setmetatable({}, wkmt)
m.idMap = {}
m.delayQueue = {}
m.delayQueueIndex = 1
m.watchList = {}
m.needClose = {}
m._enable = true

local function setID(id, co, callback)
    if not coroutine.isyieldable(co) then
        return
    end
    if not m.idMap[id] then
        m.idMap[id] = setmetatable({}, wkmt)
    end
    m.idMap[id][co] = callback or true
end

--- 设置错误处理器
---@param errHandle function # 当有错误发生时，会以错误堆栈为参数调用该函数
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
---@param callback async fun()
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
        setID(id, co)
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
---@async
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
function m.setID(id, callback)
    local co = coroutine.running()
    setID(id, co, callback)
end

--- 根据id批量关闭任务
function m.close(id)
    local map = m.idMap[id]
    if not map then
        return
    end
    m.idMap[id] = nil
    for co, callback in pairs(map) do
        if coroutine.status(co) == 'suspended' then
            map[co] = nil
            if type(callback) == 'function' then
                xpcall(callback, log.error)
            end
            coroutine.close(co)
        end
    end
end

function m.hasID(id, co)
    co = co or coroutine.running()
    return m.idMap[id] and m.idMap[id][co] ~= nil
end

--- 休眠一段时间
---@param time number
---@async
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
---@async
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
---@async
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

--- stop then close
---@async
function m.stop()
    if not coroutine.isyieldable() then
        return
    end
    m.needClose[#m.needClose+1] = coroutine.running()
    coroutine.yield()
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
    for i = #m.needClose, 1, -1 do
        coroutine.close(m.needClose[i])
        m.needClose[i] = nil
    end

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
        for i = 1, #m.delayQueue do
            m.delayQueue[i] = nil
        end
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
---@param callback async fun(ev: string, ...)
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
