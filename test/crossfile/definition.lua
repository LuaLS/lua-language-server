local service = require 'service'
local workspace = require 'workspace'
local fs = require 'bee.filesystem'
local core = require 'core'
local uric = require 'uri'

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

local function founded(targets, results)
    if #targets ~= #results then
        return false
    end
    for _, target in ipairs(targets) do
        for _, result in ipairs(results) do
            if target[1] == result[1]
            and target[2] == result[2]
            and target[3] == result[3]
            then
                goto NEXT
            end
        end
        do return false end
        ::NEXT::
    end
    return true
end

function TEST(datas)
    local lsp = service()
    local ws = lsp:addWorkspace('test', uric.encode(ROOT))

    local compiled = {}
    local targetList = {}
    local sourceList, sourceUri

    for i, data in ipairs(datas) do
        local uri = uric.encode(ROOT / fs.path(data.path))
        local new, list = catch_target(data.content, '!')
        if new ~= data.content or data.target then
            if data.target then
                targetList[#targetList+1] = {
                    data.target[1],
                    data.target[2],
                    uri
                }
            else
                for _, position in ipairs(list) do
                    targetList[#targetList+1] = {
                        position[1],
                        position[2],
                        uri
                    }
                end
            end
            data.content = new
        end
        new, list = catch_target(data.content, '?')
        if new ~= data.content then
            compiled[i] = new
            sourceList = list
            sourceUri = uri
            data.content = new
        end
        lsp:saveText(uri, 1, data.content)
        ws:addFile(uric.decode(uri))
    end

    while lsp._needCompile[1] do
        lsp:compileVM(lsp._needCompile[1])
    end

    local sourceVM = lsp:getVM(sourceUri)
    assert(sourceVM)
    local sourcePos = (sourceList[1][1] + sourceList[1][2]) // 2
    local positions = core.definition(sourceVM, sourcePos, 'definition')
    if positions then
        assert(founded(targetList, positions))
    else
        assert(#targetList == 0)
    end
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
        target = {7, 7},
    },
}

if require 'bee.platform'.OS == 'Windows' then
TEST {
    {
        path = 'a.lua',
        content = '',
        target = {0, 0},
    },
    {
        path = 'b.lua',
        content = 'require <?"A"?>',
    },
}
end

TEST {
    {
        path = 'a.lua',
        content = 'local <!t!> = 1; return t',
    },
    {
        path = 'b.lua',
        content = 'local <?t?> = require "a"',
        target = {7, 7},
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
            local <!f!> = require "a"
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
        target = {19, 19},
    },
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

TEST {
    {
        path = 'a.lua',
        content = [[
            return function (<!arg!>)
                print(<?arg?>)
            end
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local f = require 'a'
            local v = 1
            f(v)
        ]],
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return <!{
                a = 1,
            }!>
        ]],
    },
    {
        path = 'b.lua',
        content = [[
            local <!t!> = require 'a'
            <?t?>
        ]],
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return <!function () end!>
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local f = require 'a'
        ]]
    },
    {
        path = 'c.lua',
        content = [[
            local <!f!> = require 'a'
            <?f?>
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local function <!f!>()
            end
            return f
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local f = require 'a'
        ]]
    },
    {
        path = 'c.lua',
        content = [[
            local <!f!> = require 'a'
            <?f?>
        ]]
    }
}

TEST {
    {
        path = 'a/xxx.lua',
        content = [[
            return <!function () end!>
        ]]
    },
    {
        path = 'b/xxx.lua',
        content = [[
            local <!f!> = require 'xxx'
            <?f?>
            return function () end
        ]]
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@class Class
            local <!obj!>
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            ---@type Class
            local <!obj!>
            <?obj?>
        ]]
    },
}

TEST {
    {
        path = 'a.lua',
        content = [[
            ---@type Class
            local <!obj!>
            <?obj?>
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            ---@class Class
            local <!obj!>
        ]]
    },
}
