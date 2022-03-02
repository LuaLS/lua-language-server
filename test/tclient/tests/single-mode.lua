local lclient   = require 'lclient'
local ws        = require 'workspace'
local util      = require 'utility'

---@async
lclient():start(function (client)
    client:registerFakers()
    client:initialize()

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = 'test://single-file.lua',
            languageId = 'lua',
            version = 0,
            text = [[
local x
print(x)
]]
        }
    })

    ws.awaitReady()

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = 'test://single-file.lua' },
        position = { line = 1, character = 7 },
    })

    assert(util.equal(locations, {
        {
            uri = 'test://single-file.lua',
            range = {
                start   = { line = 0, character = 6 },
                ['end'] = { line = 0, character = 7 },
            }
        }
    }))

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = 'test://single-file.lua' },
        position = { line = 1, character = 0 },
    })

    assert(#locations > 0)
end)
