local spec = require 'lsp.spec'

ls.capability.registerCapability.textDocumentSync = {
    change = spec.TextDocumentSyncKind.Full,
}

ls.capability.register('textDocument/didChange', function (server, params, task)
    ---@cast params LSP.DidChangeTextDocumentParams

    local uri = params.textDocument.uri
    local text = params.contentChanges[1].text
    local version = params.textDocument.version

    ls.file.setClientText(uri, text, version)
end)
