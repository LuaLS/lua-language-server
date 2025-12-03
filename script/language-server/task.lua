local spec = require 'lsp.spec'

---@class Task
local M = Class 'Task'

M.resolved = false

---@alias Task.Callback fun(result?: any, error?: LSP.ResponseError)

---@param method string
---@param params? LSP.Any
---@param callback Task.Callback
function M:__init(method, params, callback)
    self.method = method
    self.params = params
    self.callback = callback
end

function M:__close(err)
    self:reject(err)
end

---@param result any
function M:resolve(result)
    if self.resolved then
        return
    end
    self.resolved = true

    self.callback(result, nil)
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
end

---@private
---@param code integer
---@param err string
---@param data? any
function M:rejectWithCode(code, err, data)
    if self.resolved then
        return
    end
    self.resolved = true
    self.callback(nil, {
        code    = code,
        message = err,
        data    = data,
    })
end

---@param func async fun()
function M:execute(func)
    ls.await.call(function ()
        
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
