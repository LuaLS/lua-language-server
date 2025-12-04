local transport = require 'transport'
local spec      = require 'lsp.spec'

---@class LanguageServer
local M = Class 'LanguageServer'

---@type 'starting' | 'initializing' | 'initialized' | 'shutdown'
M.status = 'starting'

---@class LanguageServer.Options
---@field transport? 'stdio' | 'socket' # 通讯方式，默认为 'stdio'
---@field port? integer # 当 transport 为 'socket' 时使用的端口
---@field workers? integer # 编译线程数，默认为4

---@param options? LanguageServer.Options
function M:start(options)
    ---@type LanguageServer.Options
    self.options = options or {}
    log.info('Language Server starting with options: ', ls.inspect(self.options))

    self:createWorkers()
    self:startTransport()
end

function M:createWorkers()
    self.compiler = ls.async.create('compiler', 4, 'compiler', true)
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
        local method = task.method
        local registered = ls.capability.registered[method]
        if not registered then
            task:rejectWithCode(spec.ErrorCodes.MethodNotFound, 'Method not found: ' .. tostring(method))
        end
        local callback = registered.callback
        local options  = registered.options

        if self.status ~= 'initialized' and options.needInitialized then
            task:rejectWithCode(spec.ErrorCodes.ServerNotInitialized, 'Server not initialized.')
            return
        end
        if self.status == 'shutdown' and not options.validAfterShutdown then
            task:rejectWithCode(spec.ErrorCodes.InvalidRequest, 'Server is shut down.')
            return
        end

        callback(self, task.params, task)
    end)
end

function M:shutdown()
    if self.status == 'shutdown' then
        return
    end
    self.status = 'shutdown'
end

---@param params LSP.InitializeParams
function M:setClientParams(params)
    self.clientParams = params
end

---@class LanguageServer.API
local API = {}

---@return LanguageServer
function API.create()
    local server = New 'LanguageServer' ()
    return server
end

return API
