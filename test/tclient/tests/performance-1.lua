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

    local text = [[
local jass = require 'jass.common'

]]

    local clock = os.clock()

    client:awaitRequest('textDocument/didOpen', {
        textDocument = {
            uri = furi.encode('abc/performance-1.lua'),
            languageId = 'lua',
            version = 0,
            text = text,
        }
    })

    await.sleep(1.0)

    for c in ('jass'):gmatch '.' do
        text = text .. c
        client:awaitRequest('textDocument/didChange', {
            textDocument = {
                uri = furi.encode('abc/performance-1.lua'),
            },
            contentChanges = {
                {
                    text = text,
                }
            }
        })
        await.sleep(1.0)
    end

    local items = client:awaitRequest('textDocument/completion', {
        textDocument = { uri = furi.encode('abc/performance-1.lua') },
        position = { line = 2, character = 4 },
    })
    local item = client:awaitRequest('completionItem/resolve', items.items[1])

    assert(item.documentation ~= nil)

    print(('Benchmark [performance-1] takes [%.3f] sec.'):format(os.clock() - clock))
end)
