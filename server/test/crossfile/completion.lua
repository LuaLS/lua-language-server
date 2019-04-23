local service = require 'service'
local workspace = require 'workspace'
local fs = require 'bee.filesystem'
local core = require 'core'

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

function TEST(data)
    local lsp = service()
    local ws = workspace(lsp, 'test')
    lsp.workspace = ws
    ws.root = ROOT

    local mainUri
    local mainBuf
    local pos
    for _, info in ipairs(data) do
        local uri = ws:uriEncode(fs.path(info.path))
        local script = info.content
        if info.main then
            pos = script:find('$', 1, true) - 1
            script = script:gsub('%$', '')
            mainUri = uri
            mainBuf = script
        end
        lsp:saveText(uri, 1, script)
        ws:addFile(uri)

        while lsp._needCompile[1] do
            lsp:compileVM(lsp._needCompile[1])
        end
    end

    local vm = lsp:loadVM(mainUri)
    assert(vm)
    local result = core.completion(vm, mainBuf, pos)
    local expect = data.completion
    if expect then
        assert(result)
        assert(eq(expect, result))
    else
        assert(result == nil)
    end
end

require 'bee.platform'.OS = 'Windows'

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
            label = 'abc',
            kind = CompletionItemKind.Reference,
            documentation = 'abc.lua',
            textEdit = EXISTS,
        },
        {
            label = 'abc.aaa',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/aaa.lua',
            textEdit = EXISTS,
        },
        {
            label = 'abcde',
            kind = CompletionItemKind.Reference,
            documentation = 'xxx/abcde.lua',
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
            documentation = 'abc.lua',
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
            documentation = 'abc.lua',
            textEdit = EXISTS,
        },
        {
            label = 'abc.init',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/init.lua',
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
            documentation = 'abc/init.lua',
            textEdit = EXISTS,
        },
        {
            label = 'abc.bbc',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/bbc.lua',
            textEdit = EXISTS,
        },
        {
            label = 'abc.init',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/init.lua',
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
        content = 'require "abc.$"',
        main = true,
    },
    completion = {
        {
            label = 'abc.init',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/init.lua',
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
            documentation = 'abc/init.lua',
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
            documentation = 'core/core.lua',
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
            label = 'x000',
            kind = CompletionItemKind.Reference,
            documentation = 'x000.lua',
            textEdit = EXISTS,
        },
        {
            label = 'x111',
            kind = CompletionItemKind.Reference,
            documentation = 'abc/x111.lua',
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
            documentation = 'ABCD.lua',
            textEdit = EXISTS,
        },
        {
            label = 'abc',
            kind = CompletionItemKind.Reference,
            documentation = 'abc.lua',
            textEdit = EXISTS,
        },
    }
}

require 'bee.platform'.OS = 'Macos'

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
            kind = CompletionItemKind.Reference,
            documentation = 'abc.lua',
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
            detail = '= 1',
        },
        {
            label = 'b',
            kind = CompletionItemKind.Enum,
            detail = '= 2',
        },
        {
            label = 'c',
            kind = CompletionItemKind.Enum,
            detail = '= 3',
        },
    }
}

TEST {
    {
        path = 'a.lua',
        content = [[
            abc = 1
        ]]
    },
    {
        path = 'a.lua',
        content = [[
            abcd = print
        ]]
    },
    {
        path = 'a.lua',
        content = [[
            abcdef = 1
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            ab$
        ]],
        main = true,
    },
    completion = {
        {
            label = 'abcdef',
            kind = CompletionItemKind.Enum,
            detail = '= 1',
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
            print(abc)
        ]]
    },
    {
        path = 'a.lua',
        content = [[
            abcdef = 1
        ]]
    },
    {
        path = 'b.lua',
        content = [[
            ab$
        ]],
        main = true,
    },
    completion = {
        {
            label = 'abcdef',
            kind = CompletionItemKind.Enum,
            detail = '= 1',
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
            documentation = 'xxx.lua',
            textEdit = EXISTS,
        },
    }
}
