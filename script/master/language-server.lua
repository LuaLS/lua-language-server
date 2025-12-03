---@class LanguageServer
local M = Class 'LanguageServer'

---@class LanguageServer.Options
---@field transport? 'stdio' | 'socket' # 通讯方式，默认为 'stdio'
---@field port? integer # 当 transport 为 'socket' 时使用的端口
---@field workers? integer # 编译线程数，默认为4

---@param options? LanguageServer.Options
function M:start(options)
    ---@type LanguageServer.Options
    self.options = options or {}

    self:startTransport()
end

function M:createWorkers()
    
end

---@private
function M:startTransport()
    
end

---@class LanguageServer.API
local API = {}

---@return LanguageServer
function API.create()
    local server = New 'LanguageServer' ()
    return server
end

return API
