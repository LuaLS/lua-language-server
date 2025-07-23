local beeTime = require 'bee.time'

---@class Timer
---@field package id integer
---@field private count integer
---@field private onTimer Timer.OnTimer
---@field private initMS integer
---@field private startMS integer
---@field private targetMS number
---@field private removed? boolean
---@field private pausing? boolean
---@field private pausedAt? number
---@field private wakingUp? boolean
---@field private queueIndex? integer
---@overload fun(time: number, count: integer, on_timer: Timer.OnTimer): self
local M = Class 'Timer'

---@alias Timer.Mode 'second' | 'frame'
---@alias Timer.OnTimer fun(timer: Timer, count: integer)

---@private
M.allTimers = setmetatable({}, { __mode = 'v' })

---@private
M.runnedCount = 0

---@private
M.totalPausedMS = 0

---@private
M.pausedMS = 0

local curMS = 0
local id = 0

---@type table<integer, Timer[]>
local timerQueues = {}

---@param time number
---@param mode Timer.Mode
---@param count integer
---@param onTimer Timer.OnTimer
function M:__init(time, mode, count, onTimer)
    id = id + 1

    self.id = id
    self.time = time
    self.mode = mode
    self.count = count
    self.onTimer = onTimer
    self.initMS = curMS
    self.targetMS = curMS
    self.startMS = curMS

    M.allTimers[id] = self

    self:setTimeOut()
end

function M:__del()
    self.removed = true
    self:pop()
end

---@private
function M:setTimeOut()
    if self.removed or self.pausing then
        return
    end

    self.targetMS = self.initMS
                  + self.time * (self.runnedCount + 1) * 1000.0
                  + self.totalPausedMS

    self:push()
end

---@package
function M:wakeup()
    if self.removed or self.pausing then
        return
    end

    self.runnedCount = self.runnedCount + 1
    self.wakingUp = true
    self:execute()
    self.wakingUp = false
    if self.count > 0 and self.runnedCount >= self.count then
        self:remove()
    end
    self.pausedMS = 0
    self.startMS = curMS

    self:setTimeOut()
end

-- 立即执行
function M:execute(...)
    xpcall(self.onTimer, log.error, self, self.runnedCount, ...)
end

-- 移除计时器
function M:remove()
    Delete(self)
end

---@package
function M:push()
    self:pop()
    local ms = math.floor(self.targetMS)
    if ms <= curMS then
        ms = curMS + 1
    end
    local queue = timerQueues[ms]
    if not queue then
        queue = {}
        timerQueues[ms] = queue
    end
    queue[#queue+1] = self
    self.queueIndex = ms
end

---@package
function M:pop()
    local ms = self.queueIndex
    self.queueIndex = nil
    local queue = timerQueues[ms]
    if not queue then
        return
    end
    for i = 1, #queue do
        if queue[i] == self then
            queue[i] = queue[#queue]
            queue[#queue] = nil
            break
        end
    end
end

-- 暂停计时器
function M:pause()
    if self.pausing or self.removed then
        return
    end
    self.pausing = true
    self.pausedAt = curMS
    self:pop()
end

-- 恢复计时器
function M:resume()
    if not self.pausing or self.removed then
        return
    end
    self.pausing = false
    local pausedMS = curMS - self.pausedAt
    self.pausedMS = self.pausedMS + pausedMS
    self.totalPausedMS = self.totalPausedMS + pausedMS

    if not self.wakingUp then
        self:setTimeOut()
    end
end

-- 是否正在运行
function M:isRunning()
    return  not self.removed
        and not self.pausing
end

-- 获取经过的时间
---@return number
function M:getElapsedTime()
    if self.removed then
        return 0.0
    end
    if self.wakingUp then
        return (self.targetMS - self.startMS - self.pausedMS) / 1000.0
    end
    if self.pausing then
        return (self.pausedAt - self.startMS - self.pausedMS) / 1000.0
    end
    return (curMS - self.startMS - self.pausedMS) / 1000.0
end

-- 获取初始计数
---@return integer
function M:getInitCount()
    return self.count
end

-- 获取剩余时间
---@return number
function M:getRemainingTime()
    if self.removed or self.wakingUp then
        return 0.0
    end
    if self.pausing then
        return (self.targetMS - self.pausedAt) / 1000.0
    end
    return (self.targetMS - curMS) / 1000.0
end

-- 获取剩余计数
---@return integer
function M:getRemainingCount()
    if self.count <= 0 then
        return -1
    end
    return self.count - self.runnedCount
end

-- 获取计时器设置的时间
---@return number
function M:getTimeOutTime()
    return self.time
end

-- 等待时间后执行
---@param timeout number
---@param onTimer Timer.OnTimer
---@return Timer
function M.wait(timeout, onTimer)
    local timer = New 'Timer' (timeout, 'second', 1, onTimer)
    return timer
end

-- 循环执行
---@param timeout number
---@param onTimer Timer.OnTimer
---@return Timer
function M.loop(timeout, onTimer)
    local timer = New 'Timer' (timeout, 'second', 0, onTimer)
    return timer
end

-- 循环执行，可以指定最大次数
---@param timeout number
---@param count integer
---@param onTimer Timer.OnTimer
---@return Timer
function M.loop_count(timeout, count, onTimer)
    local timer = New 'Timer' (timeout, 'second', count, onTimer)
    return timer
end

-- 遍历所有的计时器，仅用于调试（可能会遍历到已经失效的）
---@return fun():Timer?
function M.pairs()
    local timers = {}
    for _, timer in pairs(M.allTimers) do
        timers[#timers+1] = timer
    end
    local i = 0
    return function ()
        i = i + 1
        return timers[i]
    end
end

---@type Timer[]
local desk = {}

local startMS = beeTime.monotonic()
local fixMS = 0
function M.update(deltaMS)
    if deltaMS then
        fixMS = fixMS + deltaMS
    end
    local targetMS = beeTime.monotonic() - startMS + fixMS
    for ti = curMS, targetMS do
        local queue = timerQueues[ti]
        if queue then
            curMS = ti
            table.sort(queue, function (a, b)
                return a.id < b.id
            end)
            for i = 1, #queue do
                desk[i] = queue[i]
            end
            timerQueues[ti] = nil
            for i = 1, #desk do
                local t = desk[i]
                desk[i] = nil
                t:wakeup()
            end
        end
    end

    curMS = targetMS
end


return M
