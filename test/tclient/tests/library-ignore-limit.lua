local lclient = require 'tclient.lclient'
local util    = require 'utility'
local ws      = require 'workspace'
local files   = require 'files'
local furi    = require 'file-uri'

local libraryPath   = LOGPATH .. '/large-file-library'
local largeFilePath = LOGPATH .. '/large-file-library/large-file.lua'

---@async
lclient():start(function (client)
    client:registerFakers()

    client:register('workspace/configuration', function ()
        return {
            ['Lua.workspace.library'] = { libraryPath }
        }
    end)

    util.saveFile(largeFilePath, string.rep('--this is a large file\n', 20000))

    client:initialize()

    ws.awaitReady()

    assert(files.getState(furi.encode(largeFilePath)) ~= nil)
end)
