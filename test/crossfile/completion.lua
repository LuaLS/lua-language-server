local files = require 'files'
local core = require 'core.completion'
local furi = require 'file-uri'
local platform = require 'bee.platform'

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

function TEST(data)
    files.removeAll()

    local mainUri
    local pos
    for _, info in ipairs(data) do
        local uri = furi.encode(info.path)
        local script = info.content
        if info.main then
            pos = script:find('$', 1, true) - 1
            script = script:gsub('%$', '')
            mainUri = uri
        end
        files.setText(uri, script)
    end

    local expect = data.completion
    core.clearCache()
    local result = core.completion(mainUri, pos)
    if not expect then
        assert(result == nil)
        return
    end
    assert(result ~= nil)
    result.enableCommon = nil
    for _, item in ipairs(result) do
        local r = core.resolve(item.id)
        for k, v in pairs(r or {}) do
            item[k] = v
        end
        for k in pairs(item) do
            if not Cared[k] then
                item[k] = nil
            end
        end
        if item['description'] then
            item['description'] = item['description']
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
        content = 'require "a$"',
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
        content = 'require "A$"',
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
        content = 'require "a$"',
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
        content = 'require "abc$"',
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
        content = 'require "abc$"',
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
        content = 'require "abc.i$"',
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
        content = 'require "core.co$"',
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
        content = 'require "x$"',
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
            t.$
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
            zab$
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
            zab$
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
            japi.xxxaaaax$
        ]],
        main = true,
    },
}

TEST {
    {
        path = 'xxx.lua',
        content = ''
    },
    {
        path = 'xxxx.lua',
        content = [[
            require 'xx$'
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
            require 'xx$'
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
            require [=[xx$]=]'
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
            dofile 'ab$'
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
            dofile 'ab$'
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
            v.$
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

            z$
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
            myfun$
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
            additionalTextEdits = {
                {
                    start   = 1,
                    finish  = 0,
                    newText = 'local myfunc = require "myfunc"\n'
                }
            }
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
            myfun$
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
            additionalTextEdits = {
                {
                    start   = 1,
                    finish  = 0,
                    newText = 'local myfunc = require "dir.myfunc"\n'
                }
            }
        }
    }
}

Cared['detail'] = nil
Cared['additionalTextEdits'] = nil
end
