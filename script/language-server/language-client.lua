---@class LanguageClient: Class.Base
local M = Class 'LanguageClient'

---@param params LSP.InitializeParams
function M:initialize(params)
    self.params = params
    self.capabilities = setmetatable(params.capabilities or {}, {
        -- `false` 是全局swallow，省的判空了
        __index = function () return false end
    })

    self:notify('$/hello', { message = 'world' })
end

---@param transport Transport
function M:setTransport(transport)
    self.transport = transport
end

---@param type LSP.MessageType | integer
---@param message string
function M:logMessage(type, message)
    if not self.capabilities.window.showMessage then
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

---@class LanguageClient.API
local API = {}

---@return LanguageClient
function API.create()
    local client = New 'LanguageClient' ()
    return client
end

return API
