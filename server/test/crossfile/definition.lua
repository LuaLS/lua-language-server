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

function TEST(datas)
    local lsp = service()
    local ws = workspace(lsp, 'test')
    lsp.workspace = ws

    local compiled = {}
    local targetList, targetUri, sourceList, sourceUri

    for i, data in ipairs(datas) do
        local uri = ws:uriEncode(fs.path(data.path))
        local new, list = catch_target(data.content, '!')
        if new ~= data.content or data.target then
            if data.target then
                targetList = data.target
            else
                targetList = list[1]
            end
            targetUri = uri
            lsp:saveText(uri, 1, new)
            goto CONTINUE
        end
        new, list = catch_target(data.content, '?')
        if new ~= data.content then
            compiled[i] = new
            sourceList = list
            sourceUri = uri
            lsp:saveText(uri, 1, new)
            goto CONTINUE
        end
        lsp:saveText(uri, 1, data.content)
        ::CONTINUE::
        ws:addFile(uri)
    end

    while lsp._needCompile[1] do
        lsp:compileVM(lsp._needCompile[1])
    end

    local sourceVM = lsp:getVM(sourceUri)
    assert(sourceVM)
    local sourcePos = (sourceList[1][1] + sourceList[1][2]) // 2
    local source = core.findSource(sourceVM, sourcePos)
    local positions = core.definition(sourceVM, source, lsp)
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

TEST {
    {
        path = 'a.lua',
        content = [[
            <!global!> = 1
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            print(<?global?>)
        ]],
    }
}

TEST {
    {
        path = 'b.lua',
        content = [[
            print(<?global?>)
        ]],
    },
    {
        path = 'a.lua',
        content = [[
            <!global!> = 1
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            x = {}
            x.<!global!> = 1
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            print(x.<?global?>)
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            x.<!global!> = 1
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            print(x.<?global?>)
        ]],
    },
    {
        path = 'c.lua',
        content = [[
            x = {}
        ]]
    }
}
