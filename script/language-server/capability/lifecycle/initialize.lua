ls.capability.register('initialize', function (server, params, task)
    ---@cast params LSP.InitializeParams

    server:setClientParams(params)

    task:resolve {
        capabilities = {},
        serverInfo = {
            name    = 'lua-language-server',
            version = ls.env.version,
        }
    }
end, { needInitialized = false })
