local lclient = require 'lclient'
local util    = require 'utility'
local ws      = require 'workspace'
local files   = require 'files'
local furi    = require 'file-uri'
local fs      = require 'bee.filesystem'

---@async
lclient():start(function (client)
    client:registerFakers()
    client:initialize()

    ws.awaitReady()

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = furi.encode('1.lua'),
            languageId = 'lua',
            version = 0,
            text = [[
---@class AAA
---@source file:///xxx.lua:50
---@field x number
local mt = {}

---@source file:///yyy.lua:30
function mt:ff() end

---@source file:///lib.c
XX = 1

---@source file:///lib.c:30:20
YY = 1
]]
        }
    })

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = furi.encode('main.lua'),
            languageId = 'lua',
            version = 0,
            text = [[
---@type AAA
local a

print(a.x)
print(a.ff)
print(XX)
print(YY)
]]
        }
    })

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = furi.encode('main.lua') },
        position = { line = 3, character = 9 },
    })

    assert(util.equal(locations, {
        {
            uri = 'file:///xxx.lua',
            range = {
                start   = { line = 49, character = 0 },
                ['end'] = { line = 49, character = 0 },
            }
        }
    }))

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = furi.encode('main.lua') },
        position = { line = 4, character = 9 },
    })

    assert(util.equal(locations, {
        {
            uri = 'file:///yyy.lua',
            range = {
                start   = { line = 29, character = 0 },
                ['end'] = { line = 29, character = 0 },
            }
        }
    }))

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = furi.encode('main.lua') },
        position = { line = 5, character = 7 },
    })

    assert(util.equal(locations, {
        {
            uri = 'file:///lib.c',
            range = {
                start   = { line = 0, character = 0 },
                ['end'] = { line = 0, character = 0 },
            }
        }
    }))

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = furi.encode('main.lua') },
        position = { line = 6, character = 7 },
    })

    assert(util.equal(locations, {
        {
            uri = 'file:///lib.c',
            range = {
                start   = { line = 29, character = 20 },
                ['end'] = { line = 29, character = 20 },
            }
        }
    }))
end)
