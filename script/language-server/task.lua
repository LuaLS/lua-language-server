local spec = require 'lsp.spec'

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

    self.callback(result, nil)

    Delete(self)
end

---@param err any
function M:reject(err)
    if self.resolved then
        return
    end
    self.resolved = true

    self.callback(nil, err)

    Delete(self)
end

---@type table<thread, Task>
local taskMap = setmetatable({}, { __mode = 'k' })

---@param func async fun()
function M:execute(func)
    ---@async
    ls.await.call(function ()
        local co = coroutine.running()
        taskMap[co] = self
        table.insert(self.threads, co)
        func()
    end)
end

ls.task = {}

ls.task.REJECT_CLOSED = { '<REJECT_CLOSED>' }

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
