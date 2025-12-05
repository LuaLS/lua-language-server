ls.capability.registerCapability.textDocumentSync = {
    openClose = true,
}

ls.capability.register('textDocument/didClose', function (server, params, task)
    ---@cast params LSP.DidCloseTextDocumentParams

    local uri = params.textDocument.uri

    ls.file.removeByClient(uri)
end)
