local spec = require 'lsp.spec'

ls.capability.registerCapability.textDocumentSync = {
    change = spec.TextDocumentSyncKind.Incremental,
}

ls.capability.register('textDocument/didChange', function (server, params, task)
    ---@cast params LSP.DidChangeTextDocumentParams

    local uri = params.textDocument.uri
    local changes = params.contentChanges
    local version = params.textDocument.version

    ls.file.applyClientChanges(uri, changes, version, server.encoding)
end)
