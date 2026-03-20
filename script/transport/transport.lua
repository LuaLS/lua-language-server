local jsonrpc = require 'transport.jsonrpc'
local stdio   = require 'transport.stdio'

---@class Transport
local M = Class 'Transport'

M.requestID = 0

function M:__init()
    self.requestMap = {}
    ---@type table<integer|string, Task>
    self.pendingMap = {}
end

function M:write(data)
    if ls.args.TRACE_RPC then
        log.info('RPC >>>', ls.inspect(data))
    end
    self.io:write(jsonrpc.encode(data))
end

---@param method string
---@param params? table
function M:notify(method, params)
    self:write {
        method = method,
        params = params,
    }
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
    self:write(data)
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
        if ls.args.TRACE_RPC then
            log.info('RPC <<<', ls.inspect(data))
        end
        if data.method then
            -- request or notification

            local task = ls.task.create(data, function (result, err)
                if not data.id then
                    return
                end
                if not self.pendingMap[data.id] then
                    return
                end
                self.pendingMap[data.id] = nil
                if not err then
                    if result == nil then
                        result = ls.json.null
                    end
                    self:write {
                        id     = data.id,
                        result = result,
                    }
                else
                    local function pushError(code, message)
                        self:write {
                            id    = data.id,
                            error = {
                                code    = code,
                                message = message,
                            },
                        }
                    end
                    if err == ls.task.REJECT_CLOSED then
                        pushError(ls.spec.ErrorCodes.InternalError, 'Method `{method}` forgot response.' % data)
                        return
                    end
                    if err == ls.task.REJECT_CANCELED then
                        pushError(ls.spec.ErrorCodes.RequestCancelled, 'Request `{method}` was cancelled.' % data)
                        return
                    end
                    if type(err) == 'table' then
                        xpcall(function ()
                            pushError(err.code, err.message)
                        end, function (...)
                            local msg = log.error(...)
                            pushError(ls.spec.ErrorCodes.InternalError, msg)
                        end)
                        return
                    end
                    pushError(ls.spec.ErrorCodes.InternalError, ls.inspect(err))
                end
            end)
            if data.id then
                self.pendingMap[data.id] = task
            end
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
        local task = self:next()

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
