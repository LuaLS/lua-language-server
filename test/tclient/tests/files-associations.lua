local lclient = require 'lclient'
local ws      = require 'workspace'
local files   = require 'files'
local furi    = require 'file-uri'
local util    = require 'utility'
local fs      = require 'bee.filesystem'

local rootPath = LOGPATH .. '/files-associations'
local rootUri  = furi.encode(rootPath)

fs.create_directories(fs.path(rootPath))

local filePath = rootPath .. '/test.lua.txt'
local fileUri  = furi.encode(filePath)
util.saveFile(filePath, '')

---@async
lclient():start(function (client)
    client:registerFakers()

    client:register('workspace/configuration', function ()
        return {
            {},
            {
                ["*.lua.txt"] = "lua",
            }
        }
    end)

    client:initialize {
        rootPath = rootPath,
        rootUri = rootUri,
        workspaceFolders = {
            {
                name = 'ws',
                uri = rootUri,
            },
        }
    }

    ws.awaitReady(rootUri)

    assert(files.isLua(furi.encode 'aaa.lua.txt') == true)
    assert(files.isLua(furi.encode '/aaa.lua.txt') == true)
    assert(files.isLua(furi.encode 'D:\\aaa.lua.txt') == true)
    assert(files.isLua(fileUri) == true)
    assert(files.exists(fileUri) == true)
end)
