local service = require 'service'
local workspace = require 'workspace'
local fs = require 'bee.filesystem'
local matcher = require 'matcher'

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
    local pos
    for _, info in ipairs(data) do
        local uri = ws:uriEncode(fs.path(info.path))
        local script = info.content
        if info.main then
            pos = script:find('@', 1, true)
            script = script:gsub('@', '')
            mainUri = uri
        end
        lsp:saveText(uri, 1, script)
        ws:addFile(uri)
    end

    lsp:compileAll()
    lsp:compileAll()

    local vm = lsp:loadVM(mainUri)
    assert(vm)
    local result = matcher.completion(vm, pos)
    local expect = data.completion
    if expect then
        assert(result)
        assert(eq(expect, result))
    else
        assert(result == nil)
    end
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
        content = 'require "a@"',
        main = true,
    },
    completion = {
        {
            label = 'abc',
            kind = CompletionItemKind.Module,
        },
        {
            label = 'abc.aaa',
            kind = CompletionItemKind.Module,
        },
        {
            label = 'abcde',
            kind = CompletionItemKind.Module,
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
        content = 'require "A@"',
        main = true,
    },
    completion = {
        {
            label = 'abc',
            kind = CompletionItemKind.Module,
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
        content = 'require "abc@"',
        main = true,
    },
    completion = {
        {
            label = 'abc.init',
            kind = CompletionItemKind.Module,
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
        content = 'require "abc.@"',
        main = true,
    },
    completion = {
        {
            label = 'abc.init',
            kind = CompletionItemKind.Module,
        },
    }
}
