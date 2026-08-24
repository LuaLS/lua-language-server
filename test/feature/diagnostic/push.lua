require 'language-server.task'

local push = require 'feature.diagnostic.push'

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
    local notifications = withMockServer(function ()
        push.refresh(test.fileUri)
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
]], function ()
    local notifications = withMockServer(function ()
        push.clear(test.fileUri)
    end)

    assert(#notifications == 1, 'expected 1 notification, actual ' .. #notifications)
    local n = notifications[1]
    assert(n.method == 'textDocument/publishDiagnostics', tostring(n.method))
    assert(n.params.uri == test.fileUri, tostring(n.params.uri))
    assert(#n.params.diagnostics == 0, 'expected 0 diagnostics, actual ' .. #n.params.diagnostics)
end)
