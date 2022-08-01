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
---@class Class
local m

---@return Class
function m:f() end

---@type Class
local v
v = v:f()
]]
        }
    })

    ws.awaitReady()

    await.sleep(0.1)

    local hover1 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file://test.lua' },
        position = { line = 7, character = 6 },
    })

    local hover2 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file://test.lua' },
        position = { line = 8, character = 0 },
    })

    assert(hover1.contents.value:find 'Class')
    assert(hover2.contents.value:find 'Class')
end)
