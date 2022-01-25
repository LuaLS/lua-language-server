local lclient = require 'tclient.lclient'
local util    = require 'utility'
local ws      = require 'workspace'
local files   = require 'files'
local furi    = require 'file-uri'
local fs      = require 'bee.filesystem'

local libraryPath     = LOGPATH .. '/load-library'
local libraryFilePath = LOGPATH .. '/load-library/library-file.lua'

---@async
lclient():start(function (client)
    client:registerFakers()

    client:register('workspace/configuration', function ()
        return {
            {
                ['workspace.library'] = { libraryPath }
            },
        }
    end)

    fs.create_directories(fs.path(libraryPath))
    if not fs.exists(fs.path(libraryFilePath)) then
        util.saveFile(libraryFilePath, 'LIBRARY_FILE = true')
    end

    client:initialize()

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = furi.encode('abc/1.lua'),
            languageId = 'lua',
            version = 0,
            text = [[
require 'library-file'
print(LIBRARY_FILE)
]]
        }
    })

    ws.awaitReady()

    local locations = client:awaitRequest('textDocument/definition', {
        textDocument = { uri = furi.encode('abc/1.lua') },
        position = { line = 0, character = 10 },
    })

    assert(util.equal(locations, {
        {
            uri = furi.encode(libraryFilePath),
            range = {
                start   = { line = 0, character = 0 },
                ['end'] = { line = 0, character = 0 },
            }
        }
    }))
end)
