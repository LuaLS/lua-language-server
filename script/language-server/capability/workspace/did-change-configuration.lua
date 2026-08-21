---@async
ls.capability.register('workspace/didChangeConfiguration', function (server, params)
    ---@cast params LSP.DidChangeConfigurationParams
    for _, scope in ipairs(server.scopes) do
        server:loadClientConfig(scope)
    end
    for _, scope in ipairs(server.scopes) do
        scope:reload({})
    end
end)
