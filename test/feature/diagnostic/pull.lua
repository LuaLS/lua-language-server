require 'language-server.capability'
require 'language-server.capability.language-features.diagnostic'

assert(ls.capability.registered['textDocument/diagnostic'], 'textDocument/diagnostic not registered')
assert(ls.capability.serverCapabilities.diagnosticProvider, 'diagnosticProvider capability not set')
assert(ls.capability.serverCapabilities.diagnosticProvider.workspaceDiagnostics == false, 'workspaceDiagnostics should be false')
assert(ls.capability.serverCapabilities.diagnosticProvider.interFileDependencies == false, 'interFileDependencies should be false')

TEST_FRAME([[
break
]], function ()
    local handler = ls.capability.registered['textDocument/diagnostic'].callback
    local resolved
    local mockTask = {
        resolve = function (_, result)
            resolved = result
        end,
    }
    local mockServer = { positionEncoding = 'utf-8' }
    handler(mockServer, { textDocument = { uri = test.fileUri } }, mockTask)

    assert(resolved, 'handler did not resolve')
    assert(resolved.kind == ls.spec.DocumentDiagnosticReportKind.Full, tostring(resolved.kind))
    assert(#resolved.items == 1, 'expected 1 item, actual ' .. #resolved.items)
    assert(resolved.items[1].code == 'break-outside', tostring(resolved.items[1].code))
end)

TEST_FRAME([[
local x = 1
]], function ()
    local handler = ls.capability.registered['textDocument/diagnostic'].callback
    local resolved
    local mockTask = {
        resolve = function (_, result)
            resolved = result
        end,
    }
    local mockServer = { positionEncoding = 'utf-8' }
    local unknownUri = ls.uri.encode(test.rootPath .. '/nonexistent.lua')
    handler(mockServer, { textDocument = { uri = unknownUri } }, mockTask)

    assert(resolved, 'handler did not resolve')
    assert(resolved.kind == ls.spec.DocumentDiagnosticReportKind.Full, tostring(resolved.kind))
    assert(#resolved.items == 0, 'expected 0 items, actual ' .. #resolved.items)
end)
