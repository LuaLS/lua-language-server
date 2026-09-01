local thread = require 'bee.thread'
local time   = require 'bee.time'

---@class EventLoop
local M = {}

---@package
M.tasks = {}
---@package
M.highTasks = {}
---@package
M.started = false
---@package
M.busyTime = 0

---@param sleeper? fun(seconds: number)
---@param errorHandler? fun(err: string)
function M.start(sleeper, errorHandler)
    if not sleeper then
        sleeper = function (seconds)
            thread.sleep(math.floor(seconds * 1000))
        end
    end
    if not errorHandler then
        errorHandler = print
    end
    M.started = true
    while M.started do
        M.runTask(errorHandler)
        local busy = M.runDelayQueue(100, errorHandler)
        if busy then
            M.markBusy()
        end
        local idleTime = M.getIdleTime()
        if idleTime < 1 then
        elseif idleTime < 10 then
            sleeper(0.001)
        elseif idleTime < 60 then
            sleeper(0.01)
        else
            sleeper(0.1)
        end
    end
end

function M.stop()
    M.started = false
end

---@private
function M.runTask(errorHandler)
    for i = 1, #M.highTasks do
        xpcall(M.highTasks[i], errorHandler)
    end
    for i = 1, #M.tasks do
        xpcall(M.tasks[i], errorHandler)
    end
end

---@private
---@param max integer
---@param errorHandler fun(err: any)
---@return boolean # 是否还有剩余任务
function M.runDelayQueue(max, errorHandler)
    local queue = M.delayQueue
    if not queue then
        return false
    end
    for i = 1, max do
        if not queue[i] then
            break
        end
        xpcall(queue[i], errorHandler)
        for j = 1, #M.highTasks do
            xpcall(M.highTasks[j], errorHandler)
        end
    end
    if not queue[max + 1] then
        M.delayQueue = nil
        return false
    end
    M.delayQueue = {}
    table.move(queue, max + 1, #queue, 1, M.delayQueue)
    return true
end

---@param callback fun()
function M.addTask(callback)
    M.tasks[#M.tasks+1] = callback
end

---@param callback fun()
function M.addHighTask(callback)
    M.highTasks[#M.highTasks+1] = callback
end

function M.addDelayQueue(callback)
    if not M.delayQueue then
        M.delayQueue = {}
    end
    M.delayQueue[#M.delayQueue+1] = callback
end

function M.markBusy()
    M.busyTime = time.monotonic()
end

function M.getIdleTime()
    return (time.monotonic() - M.busyTime) / 1000
end

return M
