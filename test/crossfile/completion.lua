local files    = require 'files'
local core     = require 'core.completion'
local furi     = require 'file-uri'
local platform = require 'bee.platform'
local util     = require 'utility'
local config   = require 'config'
local catch    = require 'catch'
local define   = require 'proto.define'
local compare  = require 'compare'

rawset(_G, 'TEST', true)

local CompletionItemKind = define.CompletionItemKind
local NeedRemoveMeta = false

local EXISTS = compare.EXISTS

local Cared = {
    ['label']    = true,
    ['kind']     = true,
    ['textEdit'] = true,
}

local function removeMetas(results)
    local removes = {}
    for i, res in ipairs(results) do
        if res.description and res.description:find 'meta' then
            removes[#removes+1] = i
        end
    end
    util.tableMultiRemove(results, removes)
end

---@diagnostic disable: await-in-sync
local function TEST(data)
    local mainUri
    local pos
    for _, info in ipairs(data) do
        local uri = furi.encode(TESTROOT .. info.path)
        local script = info.content or ''
        if info.main then
            local newScript, catched = catch(script, '?')
            pos = catched['?'][1][1]
            script = newScript
            mainUri = uri
        end
        files.setText(uri, script)
        files.compileState(uri)
    end

    local _ <close> = function ()
        for _, info in ipairs(data) do
            files.remove(furi.encode(TESTROOT .. info.path))
        end
    end

    local expect = data.completion
    local result = core.completion(mainUri, pos, '')
    if not expect then
        assert(result == nil)
        return
    end
    assert(result ~= nil)
    result.complete = nil
    result.enableCommon = nil
    if NeedRemoveMeta then
        removeMetas(result)
    end
    for _, item in ipairs(result) do
        if item.id then
            local r = core.resolve(item.id)
            for k, v in pairs(r or {}) do
                item[k] = v
            end
        end
        for k in pairs(item) do
            if not Cared[k] then
                item[k] = nil
            end
        end
        if item['description'] then
            item['description'] = tostring(item['description'])
                : gsub('\r\n', '\n')
        end
    end
    for _, eitem in ipairs(expect) do
        if eitem['description'] then
            eitem['description'] = eitem['description']
                : gsub('%$(.-)%$', _G)
        end
    end
    assert(result)
    assert(compare.eq(expect, result))
end

local function WITH_CONFIG(cfg, f)
    local prev = { }
    for k, v in pairs(cfg) do
        prev[k] = config.get(nil, k)
        config.set(nil, k, v)
    end
    f()
    for k, v in pairs(prev) do
        config.set(nil, k, v)
    end
end

TEST {
    {
        path = 'abc.lua',
        content = [[
            ---@meta

            ---@class A
            ---@field f1 integer
            ---@field f2 boolean

            ---@type A[]
            X = {}
]],
    },
    {
        path = 'test.lua',
        content = [[ X[1].<??>]],
        main = true,
    },
    completion = {
        {
            label = 'f1',
            kind = CompletionItemKind.Field,
        },
        {
            label = 'f2',
            kind = CompletionItemKind.Field,
        },
    }
}

TEST {
    {
        path = 'abc.lua',
        content = '',
    },
    {
        path = 'abc/aaa.lua',
        content = '',
    },
    {
        path = 'xxx/abcde.lua',
        content = '',
    },
    {
        path = 'test.lua',
        content = 'require "a<??>"',
        main = true,
    },
    completion = {
        {
            label = 'aaa',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'abc',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'abc.aaa',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'abcde',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'xxx.abcde',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

TEST {
    {
        path = 'abc.lua',
        content = '',
    },
    {
        path = 'test.lua',
        content = 'require "A<??>"',
        main = true,
    },
    completion = {
        {
            label = 'abc',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

TEST {
    {
        path = 'abc.lua',
        content = '',
    },
    {
        path = 'ABCD.lua',
        content = '',
    },
    {
        path = 'test.lua',
        content = 'require "a<??>"',
        main = true,
    },
    completion = {
        {
            label = 'ABCD',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'abc',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

TEST {
    {
        path = 'abc.lua',
        content = '',
    },
    {
        path = 'abc/init.lua',
        content = '',
    },
    {
        path = 'test.lua',
        content = 'require "abc<??>"',
        main = true,
    },
    completion = {
        {
            label = 'abc',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'abc.init',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

TEST {
    {
        path = 'abc/init.lua',
        content = '',
    },
    {
        path = 'abc/bbc.lua',
        content = '',
    },
    {
        path = 'test.lua',
        content = 'require "abc<??>"',
        main = true,
    },
    completion = {
        {
            label = 'abc',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'abc.bbc',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'abc.init',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

TEST {
    {
        path = 'abc.lua',
        content = '',
    },
    {
        path = 'abc/init.lua',
        content = '',
    },
    {
        path = 'test.lua',
        content = 'require "abc.i<??>"',
        main = true,
    },
    completion = {
        {
            label = 'abc.init',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

local originSeparator = config.get(nil, 'Lua.completion.requireSeparator')
config.set(nil, 'Lua.completion.requireSeparator', '/')
TEST {
    {
        path = 'abc.lua',
        content = '',
    },
    {
        path = 'abc/init.lua',
        content = '',
    },
    {
        path = 'test.lua',
        content = 'require "abc/i<??>"',
        main = true,
    },
    completion = {
        {
            label = 'abc/init',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}
config.set(nil, 'Lua.completion.requireSeparator', originSeparator)

TEST {
    {
        path = 'core/core.lua',
        content = '',
    },
    {
        path = 'core/xxx.lua',
        content = '',
    },
    {
        path = 'test.lua',
        content = 'require "core.co<??>"',
        main = true,
    },
    completion = {
        {
            label = 'core.core',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

TEST {
    {
        path = 'x000.lua',
        content = '',
    },
    {
        path = 'abc/x111.lua',
        content = '',
    },
    {
        path = 'abc/test.lua',
        content = 'require "x<??>"',
        main = true,
    },
    completion = {
        {
            label = 'abc.x111',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'x000',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'x111',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}


local originRuntimePath = config.get(nil, 'Lua.runtime.path')
config.set(nil, 'Lua.runtime.path', {
    '?/1.lua',
})

TEST {
    {
        path = 'tt/xxxx/1.lua',
        content = '',
    },
    {
        path = 'main.lua',
        content = 'require "x<??>"',
        main = true,
    },
    completion = {
        {
            label = 'tt.xxxx',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'xxxx',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

config.set(nil, 'Lua.runtime.path', originRuntimePath)

local originRuntimePath = config.get(nil, 'Lua.runtime.path')
config.set(nil, 'Lua.runtime.path', {
    'tt/?/1.lua',
})

TEST {
    {
        path = 'tt/xxxx/1.lua',
        content = '',
    },
    {
        path = 'main.lua',
        content = 'require "x<??>"',
        main = true,
    },
    completion = {
        {
            label = 'xxxx',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

config.set(nil, 'Lua.runtime.path', originRuntimePath)

TEST {
    {
        path = 'abc.lua',
        content = '---@meta _',
    },
    {
        path = 'test.lua',
        content = 'require "a<??>"',
        main = true,
    },
    completion = nil
}

TEST {
    {
        path = 'abc.lua',
        content = '---@meta xxxxx',
    },
    {
        path = 'test.lua',
        content = 'require "a<??>"',
        main = true,
    },
    completion = nil
}

TEST {
    {
        path = 'abc.lua',
        content = '---@meta xxxxx',
    },
    {
        path = 'test.lua',
        content = 'require "xx<??>"',
        main = true,
    },
    completion = {
        {
            label = 'xxxxx',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        }
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            return {
                a = 1,
                b = 2,
                c = 3,
            }
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            local t = require 'a'
            t.<??>
        ]],
        main = true,
    },
    completion = {
        {
            label = 'a',
            kind = CompletionItemKind.Enum,
        },
        {
            label = 'b',
            kind = CompletionItemKind.Enum,
        },
        {
            label = 'c',
            kind = CompletionItemKind.Enum,
        },
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            zabc = 1
        ]]
    },
    {
        path = 'a.lua',
        content = [[
            zabcd = print
        ]]
    },
    {
        path = 'a.lua',
        content = [[
            zabcdef = 1
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            zab<??>
        ]],
        main = true,
    },
    completion = {
        {
            label = 'zabcdef',
            kind = CompletionItemKind.Enum,
        },
    }
}

TEST {
    {
        path = 'init.lua',
        content = [[
            setmetatable(_G, {__index = {}})
        ]]
    },
    {
        path = 'a.lua',
        content = [[
            print(zabc)
        ]]
    },
    {
        path = 'a.lua',
        content = [[
            zabcdef = 1
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            zab<??>
        ]],
        main = true,
    },
    completion = {
        {
            label = 'zabcdef',
            kind = CompletionItemKind.Enum,
        },
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            local japi = require 'jass.japi'
            japi.xxxaaaaxxxx
        ]]
    },
    {
        path = 'a.lua',
        content = [[
            local japi = require 'jass.japi'
            japi.xxxaaaax<??>
        ]],
        main = true,
    },
    completion = nil,
}

NeedRemoveMeta = true

TEST {
    { path = 'f/a.lua' },
    { path = 'f/b.lua' },
    {
        path = 'c.lua',
        content = [[
            require '<??>'
        ]],
        main = true,
    },
    completion = {
        {
            label = 'a',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'b',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'f.a',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'f.b',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

TEST {
    { path = 'f/a.lua' },
    { path = 'f/b.lua' },
    {
        path = 'c.lua',
        content = [[
            require 'a<??>'
        ]],
        main = true,
    },
    completion = {
        {
            label = 'a',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'f.a',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

config.set(nil, 'Lua.runtime.pathStrict', true)

TEST {
    { path = 'f/a.lua' },
    { path = 'f/b.lua' },
    {
        path = 'c.lua',
        content = [[
            require '<??>'
        ]],
        main = true,
    },
    completion = {
        {
            label = 'f.a',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
        {
            label = 'f.b',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

TEST {
    { path = 'f/a.lua' },
    { path = 'f/b.lua' },
    {
        path = 'c.lua',
        content = [[
            require 'a<??>'
        ]],
        main = true,
    },
    completion = {
        {
            label = 'f.a',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

config.set(nil, 'Lua.runtime.pathStrict', false)

TEST {
    {
        path = 'xxx.lua',
        content = ''
    },
    {
        path = 'xxxx.lua',
        content = [[
            require 'xx<??>'
        ]],
        main = true,
    },
    completion = {
        {
            label = 'xxx',
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

TEST {
    {
        path = [[xx'xx.lua]],
        content = ''
    },
    {
        path = 'main.lua',
        content = [[
            require 'xx<??>'
        ]],
        main = true,
    },
    completion = {
        {
            label = [[xx'xx]],
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

TEST {
    {
        path = [[xx]=]xx.lua]],
        content = ''
    },
    {
        path = 'main.lua',
        content = [[
            require [=[xx<??>]=]'
        ]],
        main = true,
    },
    completion = {
        {
            label = [[xx]=]xx]],
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}

if require 'bee.platform'.OS == 'Windows' then
TEST {
    {
        path = [[abc/init.lua]],
        content = ''
    },
    {
        path = 'main.lua',
        content = [[
            dofile 'ab<??>'
        ]],
        main = true,
    },
    completion = {
        {
            label = [[abc/init.lua]],
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}
else
TEST {
    {
        path = [[abc/init.lua]],
        content = ''
    },
    {
        path = 'main.lua',
        content = [[
            dofile 'ab<??>'
        ]],
        main = true,
    },
    completion = {
        {
            label = [[abc/init.lua]],
            kind = CompletionItemKind.File,
            textEdit = EXISTS,
        },
    }
}
end

TEST {
    {
        path    = 'a.lua',
        content = [[
            local t = {
                x = 1,
            }
            return t
        ]]
    },
    {
        path    = 'b.lua',
        main    = true,
        content = [[
            local t = require 'a'
            local v = setmetatable({}, {__index = t})
            v.<??>
        ]]
    },
    completion = {
        {
            label  = 'x',
            kind   = CompletionItemKind.Enum,
        }
    }
}

Cared['description'] = true
TEST {
    {
        path = [[a.lua]],
        content = [[
            local m = {}

            return m
        ]]
    },
    {
        path = 'main.lua',
        content = [[
            local z = require 'a'

            z<??>
        ]],
        main = true,
    },
    completion = {
        {
            label = 'z',
            kind = CompletionItemKind.Variable,
            description = [[
```lua
local z: table
```]]
        },
    }
}

if platform.os == 'windows' then
Cared['detail'] = true
Cared['additionalTextEdits'] = true
TEST {
    {
        path = 'myfunc.lua',
        content = [[
            return function (a, b)
            end
        ]]
    },
    {
        path = 'main.lua',
        main = true,
        content = [[
            myfun<??>
        ]],
    },
    completion = {
        {
            label = 'myfunc',
            kind  = CompletionItemKind.Variable,
            detail = 'function',
            description = [[
从 [myfunc.lua]($TESTROOTURI$myfunc.lua) 中导入

```lua
function (a: any, b: any)
```]],
        }
    }
}


TEST {
    {
        path = 'dir/myfunc.lua',
        content = [[
            return function (a, b)
            end
        ]]
    },
    {
        path = 'main.lua',
        main = true,
        content = [[
            myfun<??>
        ]],
    },
    completion = {
        {
            label = 'myfunc',
            kind  = CompletionItemKind.Variable,
            detail = 'function',
            description = [[
从 [dir\myfunc.lua]($TESTROOTURI$dir/myfunc.lua) 中导入

```lua
function (a: any, b: any)
```]],
        }
    }
}

Cared['detail'] = nil
Cared['additionalTextEdits'] = nil
end

TEST {
    {
        path = 'a.lua',
        content = [[
            A.B = 1
        ]]
    },
    {
        path = 'main.lua',
        main = true,
        content = [[
            A.<??>
        ]],
    },
    completion = EXISTS,
}

TEST {
    { path = 'a.lua', content = '' },
    {
        path = 'main.lua',
        main = true,
        content = [[
            require'<??>
        ]]
    },
    completion = EXISTS
}

TEST {
    { path = 'a.lua', content = '' },
    {
        path = 'main.lua',
        main = true,
        content = [[
            ---@module <??>
        ]]
    },
    completion = EXISTS
}

TEST {
    { path = 'abcde.lua', content = '' },
    {
        path = 'main.lua',
        main = true,
        content = [[
            ---@module 'ab<??>'
        ]]
    },
    completion = EXISTS
}

config.prop(nil, 'Lua.runtime.special', 'import', 'require')
TEST {
    { path = 'abcde.lua', content = '' },
    {
        path = 'main.lua',
        main = true,
        content = [[
            import 'ab<??>'
        ]]
    },
    completion = EXISTS
}

-- Find obscured modules

WITH_CONFIG({
    ["Lua.runtime.pathStrict"] = true,
    ["Lua.runtime.path"] = {
        "?/init.lua",
        "sub/?/init.lua",
        "obscure_path/?/?/init.lua"
    },
}, function()
    TEST {
        { path = 'myLib/init.lua', content = 'return {}' },
        {
            path = 'main.lua',
            main = true,
            content = [[
                myLib<??>
            ]],
        },
        completion = EXISTS
    }

    TEST {
        { path = 'sub/myLib/init.lua', content = 'return {}' },
        {
            path = 'main.lua',
            main = true,
            content = [[
                myLib<??>
            ]],
        },
        completion = EXISTS
    }

    TEST {
        { path = 'sub/myLib/sublib/init.lua', content = 'return {}' },
        {
            path = 'main.lua',
            main = true,
            content = [[
                sublib<??>
            ]],
        },
        completion = EXISTS
    }

    TEST {
        { path = 'sublib/init.lua', content = 'return {}' },
        {
            path = 'main.lua',
            main = true,
            content = [[
                sublib<??>
            ]],
        },
        completion = EXISTS
    }

    TEST {
        { path = 'obscure_path/myLib/obscure/myLib/obscure/init.lua', content = 'return {}' },
        {
            path = 'main.lua',
            main = true,
            content = [[
                obscure<??>
            ]],
        },
        completion = EXISTS
    }
end)
