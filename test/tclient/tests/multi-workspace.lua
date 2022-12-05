local lclient = require 'lclient'
local fs      = require 'bee.filesystem'
local util    = require 'utility'
local furi    = require 'file-uri'
local ws      = require 'workspace'
local files   = require 'files'
local scope   = require 'workspace.scope'

local rootPath = LOGPATH .. '/multi-workspace'
local rootUri  = furi.encode(rootPath)

for _, name in ipairs { 'ws1', 'ws2', 'share', 'lb1', 'lb2' } do
    fs.create_directories(fs.path(rootPath .. '/' .. name))
    util.saveFile(rootPath .. '/' .. name .. '/test.lua', '')
end

---@async
lclient():start(function (client)
    client:registerFakers()

    client:register('workspace/configuration', function (params)
        local uri = params.items[1].scopeUri
        if uri == rootUri .. '/ws1' then
            return {
                {
                    ['workspace.library'] = {
                        rootPath .. '/share',
                        rootPath .. '/lb1',
                    }
                }
            }
        end
        if uri == rootUri .. '/ws2' then
            return {
                {
                    ['workspace.library'] = {
                        rootPath .. '/share',
                        rootPath .. '/lb2',
                    }
                }
            }
        end
        return {}
    end)

    client:initialize {
        rootPath = rootPath,
        rootUri = rootUri,
        workspaceFolders = {
            {
                name = 'ws1',
                uri = rootUri .. '/ws1',
            },
            {
                name = 'ws2',
                uri = rootUri .. '/ws2',
            },
        }
    }

    ws.awaitReady(rootUri .. '/ws1')
    ws.awaitReady(rootUri .. '/ws2')

    assert(files.getState(rootUri .. '/ws1/test.lua')   ~= nil)
    assert(files.getState(rootUri .. '/ws2/test.lua')   ~= nil)
    assert(files.getState(rootUri .. '/share/test.lua') ~= nil)
    assert(files.getState(rootUri .. '/lb1/test.lua')   ~= nil)
    assert(files.getState(rootUri .. '/lb2/test.lua')   ~= nil)

    assert(scope.getScope(rootUri .. '/ws1/test.lua').uri   == rootUri .. '/ws1')
    assert(scope.getScope(rootUri .. '/ws2/test.lua').uri   == rootUri .. '/ws2')
    assert(scope.getScope(rootUri .. '/share/test.lua').uri == rootUri .. '/ws1')
    assert(scope.getScope(rootUri .. '/lb1/test.lua').uri   == rootUri .. '/ws1')
    assert(scope.getScope(rootUri .. '/lb2/test.lua').uri   == rootUri .. '/ws2')

    assert(files.isLibrary(rootUri .. '/ws1/test.lua')   == false)
    assert(files.isLibrary(rootUri .. '/ws2/test.lua')   == false)
    assert(files.isLibrary(rootUri .. '/share/test.lua') == true)
    assert(files.isLibrary(rootUri .. '/lb1/test.lua')   == true)
    assert(files.isLibrary(rootUri .. '/lb2/test.lua')   == true)

    files.setText(rootUri .. '/ws1/unittest.lua', [[
GLOBAL = 1
---@class ZAAA
---@type Z
    ]])

    files.setText(rootUri .. '/ws2/unittest.lua', [[
GLOBAL = 2
---@class ZBBB
---@type Z
    ]])

    local defs1 = client:awaitRequest('textDocument/definition', {
        textDocument = {
            uri = rootUri .. '/ws1/unittest.lua',
        },
        position = {
            line = 0,
            character = 0,
        },
    })
    assert(#defs1 == 1)

    local defs2 = client:awaitRequest('textDocument/definition', {
        textDocument = {
            uri = rootUri .. '/ws2/unittest.lua',
        },
        position = {
            line = 0,
            character = 0,
        },
    })
    assert(#defs2 == 1)

    local comps1 = client:awaitRequest('textDocument/completion', {
        textDocument = {
            uri = rootUri .. '/ws1/unittest.lua',
        },
        position = {
            line = 2,
            character = 10,
        },
    })
    assert(#comps1.items == 1)

    local comps2 = client:awaitRequest('textDocument/completion', {
        textDocument = {
            uri = rootUri .. '/ws2/unittest.lua',
        },
        position = {
            line = 2,
            character = 10,
        },
    })
    assert(#comps2.items == 1)
end)
