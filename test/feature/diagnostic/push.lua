require 'language-server.task'

local File = require 'feature.diagnostic.file'

local function withMockServer(callback)
    local notifications = {}
    local oldServer = ls.server
    ---@diagnostic disable-next-line: missing-fields
    ls.server = {
        positionEncoding = 'utf-8',
        client = {
            notify = function (_, method, params)
                notifications[#notifications+1] = { method = method, params = params }
            end,
        },
    }
    callback(notifications)
    ls.server = oldServer
    return notifications
end

TEST_FRAME([[
break
]], function ()
    local vfile = test.scope.vm:getFile(test.fileUri)
    assert(vfile)
    vfile.diagnostic = nil

    local notifications = withMockServer(function ()
        ---@diagnostic disable-next-line: await-in-sync
        File.get(vfile):refresh()
        ---@diagnostic disable-next-line: await-in-sync
        ls.await.sleep(0.5)
    end)

    assert(#notifications == 1, 'expected 1 notification, actual ' .. #notifications)
    local n = notifications[1]
    assert(n.method == 'textDocument/publishDiagnostics', tostring(n.method))
    assert(n.params.uri == test.fileUri, tostring(n.params.uri))
    assert(#n.params.diagnostics == 1, 'expected 1 diagnostic, actual ' .. #n.params.diagnostics)
    assert(n.params.diagnostics[1].code == 'break-outside', tostring(n.params.diagnostics[1].code))
end)

TEST_FRAME([[
local x = 1
print(x)
]], function ()
    local vfile = test.scope.vm:getFile(test.fileUri)
    assert(vfile)
    vfile.diagnostic = nil

    local notifications = withMockServer(function ()
        File.get(vfile):dispose()
    end)

    assert(#notifications == 1, 'expected 1 notification, actual ' .. #notifications)
    local n = notifications[1]
    assert(n.method == 'textDocument/publishDiagnostics', tostring(n.method))
    assert(n.params.uri == test.fileUri, tostring(n.params.uri))
    assert(#n.params.diagnostics == 0, 'expected 0 diagnostics, actual ' .. #n.params.diagnostics)
end)

TEST_FRAME([[
local x = 1
print(x)
]], function ()
    local vfile = test.scope.vm:getFile(test.fileUri)
    assert(vfile)
    vfile.diagnostic = nil

    local notifications = withMockServer(function ()
        local file = File.get(vfile)
        ---@diagnostic disable-next-line: missing-fields
        local disposeOld = file:contribute({ {
            code    = 'old',
            level   = 1,
            start   = 0,
            finish  = 1,
            message = 'old',
        } })
        disposeOld()
        ---@diagnostic disable-next-line: missing-fields
        file:contribute({ {
            code    = 'new',
            level   = 1,
            start   = 0,
            finish  = 1,
            message = 'new',
        } })
        ---@diagnostic disable-next-line: await-in-sync
        ls.await.sleep(0.2)
    end)

    assert(#notifications == 1, 'expected 1 notification, actual ' .. #notifications)
    local pushed = notifications[1].params.diagnostics
    assert(#pushed == 1, 'expected 1 diagnostic, actual ' .. #pushed)
    assert(pushed[1].code == 'new', 'expected code new, actual ' .. tostring(pushed[1].code))
end)
