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
    local r1 = callHandler(test.fileUri)
    assert(r1, 'first pull should resolve')
    assert(r1.kind == ls.spec.DocumentDiagnosticReportKind.Full, tostring(r1.kind))
    assert(r1.resultId == test.fileUri, tostring(r1.resultId))
    assert(#r1.items == 1, 'expected 1 item, actual ' .. #r1.items)
    assert(r1.items[1].code == 'break-outside', tostring(r1.items[1].code))

    local r2 = callHandler(test.fileUri)
    assert(r2, 'second pull should resolve')
    assert(r2.kind == ls.spec.DocumentDiagnosticReportKind.Unchanged, tostring(r2.kind))
    assert(r2.resultId == test.fileUri, tostring(r2.resultId))
end)

TEST_FRAME([[
local x = 1
print(x)
]], function ()
    resetDiagnostic()
    local r1 = callHandler(test.fileUri)
    assert(r1, 'clean pull should resolve')
    assert(r1.kind == ls.spec.DocumentDiagnosticReportKind.Full, tostring(r1.kind))
    assert(#r1.items == 0, 'expected 0 items, actual ' .. #r1.items)

    local r2 = callHandler(test.fileUri)
    assert(r2.kind == ls.spec.DocumentDiagnosticReportKind.Unchanged, tostring(r2.kind))
end)
