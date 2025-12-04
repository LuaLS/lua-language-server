ls.capability.register('initialize', function (server, params, task)
    ---@cast params LSP.InitializeParams

    server:setClientParams(params)

    task:resolve {
        capabilities = {},
        serverInfo = {
            name    = 'lua-language-server',
            version = '4.0.0',
        }
    }
end, { needInitialized = false })
