---@class Task
local M = Class 'Task'

M.resolved = false

---@alias Task.Callback fun(result?: any, err?: any)

---@param context? table
---@param callback? Task.Callback
function M:__init(context, callback)
    self.context = context or {}
    self.callback = callback or function () end
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

---@param result any
function M:resolve(result)
    if self.resolved then
        return
    end
    self.resolved = true
    self.result = result

    self.callback(result, nil)
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

    self.callback(nil, err)
    self:resolveAwaitings()

    Delete(self)
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
        func(self)
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

ls.task.REJECT_CLOSED = { '<REJECT_CLOSED>' }
ls.task.REJECT_CANCELED = { '<REJECT_CANCELED>' }

---@param context? table
---@param callback? Task.Callback
---@return Task
function ls.task.create(context, callback)
    return New 'Task' (context, callback)
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
