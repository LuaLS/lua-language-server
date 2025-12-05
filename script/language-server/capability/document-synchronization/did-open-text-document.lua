ls.capability.registerCapability.textDocumentSync = {
    openClose = true,
}

ls.capability.register('textDocument/didOpen', function (server, params, task)
    ---@cast params LSP.DidOpenTextDocumentParams

    local uri = params.textDocument.uri
    local text = params.textDocument.text

    ls.file.setClientText(uri, text, params.textDocument.version)
end)
