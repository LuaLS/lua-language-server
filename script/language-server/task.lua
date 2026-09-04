---@class Task: GCHost
local M = Class 'Task'

Extends('Task', 'GCHost')

---@private
M.resolved = false

---@alias Task.OnResolved fun(result: any)
---@alias Task.OnRejected fun(err: any)

---@private
---@type Task.OnResolved?
M._onResolved = nil

---@private
---@type Task.OnRejected?
M._onRejected = nil

---@param context? table
function M:__init(context)
    self.context = context or {}
    self.threads = {}
    self.awaitings = {}
end

function M:__del()
    for _, co in ipairs(self.threads) do
        local state = coroutine.status(co)
        if state == 'suspended' then
            coroutine.close(co)
        end
    end
end

function M:__close(err)
    self:reject(err or ls.task.REJECT_CLOSED)

    Delete(self)
end

---@param callback Task.OnResolved
---@return Task
function M:onResolved(callback)
    self._onResolved = callback
    if self.resolved then
        callback(self.result)
    end
    return self
end

---@param callback Task.OnRejected
---@return Task
function M:onRejected(callback)
    self._onRejected = callback
    if self.resolved and self.err then
        callback(self.err)
    end
    return self
end

---@param result any
function M:resolve(result)
    if self.resolved then
        return
    end
    self.resolved = true
    self.result = result

    self._onResolved?(result)
    self:resolveAwaitings()

    Delete(self)
end

---@param err any
function M:reject(err)
    if self.resolved then
        return
    end
    self.resolved = true
    self.err = err

    self._onRejected?(err)
    self:resolveAwaitings()

    Delete(self)
end

---@param timeout number
function M:setTimeout(timeout)
    self:bindGC(ls.timer.wait(timeout, function ()
        self:reject(ls.task.REJECT_TIMEOUT)
    end))
end

---@private
function M:resolveAwaitings()
    for _, resume in ipairs(self.awaitings) do
        resume(self.result, self.err)
    end
end

---@type table<thread, Task>
local taskMap = setmetatable({}, { __mode = 'k' })

---@param func async fun(task: Task)
---@return Task
function M:execute(func)
    ---@async
    ls.await.call(function ()
        local co = coroutine.running()
        taskMap[co] = self
        table.insert(self.threads, co)
        xpcall(func, function (err)
            self:reject(debug.traceback(err, 2))
        end, self)
    end)
    return self
end

---@async
local function yieldDelay()
    if not coroutine.isyieldable() then
        return
    end
    ls.await.sleep(0)
end

---@async
function M:delay()
    yieldDelay()
end

---@async
function M:await()
    if self.resolved then
        return self.result, self.err
    end
    return ls.await.yield(function (resume)
        self.awaitings[#self.awaitings+1] = resume
    end)
end

ls.task = {}

ls.task.REJECT_CLOSED = 'closed'
ls.task.REJECT_CANCELED = 'canceled'
ls.task.REJECT_TIMEOUT = 'timeout'

---@param context? table
---@return Task
function ls.task.create(context)
    return New 'Task' (context)
end

---@return Task?
function ls.task.getCurrentTask()
    return taskMap[coroutine.running()]
end

---@class Task.ThrottledDelayer
---@field package factor integer
---@field package calls integer
local throttledDelayer = {}
throttledDelayer.__index = throttledDelayer

---@async
function throttledDelayer:delay()
    self.calls = self.calls + 1
    if self.calls == self.factor then
        self.calls = 0
        yieldDelay()
    end
end

---@param factor integer
---@return Task.ThrottledDelayer
function ls.task.newThrottledDelayer(factor)
    return setmetatable({
        factor = factor,
        calls  = 0,
    }, throttledDelayer)
end
