local lclient = require 'lclient'
local util    = require 'utility'
local ws      = require 'workspace'
local files   = require 'files'
local furi    = require 'file-uri'
local fs      = require 'bee.filesystem'
local await   = require 'await'

---@async
lclient():start(function (client)
    client:registerFakers()

    client:register('workspace/configuration', function ()
        return {
            {
                ['workspace.library'] = { '${3rd}/Jass/library' }
            },
        }
    end)

    client:initialize()

    ws.awaitReady()

    local clock = os.clock()

    for i = 1, 10 do
        local text = [[
local jass = require 'jass.common'

]]

        client:awaitRequest('textDocument/didOpen', {
            textDocument = {
                uri = furi.encode('abc/1.lua'),
                languageId = 'lua',
                version = i,
                text = text,
            }
        })

        for c in ('jass'):gmatch '.' do
            text = text .. c
            client:awaitRequest('textDocument/didChange', {
                textDocument = {
                    uri = furi.encode('abc/1.lua'),
                },
                contentChanges = {
                    {
                        text = text,
                    }
                }
            })
        end

        local results = client:awaitRequest('textDocument/definition', {
            textDocument = { uri = furi.encode('abc/1.lua') },
            position = { line = 2, character = 4 },
        })

        assert(results[1] ~= nil)

        client:awaitRequest('textDocument/didClose', {
            textDocument = { uri = furi.encode('abc/1.lua') },
        })
    end

    print(('Benchmark [performance-jass-common] takes [%.3f] sec.'):format(os.clock() - clock))
end)
