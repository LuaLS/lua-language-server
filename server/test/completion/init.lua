local matcher = require 'matcher'
local parser  = require 'parser'

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

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        local pos = script:find('@', 1, true)
        local new_script = script:gsub('@', '')
        local ast = parser:ast(new_script)
        local vm = matcher.vm(ast)
        assert(vm)
        local result = matcher.completion(vm, pos)
        if expect then
            assert(result)
            assert(eq(expect, result))
        else
            assert(result == nil)
        end
    end
end

TEST [[
local zabcde
za@
]]
{
    {
        label = 'zabcde',
        kind = CompletionItemKind.Variable,
    }
}

TEST [[
local zabcdefg
local zabcde
zabcde@
]]
{
    {
        label = 'zabcdefg',
        kind = CompletionItemKind.Variable,
    }
}

TEST [[
local zabcdefg
za@
local zabcde
]]
{
    {
        label = 'zabcdefg',
        kind = CompletionItemKind.Variable,
    }
}

TEST [[
local zabcde
zace@
]]
{
    {
        label = 'zabcde',
        kind = CompletionItemKind.Variable,
    }
}

TEST [[
ZABC
local zabc
zac@
]]
{
    {
        label = 'zabc',
        kind = CompletionItemKind.Variable,
    },
    {
        label = 'ZABC',
        kind = CompletionItemKind.Field,
    },
}

TEST [[
as@
]]
{
    {
        label = 'assert',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
    }
}

TEST [[
local t = {
    abc = 1,
}
t.a@
]]
{
    {
        label = 'abc',
        kind = CompletionItemKind.Enum,
        detail = '= 1',
    }
}

TEST [[
local zabc = 1
z@
]]
{
    {
        label = 'zabc',
        kind = CompletionItemKind.Variable,
        detail = '= 1',
    }
}

TEST [[
local zabc = 1.0
z@
]]
{
    {
        label = 'zabc',
        kind = CompletionItemKind.Variable,
        detail = '= 1.0',
    }
}

TEST [[
local mt = {}
function mt:get(a, b)
    return 1
end
mt:g@
]]
{
    {
        label = 'get',
        kind = CompletionItemKind.Method,
        documentation = EXISTS,
    }
}

TEST [[
loc@
]]
{
    {
        label = 'local',
        kind = CompletionItemKind.Keyword,
    }
}

TEST [[
t.a = {}
t.b = {}
t.@
]]
{
    {
        label = 'a',
        kind = CompletionItemKind.Field,
    },
    {
        label = 'b',
        kind = CompletionItemKind.Field,
    },
}

TEST [[
t.a = {}
function t:b()
end
t:@
]]
{
    {
        label = 'b',
        kind = CompletionItemKind.Method,
        documentation = EXISTS,
    }
}

TEST [[
local t = {
    a = {},
}
t.@
xxx()
]]
{
    {
        label = 'a',
        kind = CompletionItemKind.Field,
    },
    {
        label = 'xxx',
        kind = CompletionItemKind.Method,
        documentation = EXISTS,
    },
}

TEST [[
(''):@
]]
(EXISTS)

TEST 'local s = "a:@"' (nil)

TEST [[
local xxxx = {
    xxyy = 1,
    xxzz = 2,
}

local t = {
    x@
}
]]
{
    {
        label = 'xxxx',
        kind = CompletionItemKind.Variable,
    },
    {
        label = 'xxyy',
        kind = CompletionItemKind.Property,
    },
    {
        label = 'xxzz',
        kind = CompletionItemKind.Property,
    },
    {
        label = 'xpcall',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
    }
}

TEST [[
local faa
local f@
print(fff)
]]
{
    {
        label = 'fff',
        kind = CompletionItemKind.Variable,
    },
    {
        label = 'function',
        kind = CompletionItemKind.Keyword,
    }
}

TEST [[
local function f(f@)
    print(fff)
end
]]
{
    {
        label = 'fff',
        kind = CompletionItemKind.Variable,
    },
}
