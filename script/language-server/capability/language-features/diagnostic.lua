local File = require 'feature.diagnostic.file'

ls.capability.registerCapability.diagnosticProvider = {
    interFileDependencies = false,
    workspaceDiagnostics  = false,
}

---@async
ls.capability.register('textDocument/diagnostic', function (_, params, task)
    ---@cast params LSP.DocumentDiagnosticParams

    local uri = params.textDocument.uri
    local scope = ls.scope.find(uri)
    if not scope then
        task:resolve {
            kind     = ls.spec.DocumentDiagnosticReportKind.Unchanged,
            resultId = uri,
        }
        return
    end
    local vfile = scope.vm:getFile(uri)
               or scope.vm:createFile(uri)
    File.get(vfile):refresh()

    task:resolve {
        kind     = ls.spec.DocumentDiagnosticReportKind.Unchanged,
        resultId = uri,
    }
end)
