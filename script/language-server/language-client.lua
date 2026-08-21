---@class LanguageClient: Class.Base
local M = Class 'LanguageClient'

---@param params LSP.InitializeParams
function M:initialize(params)
    self.params = params
    self.capabilities = params.capabilities or {}

    self:notify('$/hello', { message = 'world' })
end

---@param transport Transport
function M:setTransport(transport)
    self.transport = transport
end

---@param type LSP.MessageType | integer
---@param message string
function M:logMessage(type, message)
    if not self.capabilities.window?.showMessage then
        return
    end
    self:notify('window/logMessage', {
        type    = ls.spec[type] or type,
        message = message,
    })
end

---@param protoName string
---@param params table
---@return boolean
function M:notify(protoName, params)
    if not self.transport then
        return false
    end
    self.transport:notify(protoName, params)
    return true
end

---@param method string
---@param params? table
---@param callback function
---@return boolean
function M:request(method, params, callback)
    if not self.transport then
        return false
    end
    self.transport:request(method, params, callback)
    return true
end

---@async
---@param method string
---@param params? table
---@return any
function M:awaitRequest(method, params)
    if not self.transport then
        return nil
    end
    return ls.await.yield(function (resume)
        self.transport:request(method, params, resume)
    end)
end

---@class LanguageClient.API
local API = {}

---@return LanguageClient
function API.create()
    local client = New 'LanguageClient' ()
    return client
end

return API
