local thread = require 'bee.thread'

---@class EventLoop
local M = {}

M.tasks = {}
M.started = false

---@param sleeper? fun(seconds: number)
function M.start(sleeper)
    if not sleeper then
        sleeper = function (seconds)
            thread.sleep(math.floor(seconds * 1000))
        end
    end
    M.started = true
    while M.started do
        M.runTask()
        local busy = M.runDelayQueue(100)
        if not busy then
            sleeper(0.01)
        end
    end
end

function M.stop()
    M.started = false
end

---@private
function M.runTask()
    for i = 1, #M.tasks do
        xpcall(M.tasks[i], log.error)
    end
    local err = thread.errlog()
    if err then
        log.error(err)
    end
end

---@private
---@param max integer
---@return boolean # 是否还有剩余任务
function M.runDelayQueue(max)
    local queue = M.delayQueue
    if not queue then
        return false
    end
    for i = 1, max do
        if not queue[i] then
            break
        end
        xpcall(queue[i], log.error)
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

function M.addDelayQueue(callback)
    if not M.delayQueue then
        M.delayQueue = {}
    end
    M.delayQueue[#M.delayQueue+1] = callback
end

return M
