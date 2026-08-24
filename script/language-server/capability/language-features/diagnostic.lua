local converter = require 'feature.diagnostic.converter'

ls.capability.registerCapability.diagnosticProvider = {
    interFileDependencies = false,
    workspaceDiagnostics  = false,
}

---@async
ls.capability.register('textDocument/diagnostic', function (server, params, task)
    ---@cast params LSP.DocumentDiagnosticParams

    local uri = params.textDocument.uri
    local document = ls.scope.findDocument(uri)
    if not document then
        task:resolve {
            kind  = ls.spec.DocumentDiagnosticReportKind.Full,
            items = {},
        }
        return
    end

    local diagnostics = ls.feature.diagnostic(uri)
    local items = converter.convert(document, diagnostics, server.positionEncoding)

    task:resolve {
        kind  = ls.spec.DocumentDiagnosticReportKind.Full,
        items = items,
    }
end)
