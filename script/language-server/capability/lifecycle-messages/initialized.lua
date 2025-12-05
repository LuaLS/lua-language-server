ls.capability.register('initialized', function (server, params, task)
    ---@cast params LSP.InitializedParams

    server:initialized()
end, { needInitialized = false })
