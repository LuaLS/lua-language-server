local lclient = require 'tclient.lclient'
local fs      = require 'bee.filesystem'
local util    = require 'utility'
local furi    = require 'file-uri'
local ws      = require 'workspace'
local files   = require 'files'
local scope   = require 'workspace.scope'

---@async
lclient():start(function (client)
    client:registerFakers()

    client:initialize {
        rootUri = 'abc',
    }

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = furi.encode('abc/1.lua'),
            languageId = 'lua',
            version = 0,
            text = [[
local x
print(x)
]]
        }
    })

    ws.awaitReady('abc')

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = furi.encode('abc/1.lua') },
        position = { line = 1, character = 7 },
    })

    assert(util.equal(locations, {
        {
            uri = furi.encode('abc/1.lua'),
            range = {
                start   = { line = 0, character = 6 },
                ['end'] = { line = 0, character = 7 },
            }
        }
    }))

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

    ws.awaitReady(nil)

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = 'test://single-file.lua' },
        position = { line = 1, character = 0 },
    })

    assert(#locations > 0)
end)
