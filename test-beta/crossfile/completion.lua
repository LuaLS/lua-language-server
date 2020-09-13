local files = require 'files'
local core = require 'core.completion'
local furi = require 'file-uri'

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
    local result = core.completion(mainUri, pos)
    if not expect then
        assert(result == nil)
        return
    end
    assert(result ~= nil)
    for _, item in ipairs(result) do
        local r = core.resolve(item.id)
        for k, v in pairs(r or {}) do
            item[k] = v
        end
        for k in pairs(item) do
            if  not Cared[k] then
                item[k] = nil
            end
        end
    end
    assert(result)
    assert(eq(expect, result))
end

if require'bee.platform'.OS == 'Windows' then

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
            filterText = 'abc',
            kind = CompletionItemKind.Reference,
            documentation = 'abc.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
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
            filterText = 'ABCD',
            kind = CompletionItemKind.Reference,
            documentation = 'ABCD.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
        },
        {
            label = 'abc',
            filterText = 'abc',
            kind = CompletionItemKind.Reference,
            documentation = 'abc.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
        },
    }
}

else

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
            label = 'abc',
            filterText = 'abc',
            kind = CompletionItemKind.Reference,
            documentation = 'abc.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
        },
    }
}

end

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
            filterText = 'abc',
            kind = CompletionItemKind.Reference,
            documentation = 'abc.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
        },
        {
            label = 'abc.init',
            filterText = 'abc.init',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/init.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
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
            filterText = 'abc',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/init.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
        },
        {
            label = 'abc.bbc',
            filterText = 'abc.bbc',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/bbc.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
        },
        {
            label = 'abc.init',
            filterText = 'abc.init',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/init.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
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
        content = 'require "abc.$"',
        main = true,
    },
    completion = {
        {
            label = 'abc.init',
            filterText = 'abc.init',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/init.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
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
            filterText = 'abc.init',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/init.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
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
            filterText = 'core.core',
            kind = CompletionItemKind.Reference,
            documentation = 'core/core.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
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
            label = 'x000',
            filterText = 'x000',
            kind = CompletionItemKind.Reference,
            documentation = 'x000.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
        },
        {
            label = 'x111',
            filterText = 'x111',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/x111.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
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
            detail = '(number) = 1',
        },
        {
            label = 'b',
            kind = CompletionItemKind.Enum,
            detail = '(number) = 2',
        },
        {
            label = 'c',
            kind = CompletionItemKind.Enum,
            detail = '(number) = 3',
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
            detail = '(number) = 1',
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
            detail = '(number) = 1',
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
            filterText = 'xxx',
            kind = CompletionItemKind.Reference,
            documentation = 'xxx.lua',
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
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
            filterText = [[xx'xx]],
            kind = CompletionItemKind.Reference,
            documentation = [[xx'xx.lua]],
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
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
            filterText = [[xx]=]xx]],
            kind = CompletionItemKind.Reference,
            documentation = [[xx]=]xx.lua]],
            textEdit = EXISTS,
            additionalTextEdits = EXISTS,
        },
    }
}
