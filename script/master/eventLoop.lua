local thread = require 'bee.thread'

---@class EventLoop
local M = {}

M.tasks = New 'LinkedTable'

function M.startEventLoop()
    while true do
        M.runTask()
        thread.sleep(0.01)
    end
end

---@private
function M.runTask()
    while true do
        local task = M.tasks:getHead()
        if not task then
            return
        end
        M.tasks:pop(task)
        xpcall(task, log.error)
    end
end

---@param callback fun()
function M.addTask(callback)
    M.tasks:pushTail(callback)
end

return M
