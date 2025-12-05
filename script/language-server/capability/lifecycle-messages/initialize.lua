ls.capability.register('initialize', function (server, params, task)
    ---@cast params LSP.InitializeParams

    server:initializing(params)

    task:resolve {
        capabilities = ls.capability.serverCapabilities,
        serverInfo = {
            name    = 'lua-language-server',
            version = ls.env.version,
        }
    }
end, { needInitialized = false })
