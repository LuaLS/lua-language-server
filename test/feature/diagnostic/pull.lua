require 'language-server.capability'
require 'language-server.capability.language-features.diagnostic'

assert(ls.capability.registered['textDocument/diagnostic'], 'textDocument/diagnostic not registered')
assert(ls.capability.serverCapabilities.diagnosticProvider, 'diagnosticProvider capability not set')
assert(ls.capability.serverCapabilities.diagnosticProvider.workspaceDiagnostics == false, 'workspaceDiagnostics should be false')
assert(ls.capability.serverCapabilities.diagnosticProvider.interFileDependencies == false, 'interFileDependencies should be false')

local function resetDiagnostic()
    local vfile = test.scope.vm:getFile(test.fileUri)
    if vfile then
        vfile.diagnostic = nil
    end
end

local function callHandler(uri)
    local handler = ls.capability.registered['textDocument/diagnostic'].callback
    local resolved
    local mockTask = {
        resolve = function (_, result)
            resolved = result
        end,
    }
    handler({ positionEncoding = 'utf-8' }, { textDocument = { uri = uri } }, mockTask)
    return resolved
end

TEST_FRAME([[
break
]], function ()
    resetDiagnostic()
    local r = callHandler(test.fileUri)
    assert(r, 'pull should resolve')
    assert(r.kind == ls.spec.DocumentDiagnosticReportKind.Unchanged, tostring(r.kind))
    assert(r.resultId == test.fileUri, tostring(r.resultId))
end)
