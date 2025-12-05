local spec = require 'lsp.spec'

---@class LanguageClient: Class.Base
local M = Class 'LanguageClient'

---@param params LSP.InitializeParams
function M:initialize(params)
    self.params = params
    self.capabilities = setmetatable(params.capabilities or {}, {
        -- `false` 是全局swallow，省的判空了
        __index = function () return false end
    })
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
    if not self.transport then
        return
    end
    self.transport:notify('window/logMessage', {
        type    = spec[type] or type,
        message = message,
    })
end

---@class LanguageClient.API
local API = {}

---@return LanguageClient
function API.create()
    local client = New 'LanguageClient' ()
    return client
end

return API
