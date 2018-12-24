local service = require 'service'
local workspace = require 'workspace'
local fs = require 'bee.filesystem'
local matcher = require 'matcher'

rawset(_G, 'TEST', true)

local function catch_target(script, sep)
    local list = {}
    local cur = 1
    local cut = 0
    while true do
        local start, finish  = script:find(('<%%%s.-%%%s>'):format(sep, sep), cur)
        if not start then
            break
        end
        list[#list+1] = { start - cut, finish - 4 - cut }
        cur = finish + 1
        cut = cut + 4
    end
    local new_script = script:gsub(('<%%%s(.-)%%%s>'):format(sep, sep), '%1')
    return new_script, list
end

function TEST(data)
    local lsp = service()
    local ws = workspace(lsp, 'test')
    lsp.workspace = ws

    local targetScript, targetList = catch_target(data[1].content, '!')
    local targetUri = ws:uriEncode(fs.path(data[1].path))
    if data[1].target then
        targetList = data[1].target
    else
        targetList = targetList[1]
    end

    local sourceScript, sourceList = catch_target(data[2].content, '?')
    local sourceUri = ws:uriEncode(fs.path(data[2].path))

    lsp:saveText(targetUri, 1, targetScript)
    lsp:saveText(sourceUri, 1, sourceScript)
    ws:addFile(targetUri)
    ws:addFile(sourceUri)
    lsp:compileVM(targetUri)
    lsp:compileVM(sourceUri)

    local sourceVM = lsp:loadVM(sourceUri)
    assert(sourceVM)
    local sourcePos = (sourceList[1][1] + sourceList[1][2]) // 2
    local positions = matcher.definition(sourceVM, sourcePos)
    assert(positions)
    local start, finish, valueUri = positions[1][1], positions[1][2], positions[1][3]
    assert(valueUri == targetUri)
    assert(start == targetList[1])
    assert(finish == targetList[2])
end

TEST {
    {
        path = 'a.lua',
        content = '',
        target = {0, 0},
    },
    {
        path = 'b.lua',
        content = 'require <?"a"?>',
    },
}
