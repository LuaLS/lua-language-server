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

---@type LSP.ServerCapabilities
ls.capability.registerCapability = setmetatable({}, {
    __newindex = function (t, k, v)
        ls.util.tableExtends(ls.capability.serverCapabilities, { [k] = v }, true)
    end
})

ls.capability.registered = {}

---@param method string
---@param callback async fun(server: LanguageServer, params: table, task: Task)
---@param options? Capability.Options
function ls.capability.register(method, callback, options)
    ls.capability.registered[method] = {
        callback = callback,
        options  = ls.util.tableDefault(options or {}, ls.capability.defaultOptions),
    }
end
