local converter = require 'feature.diagnostic.converter'

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
    vfile.diagnostic:refreshNow()

    task:resolve {
        kind     = ls.spec.DocumentDiagnosticReportKind.Unchanged,
        resultId = uri,
    }
end)

---@async
ls.capability.register('workspace/diagnostic', function (server, params, task)
    ---@cast params LSP.WorkspaceDiagnosticParams

    local items = {}
    for _, scope in ipairs(ls.scope.all) do
        ---@type table<Uri, Feature.Diagnostic[]>
        local results = scope.diagnostic:refreshNow():await()
        for uri, diagnostics in pairs(results) do
            local document = scope:getDocument(uri)
            if document then
                items[#items+1] = {
                    uri    = uri,
                    kind   = ls.spec.DocumentDiagnosticReportKind.Full,
                    items  = converter.convert(document, diagnostics, server.positionEncoding),
                }
            end
        end
    end

    task:resolve {
        items = items,
    }
end)
