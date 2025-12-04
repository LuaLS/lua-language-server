---@class Capability
ls.capability = {}

---@class Capability.Options
---@field needInitialized?    boolean
---@field validAfterShutdown? boolean

---@type Capability.Options
ls.capability.defaultOptions = {
    needInitialized    = true,
    validAfterShutdown = false,
}

---@type LSP.ServerCapabilities
ls.capability.serverCapabilities = {}

ls.capability.registered = {}

---@param method string
---@param callback fun(server: LanguageServer, params: table, task: Task)
---@param options? Capability.Options
function ls.capability.register(method, callback, options)
    ls.capability.registered[method] = {
        callback = callback,
        options  = ls.util.tableDefault(options or {}, ls.capability.defaultOptions),
    }
end
