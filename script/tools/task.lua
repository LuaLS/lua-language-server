---@alias Task.Callback async fun(task: Task)
---@alias Task.Timer fun(timeout: number, callback: fun())

---@class Task
---@overload fun(callback: Task.Callback): self
local M = Class 'Task'

---@package
M.all = New 'LinkedTable' ()

---@package
M.sleeps = New 'LinkedTable' ()

---@package
---@type Task.Timer?
M.timer = nil

---@param callback Task.Callback
function M:__init(callback)
    self.co = coroutine.create(callback)
    self.idMap = {}
    M.all:pushTail(self)
end

function M:__del()
    if coroutine.status(self.co) ~= 'dead' then
        coroutine.close(self.co)
    end
    M.all:pop(self)
end

function M:setID(...)
    for _, id in ipairs {...} do
        self.idMap[id] = true
    end
end

---@param id any
---@return boolean
function M:hasID(id)
    return self.idMap[id] or false
end

function M:resume()
    if coroutine.status(self.co) ~='suspended' then
        return
    end
    coroutine.resume(self.co)
end

function M:remove()
    Delete(self)
end

---@param callback Task.Callback
---@return Task
function M.call(callback)
    local task = New 'Task' (callback)
    task:resume()
    return task
end

---@async
---@return Task?
function M.running()
    local co = coroutine.running()
    for _, task in ipairs(M.all) do
        if task.co == co then
            return task
        end
    end
    return nil
end

---@async
function M.setRunningID(...)
    local task = M.running()
    if not task then
        return
    end
    task:setID(...)
end

---@param id any
function M.removeByID(id)
    ---@param task Task
    for task in M.all:pairs() do
        if task:hasID(id) then
            task:remove()
        end
    end
end

---@async
---@param id any
function M.unique(id)
    M.removeByID(id)
    M.setRunningID(id)
end

---@async
function M.yield()
    local task = M.running()
    if not task then
        return
    end
    M.sleeps:pushTail(task)
    coroutine.yield()
end

---@async
---@param time number
function M.sleep(time)
    local task = M.running()
    if not task then
        return
    end
    assert(M.timer, 'No valid timer!')
    M.timer(time, function ()
        M.sleeps:pushTail(task)
    end)
    coroutine.yield()
end

---@param timer Task.Timer
function M.setTimer(timer)
    M.timer = timer
end

function M.resumeOne()
    local head = M.sleeps:getHead()
    if not head then
        return false
    end
    M.sleeps:pop(head)
    head:resume()
    return true
end

function M.resumeAll()
    while M.resumeOne() do end
end

return M
