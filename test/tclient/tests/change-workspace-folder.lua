local lclient = require 'lclient'
local fs      = require 'bee.filesystem'
local util    = require 'utility'
local furi    = require 'file-uri'
local ws      = require 'workspace'
local files   = require 'files'
local scope   = require 'workspace.scope'

local rootPath = LOGPATH .. '/change-workspace-folder'
local rootUri  = furi.encode(rootPath)

for _, name in ipairs { 'ws1', 'ws2', 'ws3' } do
    fs.create_directories(fs.path(rootPath .. '/' .. name))
    util.saveFile(rootPath .. '/' .. name .. '/test.lua', '')
end

---@async
lclient():start(function (client)
    client:registerFakers()

    client:initialize {
        rootPath = rootPath,
        rootUri = rootUri,
        workspaceFolders = {
            {
                name = 'ws1',
                uri = rootUri .. '/ws1',
            },
        }
    }

    ws.awaitReady(rootUri .. '/ws1')
    assert(files.getState(rootUri .. '/ws1/test.lua') ~= nil)
    assert(files.getState(rootUri .. '/ws2/test.lua') == nil)
    assert(files.getState(rootUri .. '/ws3/test.lua') == nil)

    client:notify('workspace/didChangeWorkspaceFolders', {
        event = {
            added = {
                {
                    name = 'ws2',
                    uri = rootUri .. '/ws2',
                },
            },
            removed = {},
        },
    })

    ws.awaitReady(rootUri .. '/ws2')
    assert(files.getState(rootUri .. '/ws1/test.lua') ~= nil)
    assert(files.getState(rootUri .. '/ws2/test.lua') ~= nil)
    assert(files.getState(rootUri .. '/ws3/test.lua') == nil)

    client:notify('workspace/didChangeWorkspaceFolders', {
        event = {
            added = {
                {
                    name = 'ws3',
                    uri = rootUri .. '/ws3',
                },
            },
            removed = {},
        },
    })
    ws.awaitReady(rootUri .. '/ws3')
    assert(files.getState(rootUri .. '/ws1/test.lua') ~= nil)
    assert(files.getState(rootUri .. '/ws2/test.lua') ~= nil)
    assert(files.getState(rootUri .. '/ws3/test.lua') ~= nil)

    client:notify('workspace/didChangeWorkspaceFolders', {
        event = {
            added = {},
            removed = {
                {
                    name = 'ws2',
                    uri = rootUri .. '/ws2',
                },
            },
        },
    })

    assert(files.getState(rootUri .. '/ws1/test.lua') ~= nil)
    assert(files.getState(rootUri .. '/ws2/test.lua') == nil)
    assert(files.getState(rootUri .. '/ws3/test.lua') ~= nil)

    client:notify('workspace/didChangeWorkspaceFolders', {
        event = {
            added = {},
            removed = {
                {
                    name = 'ws1',
                    uri = rootUri .. '/ws1',
                },
            },
        },
    })

    assert(files.getState(rootUri .. '/ws1/test.lua') == nil)
    assert(files.getState(rootUri .. '/ws2/test.lua') == nil)
    assert(files.getState(rootUri .. '/ws3/test.lua') ~= nil)

    -- normalize uri
    client:notify('workspace/didChangeWorkspaceFolders', {
        event = {
            added = {
                {
                    name = 'ws2',
                    uri = rootUri .. '%2F%77%73%32'--[[/ws2]],
                },
            },
            removed = {},
        },
    })

    ws.awaitReady(rootUri .. '/ws2')
    assert(files.getState(rootUri .. '/ws1/test.lua') == nil)
    assert(files.getState(rootUri .. '/ws2/test.lua') ~= nil)
    assert(files.getState(rootUri .. '/ws3/test.lua') ~= nil)
end)
