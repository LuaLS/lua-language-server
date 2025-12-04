local spec = require 'lsp.spec'

---@class Task
local M = Class 'Task'

M.resolved = false
M.needResolve = true

---@alias Task.Callback fun(result?: any, error?: LSP.ResponseError)

---@param method string
---@param params? LSP.Any
---@param callback Task.Callback
function M:__init(method, params, callback)
    self.method = method
    self.params = params
    self.callback = callback
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
    if self.needResolve and not self.resolved then
        if err then
            self:reject(err)
        else
            self:rejectWithCode(spec.ErrorCodes.InternalError, 'Miss to resolve the task: ' .. tostring(self.method))
        end
    end

    Delete(self)
end

function M:doNotNeedResolve()
    self.needResolve = false
end

---@param result any
function M:resolve(result)
    if self.resolved then
        return
    end
    self.resolved = true

    if self.needResolve then
        self.callback(result, nil)
    end

    Delete(self)
end

---@param err integer | string
function M:reject(err)
    if self.resolved then
        return
    end
    if err == spec.ErrorCodes.ServerCancelled then
        self:rejectWithCode(spec.ErrorCodes.ServerCancelled, 'Server cancelled the request.')
        return
    end
    if err == spec.ErrorCodes.RequestCancelled then
        self:rejectWithCode(spec.ErrorCodes.RequestCancelled, 'Request cancelled.')
        return
    end
    if type(err) == 'number' then
        self:rejectWithCode(err, 'Error code: ' .. tostring(err))
        return
    end
    if type(err) == 'string' then
        self:rejectWithCode(spec.ErrorCodes.InternalError, tostring(err))
        return
    end
    self:rejectWithCode(spec.ErrorCodes.InternalError, 'Unknown error.')

    Delete(self)
end

---@param code integer
---@param err string
---@param data? any
function M:rejectWithCode(code, err, data)
    if self.resolved then
        return
    end
    self.resolved = true

    if self.needResolve then
        self.callback(nil, {
            code    = code,
            message = err,
            data    = data,
        })
    end
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

---@param method string
---@param params? LSP.Any
---@param callback Task.Callback
---@return Task
function ls.task.create(method, params, callback)
    return New 'Task' (method, params, callback)
end

---@return Task?
function ls.task.getCurrentTask()
    return taskMap[coroutine.running()]
end
