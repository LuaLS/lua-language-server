local lclient   = require 'lclient'
local ws        = require 'workspace'
local util      = require 'utility'

---@async
lclient():start(function (client)
    client:registerFakers()
    client:initialize()

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = 'file://test.lua',
            languageId = 'lua',
            version = 0,
            text = [[
---@type integer
local xxxx

x
]]
        }
    })

    ws.awaitReady()

    local completions = client:awaitRequest('textDocument/completion', {
        textDocument = { uri = 'file://test.lua' },
        position = { line = 3, character = 1 },
    })

    client:awaitRequest('textDocument/didChange',
    {
        textDocument = { uri = 'file://test.lua' },
        contentChanges = {
            {
                range = {
                    start = { line = 3, character = 1 },
                    ['end'] = { line = 3, character = 1 },
                },
                text = 'x'
            }
        }
    })

    local targetItem
    for _, item in ipairs(completions.items) do
        if item.label == 'xxxx' then
            targetItem = item
            break
        end
    end

    assert(targetItem ~= nil)

    local newItem = client:awaitRequest('completionItem/resolve', targetItem)

    assert(newItem.detail == 'integer')
end)
