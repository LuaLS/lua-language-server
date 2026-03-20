---@param server LanguageServer
---@param params { id: integer | string }
ls.capability.register('$/cancelRequest', function (server, params)
    local id = params and params.id
    if not id then
        return
    end
    local task = server.transport.pendingMap[id]
    if task then
        task:reject(ls.task.REJECT_CANCELED)
    end
end, { needInitialized = false, validAfterShutdown = true })
