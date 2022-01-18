local lclient = require 'tclient.lclient'
local util    = require 'utility'
local ws      = require 'workspace'
local files   = require 'files'
local furi    = require 'file-uri'
local fs      = require 'bee.filesystem'

local libraryPath   = LOGPATH .. '/large-file-library'
local largeFilePath = LOGPATH .. '/large-file-library/large-file.lua'

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
    util.saveFile(largeFilePath, string.rep('--this is a large file\n', 100000))

    client:initialize()

    ws.awaitReady()

    assert(files.getState(furi.encode(largeFilePath)) ~= nil)
end)
