require 'language-server.capability'
require 'language-server.progress'
require 'language-server.capability.language-features.diagnostic'

assert(ls.capability.registered['textDocument/diagnostic'], 'textDocument/diagnostic not registered')
assert(ls.capability.registered['workspace/diagnostic'], 'workspace/diagnostic not registered')
assert(ls.capability.serverCapabilities.diagnosticProvider, 'diagnosticProvider capability not set')
assert(ls.capability.serverCapabilities.diagnosticProvider.workspaceDiagnostics == true, 'workspaceDiagnostics should be true')
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

TEST_FRAME([[
break
]], function ()
    local handler = ls.capability.registered['workspace/diagnostic'].callback
    local resolved
    local mockTask = {
        resolve = function (_, result)
            resolved = result
        end,
    }
    ---@diagnostic disable-next-line: await-in-sync
    handler({ positionEncoding = 'utf-8' }, {}, mockTask)
    assert(resolved, 'workspace diagnostic should resolve')
    assert(type(resolved.items) == 'table', 'missing items')
    local report
    for _, item in ipairs(resolved.items) do
        if item.uri == test.fileUri then
            report = item
            break
        end
    end
    assert(report, 'missing report for test file')
    assert(report.kind == ls.spec.DocumentDiagnosticReportKind.Full, tostring(report.kind))
    assert(#report.items == 1, 'expected 1 diagnostic, actual ' .. #report.items)
    assert(report.items[1].code == 'break-outside', tostring(report.items[1].code))
end)
