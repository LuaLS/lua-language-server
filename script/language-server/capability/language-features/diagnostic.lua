local converter = require 'feature.diagnostic.converter'
local File      = require 'feature.diagnostic.file'

ls.capability.registerCapability.diagnosticProvider = {
    interFileDependencies = false,
    workspaceDiagnostics  = false,
}

---@async
ls.capability.register('textDocument/diagnostic', function (server, params, task)
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
    local document = scope:getDocument(uri)
    if not document then
        task:resolve {
            kind     = ls.spec.DocumentDiagnosticReportKind.Unchanged,
            resultId = uri,
        }
        return
    end
    local results = File.get(vfile):fetch()
    if not results then
        task:resolve {
            kind     = ls.spec.DocumentDiagnosticReportKind.Unchanged,
            resultId = uri,
        }
        return
    end
    local items = converter.convert(document, results, server.positionEncoding)
    task:resolve {
        kind     = ls.spec.DocumentDiagnosticReportKind.Full,
        resultId = uri,
        items    = items,
    }
end)
