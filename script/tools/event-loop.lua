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
        M.runDelayQueue()
        sleeper(0.01)
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
function M.runDelayQueue()
    local queue = M.delayQueue
    if not queue then
        return
    end
    local index = 1
    while index <= #queue do
        xpcall(queue[index], log.error)
        index = index + 1
    end
    M.delayQueue = nil
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
