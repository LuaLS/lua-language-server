local File     = require 'feature.diagnostic.file'
local ScopeDiagnostics = require 'feature.diagnostic.scope'
local converter = require 'feature.diagnostic.converter'

ls.capability.registerCapability.diagnosticProvider = {
    interFileDependencies = false,
    workspaceDiagnostics  = true,
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

---@async
ls.capability.register('workspace/diagnostic', function (server, params, task)
    ---@cast params LSP.WorkspaceDiagnosticParams

    local items = {}
    for _, scope in ipairs(ls.scope.all) do
        local results = ScopeDiagnostics.get(scope):fetchAll()
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
