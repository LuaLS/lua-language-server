local transport = require 'transport'
local spec      = require 'lsp.spec'

---@class LanguageServer: Class.Base
local M = Class 'LanguageServer'

---@type 'starting' | 'initializing' | 'initialized' | 'shutdown'
M.status = 'starting'

---@class LanguageServer.Options
---@field transport? 'stdio' | 'socket' # 通讯方式，默认为 'stdio'
---@field port? integer # 当 transport 为 'socket' 时使用的端口
---@field workers? integer # 编译线程数，默认为4

function M:__init()
    ---@type Scope[]
    self.scopes = {}
end

---@param options? LanguageServer.Options
function M:start(options)
    ---@type LanguageServer.Options
    self.options = options or {}
    log.info('Language Server starting with options: ', ls.inspect(self.options))

    self:startTransport()
end

---@private
function M:startTransport()
    self.transport = transport.create()

    if not self.options.transport or self.options.transport == 'stdio' then
        self.transport:useStdio()
    end

    ---@async
    ls.await.call(function ()
        for task in self.transport:listen() do
            self:resolveTask(task)
        end
    end)
end

---@private
---@param task Task
function M:resolveTask(task)
    task:execute(function ()
        local _ <close> = task
        local method = task.context.method
        local registered = ls.capability.registered[method]
        if not registered then
            task:reject {
                code = spec.ErrorCodes.MethodNotFound,
                message = 'Method not found: ' .. tostring(method),
            }
            return
        end
        local callback = registered.callback
        local options  = registered.options

        if self.status ~= 'initialized' and options.needInitialized then
            task:reject {
                code = spec.ErrorCodes.ServerNotInitialized,
                message = 'Server not initialized.',
            }
            return
        end
        if self.status == 'shutdown' and not options.validAfterShutdown then
            task:reject {
                code = spec.ErrorCodes.InvalidRequest,
                message = 'Server is shut down.',
            }
            return
        end

        callback(self, task.context.params, task)

        task:resolve(nil)
    end)
end

---@param params LSP.InitializeParams
function M:initializing(params)
    assert(self.status == 'starting', 'Invalid server state when initializing: ' .. self.status)
    self.clientParams = params
    self.status = 'initializing'
end

function M:initialized()
    assert(self.status == 'initializing', 'Invalid server state when initialized: ' .. self.status)
    self.status = 'initialized'

    if self.clientParams.workspaceFolders then
        for i, folder in ipairs(self.clientParams.workspaceFolders) do
            local scope = ls.scope.create(folder.name, folder.uri, ls.afs)
            scope:start()
            self.scopes[i] = scope
        end
    end
end

function M:shutdown()
    assert(self.status ~= 'shutdown', 'Invalid server state when shutting down: ' .. self.status)
    self.status = 'shutdown'
end

---@type Encoder.Encoding
M.encoding = nil

---@param self LanguageServer
---@return Encoder.Encoding
---@return boolean
M.__getter.encoding = function (self)
    if not self.clientParams then
        return 'utf-16', false
    end
    local clientEncodings = ls.optional(function ()
        return self.clientParams.capabilities.general.positionEncodings or {}
    end)
    if ls.util.arrayHas(clientEncodings, 'utf-8') then
        return 'utf-8', true
    end
    return 'utf-16', true
end

---@class LanguageServer.API
local API = {}

---@return LanguageServer
function API.create()
    local server = New 'LanguageServer' ()
    return server
end

return API
