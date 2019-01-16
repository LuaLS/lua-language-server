local service = require 'service'
local workspace = require 'workspace'
local fs = require 'bee.filesystem'
local core = require 'core'

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

    lsp:saveText(sourceUri, 1, sourceScript)
    ws:addFile(sourceUri)
    lsp:saveText(targetUri, 1, targetScript)
    ws:addFile(targetUri)
    lsp:compileAll()
    lsp:compileAll()

    local sourceVM = lsp:getVM(sourceUri)
    assert(sourceVM)
    local sourcePos = (sourceList[1][1] + sourceList[1][2]) // 2
    local result = core.findResult(sourceVM, sourcePos)
    local positions = core.definition(sourceVM, result, lsp)
    assert(positions and positions[1])
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

TEST {
    {
        path = 'a.lua',
        content = 'local <!t!> = 1; return t',
    },
    {
        path = 'b.lua',
        content = 'local <?t?> = require "a"',
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local t = {
                <!x!> = 1,
            }
            return t
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require "a"
            t.<?x?>()
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return {
                <!x!> = 1,
            }
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require "a"
            t.<?x?>()
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return <!function ()
            end!>
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local f = require "a"
            <?f?>()
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return <!a():b():c()!>
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local <?t?> = require 'a'
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local x = {
                <!a!> = 1,
            }
            return b
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
            t.<?a?>()
        ]]
    }
}
