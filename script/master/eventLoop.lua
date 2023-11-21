local thread = require 'bee.thread'

---@class EventLoop
local M = {}

M.tasks = {}

function M.startEventLoop()
    while true do
        M.runTask()
        thread.sleep(0.01)
    end
end

---@private
function M.runTask()
    for i = 1, #M.tasks do
        xpcall(M.tasks[i], log.error)
    end
end

---@param callback fun()
function M.addTask(callback)
    M.tasks[#M.tasks+1] = callback
end

return M
