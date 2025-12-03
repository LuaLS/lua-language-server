local jsonrpc = require 'transport.jsonrpc'
local stdio   = require 'transport.stdio'
local spec    = require 'lsp.spec'

---@class Transport
local M = Class 'Transport'

M.requestID = 0

function M:__init()
    self.requestMap = {}
    ---@type table<integer, Task>
    self.pendingMap = {}
end

---@param method string
---@param params? table
function M:notify(method, params)
    self.io:write(jsonrpc.encode {
        method = method,
        params = params,
    })
end

---@param method string
---@param params? table
---@param callback function
function M:request(method, params, callback)
    self.requestID = self.requestID + 1
    local data = {
        id = self.requestID,
        method = method,
        params = params,
    }
    self.io:write(jsonrpc.encode(data))
    self.requestMap[self.requestID] = {
        request  = data,
        callback = callback,
    }
end

---@async
---@param method string
---@param params? table
---@return any
function M:awaitRequest(method, params)
    return ls.await.yield(function (resume)
        self:request(method, params, resume)
    end)
end

---@async
---@return Task
---@return integer
function M:next()
    while true do
        ---@async
        local data = jsonrpc.decode(function (...)
            return self.io:read(...)
        end)
        if data.method then
            -- request or notification

            local task = ls.task.create(data.method, data.params, function (result, error)
                self.io:write(jsonrpc.encode {
                    id     = data.id,
                    result = result,
                    error  = error,
                })
            end)
            return task, data.id
        end
        if data.id then
            ---@cast data LSP.ResponseMessage
            local request = self.requestMap[data.id]
            if not request then
                goto continue
            end
            self.requestMap[data.id] = nil
            request.callback(data.result)
            if data.error then
                log.error(data.error.code, data.error.message)
            end
        end
        ::continue::
    end
end

---@async
---@return (fun(): Task), nil, nil, fun(err: string)
function M:listen()
    ---@async
    return function ()
        local task, id = self:next()

        if not id then
            return task
        end

        self.pendingMap[id] = task
        return task
    end, nil, nil, function (err)
        for _, task in pairs(self.pendingMap) do
            task:reject(err)
        end
    end
end

function M:useStdio()
    self.io = stdio.create()
end

---@class Transport.API
local API = {}

function API.create()
    return New 'Transport' ()
end

return API
