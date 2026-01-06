ls.capability.registerCapability.completionProvider = {
    resolveProvider = true,
    completionItem = {
        labelDetailsSupport = true,
    }
}

ls.capability.register('textDocument/completion', function (server, params, task)
    ---@cast params LSP.CompletionParams

end)

ls.capability.register('completionItem/resolve', function (server, params, task)
    ---@cast params LSP.CompletionItem

    task:resolve(params)
end)
