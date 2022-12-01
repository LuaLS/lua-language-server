local lclient = require 'lclient'
local fs      = require 'bee.filesystem'
local util    = require 'utility'
local furi    = require 'file-uri'
local ws      = require 'workspace'
local files   = require 'files'
local scope   = require 'workspace.scope'

local rootPath = LOGPATH .. '/same-prefix'
local rootUri  = furi.encode(rootPath)

for _, name in ipairs { 'ws', 'ws1' } do
    fs.create_directories(fs.path(rootPath .. '/' .. name))
end

---@async
lclient():start(function (client)
    client:registerFakers()

    client:initialize {
        rootPath = rootPath,
        rootUri = rootUri,
        workspaceFolders = {
            {
                name = 'ws',
                uri = rootUri .. '/ws',
            },
            {
                name = 'ws1',
                uri = rootUri .. '/ws1',
            },
        }
    }

    ws.awaitReady(rootUri .. '/ws')
    ws.awaitReady(rootUri .. '/ws1')

    files.setText(rootUri .. '/ws1/test.lua', [[
    ]])

    files.setText(rootUri .. '/ws/main.lua', [[
require ''
    ]])

    local comps1 = client:awaitRequest('textDocument/completion', {
        textDocument = {
            uri = rootUri .. '/ws/main.lua',
        },
        position = {
            line = 0,
            character = 9,
        },
    })
    for _, item in ipairs(comps1.items) do
        assert(item.label ~= 'test')
    end
end)
