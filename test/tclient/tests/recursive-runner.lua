local lclient   = require 'lclient'
local ws        = require 'workspace'
local await     = require 'await'
local config    = require 'config'
local vm        = require 'vm'
local guide     = require 'parser.guide'
local files     = require 'files'

---@async
lclient():start(function (client)
    client:registerFakers()
    client:initialize()

    config.set(nil, 'Lua.diagnostics.enable', false)

    ws.awaitReady()

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = 'file:///test.lua',
            languageId = 'lua',
            version = 0,
            text = [[
---@type number
local x

---@type number
local y

x = y

y = x
]]
        }
    })

    await.sleep(0.1)

    local hover1 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 1, character = 7 },
    })

    local hover2 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 8, character = 1 },
    })

    assert(hover1.contents.value:find 'number')
    assert(hover2.contents.value:find 'number')

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = 'file:///test.lua',
            languageId = 'lua',
            version = 1,
            text = [[
---@type number
local x

---@type number
local y

---@type number
local z

x = y
y = z
z = y
x = y
x = z
z = x
y = x
]]
        }
    })


    await.sleep(0.1)

    local hover1 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 9, character = 0 },
    })

    local hover2 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 10, character = 0 },
    })

    local hover3 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 11, character = 0 },
    })

    local hover4 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 12, character = 0 },
    })

    local hover5 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 13, character = 0 },
    })

    local hover6 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 14, character = 0 },
    })

    local hover7 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 15, character = 0 },
    })

    assert(hover1.contents.value:find 'number')
    assert(hover2.contents.value:find 'number')
    assert(hover3.contents.value:find 'number')
    assert(hover4.contents.value:find 'number')
    assert(hover5.contents.value:find 'number')
    assert(hover6.contents.value:find 'number')
    assert(hover7.contents.value:find 'number')

    client:notify('textDocument/didOpen', {
        textDocument = {
            uri = 'file:///test.lua',
            languageId = 'lua',
            version = 2,
            text = [[
---@meta

---@class vector3
---@operator add(vector3): vector3
---@operator sub(vector3): vector3
---@operator mul(vector3): number
---@operator mul(number):  vector3
---@operator div(number):  vector3
local mt

---@return vector3
function mt:normalize() end

---@param target vector3
function Walk(target)
    local moveSpeed = 1.0
    local deltalTime = 2.0

    ---@type vector3
    local curPos
    local targetDirVec = (target - curPos):normalize()
    local stepMove = targetDirVec * (moveSpeed * deltalTime)
    local nextPos = curPos + stepMove

    curPos = nextPos
end
]]
        }
    })

    local hover1 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 20, character = 11 },
    })
    assert(hover1.contents.value:find 'vector3')

    vm.clearNodeCache()
    local state = files.getState('file:///test.lua')
    assert(state)
    guide.eachSourceType(state.ast, 'call', function (src)
        vm.compileNode(src)
    end)

    local hover1 = client:awaitRequest('textDocument/hover', {
        textDocument = { uri = 'file:///test.lua' },
        position = { line = 20, character = 11 },
    })
    assert(hover1.contents.value:find 'vector3')

    config.set(nil, 'Lua.diagnostics.enable', true)
end)
