local lclient   = require 'lclient'
local ws        = require 'workspace'
local util      = require 'utility'

---@async
lclient():start(function (client)
    client:registerFakers()
    client:initialize()

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = 'file://single-file.lua',
            languageId = 'lua',
            version = 0,
            text = [[
local x
print(x)

TEST = 1
print(TEST)
]]
        }
    })

    ws.awaitReady()

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = 'file://single-file.lua' },
        position = { line = 1, character = 7 },
    })

    assert(util.equal(locations, {
        {
            uri = 'file://single-file.lua',
            range = {
                start   = { line = 0, character = 6 },
                ['end'] = { line = 0, character = 7 },
            }
        }
    }))

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = 'file://single-file.lua' },
        position = { line = 1, character = 0 },
    })

    assert(#locations > 0)

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = 'file://single-file.lua' },
        position = { line = 3, character = 0 },
    })

    assert(util.equal(locations, {
        {
            uri = 'file://single-file.lua',
            range = {
                start   = { line = 3, character = 0 },
                ['end'] = { line = 3, character = 4 },
            }
        }
    }))
end)
