local lclient = require 'lclient'
local fs      = require 'bee.filesystem'
local util    = require 'utility'
local furi    = require 'file-uri'
local ws      = require 'workspace'
local files   = require 'files'

local rootPath = LOGPATH .. '/relative-library'
local rootUri  = furi.encode(rootPath)

for _, name in ipairs { 'src', 'lib' } do
    fs.create_directories(fs.path(rootPath .. '/' .. name))
    util.saveFile(rootPath .. '/' .. name .. '/test.lua', '')
end

---@async
lclient():start(function (client)
    client:registerFakers()

    client:register('workspace/configuration', function ()
        return {
            ['workspace.library'] = {
                './lib',
            }
        }
    end)

    client:initialize {
        rootPath = rootPath,
        rootUri = rootUri
    }

    ws.awaitReady(rootUri .. '/src')

    assert(files.getState(rootUri .. '/src/test.lua')   ~= nil)
    assert(files.getState(rootUri .. '/lib/test.lua')   ~= nil)

    assert(files.isLibrary(rootUri .. '/src/test.lua') == false)
    assert(files.isLibrary(rootUri .. '/lib/test.lua') == true)
end)
