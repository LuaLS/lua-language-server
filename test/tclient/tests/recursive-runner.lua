local lclient   = require 'lclient'
local ws        = require 'workspace'
local await     = require 'await'

---@async
lclient():start(function (client)
    client:registerFakers()
    client:initialize()

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = 'file://test.lua',
            languageId = 'lua',
            version = 0,
            text = [[
---@type number
local x

---@type number
local y

x = y

y = x
]]
        }
    })

    ws.awaitReady()

    await.sleep(0.1)

    local hover1 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file://test.lua' },
        position = { line = 1, character = 7 },
    })

    local hover2 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file://test.lua' },
        position = { line = 8, character = 1 },
    })

    assert(hover1.contents.value:find 'number')
    assert(hover2.contents.value:find 'number')
end)
