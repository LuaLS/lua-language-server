local files    = require 'files'
local core     = require 'core.completion'
local furi     = require 'file-uri'
local platform = require 'bee.platform'
local util     = require 'utility'
local config   = require 'config'
local catch    = require 'catch'

rawset(_G, 'TEST', true)

local CompletionItemKind = {
    Text = 1,
    Method = 2,
    Function = 3,
    Constructor = 4,
    Field = 5,
    Variable = 6,
    Class = 7,
    Interface = 8,
    Module = 9,
    Property = 10,
    Unit = 11,
    Value = 12,
    Enum = 13,
    Keyword = 14,
    Snippet = 15,
    Color = 16,
    File = 17,
    Reference = 18,
    Folder = 19,
    EnumMember = 20,
    Constant = 21,
    Struct = 22,
    Event = 23,
    Operator = 24,
    TypeParameter = 25,
}

local EXISTS = {}

local function eq(a, b)
    if a == EXISTS and b ~= nil then
        return true
    end
    local tp1, tp2 = type(a), type(b)
    if tp1 ~= tp2 then
        return false
    end
    if tp1 == 'table' then
        local mark = {}
        for k in pairs(a) do
            if not eq(a[k], b[k]) then
                return false
            end
            mark[k] = true
        end
        for k in pairs(b) do
            if not mark[k] then
                return false
            end
        end
        return true
    end
    return a == b
end

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
function TEST(data)
    files.removeAll()

    local mainUri
    local pos
    for _, info in ipairs(data) do
        local uri = furi.encode(info.path)
        local script = info.content or ''
        if info.main then
            local newScript, catched = catch(script, '?')
            pos = catched['?'][1][1]
            script = newScript
            mainUri = uri
        end
        files.setText(uri, script)
    end

    local expect = data.completion
    core.clearCache()
    local result = core.completion(mainUri, pos, '')
    if not expect then
        assert(result == nil)
        return
    end
    assert(result ~= nil)
    result.enableCommon = nil
    removeMetas(result)
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
    assert(result)
    assert(eq(expect, result))
end

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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'abc',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'abc.aaa',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'abcde',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'xxx.abcde',
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'abc',
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'abc.init',
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'abc.bbc',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'abc.init',
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
    }
}

local originSeparator = config.get 'Lua.completion.requireSeparator'
config.set('Lua.completion.requireSeparator', '/')
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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
    }
}
config.set('Lua.completion.requireSeparator', originSeparator)

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
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'x000',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'x111',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
    }
}


local originRuntimePath = config.get 'Lua.runtime.path'
config.set('Lua.runtime.path', {
    '?/1.lua',
})

TEST {
    {
        path = 'D:/xxxx/1.lua',
        content = '',
    },
    {
        path = 'main.lua',
        content = 'require "x<??>"',
        main = true,
    },
    completion = {
        {
            label = 'D:.xxxx',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'xxxx',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
    }
}

config.set('Lua.runtime.path', originRuntimePath)

local originRuntimePath = config.get 'Lua.runtime.path'
config.set('Lua.runtime.path', {
    'D:/?/1.lua',
})

TEST {
    {
        path = 'D:/xxxx/1.lua',
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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
    }
}

config.set('Lua.runtime.path', originRuntimePath)

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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'b',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'f.a',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'f.b',
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'f.a',
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
    }
}

config.set('Lua.runtime.pathStrict', true)

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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
        {
            label = 'f.b',
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
            textEdit = EXISTS,
        },
    }
}

config.set('Lua.runtime.pathStrict', false)

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
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
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
            label = [[abc\init.lua]],
            kind = CompletionItemKind.Reference,
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
            kind = CompletionItemKind.Reference,
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
local z: {}
```]]
        },
    }
}

if platform.OS == 'Windows' then
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
从 [myfunc.lua](file:///myfunc.lua) 中导入

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
从 [dir\myfunc.lua](file:///dir/myfunc.lua) 中导入

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

config.prop('Lua.runtime.special', 'import', 'require')
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
