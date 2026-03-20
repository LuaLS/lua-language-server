ls.capability.register('initialize', function (server, params, task)
    ---@cast params LSP.InitializeParams

    log.info('Initializing, client params: {}' % { ls.inspect(params) })
    server:initializing(params)

    local serverParams = {
        capabilities = ls.capability.serverCapabilities,
        serverInfo = {
            name    = 'lua-language-server',
            version = ls.env.version,
        }
    }
    log.info('Initializing, server params: {}' % { ls.inspect(serverParams) })
    task:resolve(serverParams)
end, { needInitialized = false })
