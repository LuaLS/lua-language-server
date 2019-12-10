local core  = require 'core.completion'
local files = require 'files'
local CompletionItemKind = require 'define.CompletionItemKind'

local EXISTS = {'EXISTS'}

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
            if type(k) == 'number'
            or k == 'label'
            or k == 'kind' then
                if not eq(a[k], b[k]) then
                    return false
                end
                mark[k] = true
            end
        end
        for k in pairs(b) do
            if type(k) == 'number'
            or k == 'label'
            or k == 'kind' then
                if not mark[k] then
                    return false
                end
            end
        end
        return true
    end
    return a == b
end

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        files.removeAll()
        local pos = script:find('$', 1, true) - 1
        local new_script = script:gsub('%$', '')

        files.setText('', new_script)
        local result = core.completion('', pos)
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
za$
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
zabcde$
]]
{
    {
        label = 'zabcdefg',
        kind = CompletionItemKind.Variable,
    },
    {
        label = 'zabcde',
        kind = CompletionItemKind.Variable,
    },
}

TEST [[
local zabcdefg
za$
local zabcde
]]
{
    {
        label = 'zabcdefg',
        kind = CompletionItemKind.Variable,
    },
    {
        label = 'zabcde',
        kind = CompletionItemKind.Text,
    },
}

TEST [[
local zabcde
zace$
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
zac$
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
ass$
]]
{
    {
        label = 'assert',
        kind = CompletionItemKind.Function,
    },
    {
        label = 'assert()',
        kind = CompletionItemKind.Snippet,
    },
}

TEST [[
local zabc = 1
z$
]]
{
    {
        label = 'zabc',
        kind = CompletionItemKind.Variable,
    }
}

TEST [[
local zabc = 1.0
z$
]]
{
    {
        label = 'zabc',
        kind = CompletionItemKind.Variable,
    }
}

TEST [[
local t = {
    abc = 1,
}
t.a$
]]
{
    {
        label = 'abc',
        kind = CompletionItemKind.Enum,
        detail = '(number) = 1',
    }
}

TEST [[
local mt = {}
function mt:get(a, b)
    return 1
end
mt:g$
]]
{
    {
        label = 'get',
        kind = CompletionItemKind.Method,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'get()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        insertText = EXISTS,
        detail = EXISTS,
    },
}

TEST [[
loc$
]]
{
    {
        label = 'collectgarbage',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'collectgarbage()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = EXISTS,
    },
    {
        label = 'local',
        kind = CompletionItemKind.Keyword,
    },
    {
        label = 'local function',
        kind = CompletionItemKind.Snippet,
        insertText = EXISTS,
    }
}

TEST [[
t.a = {}
t.b = {}
t.$
]]
{
    {
        label = 'a',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    },
    {
        label = 'b',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    },
}

TEST [[
t.a = {}
t.b = {}
t.   $
]]
{
    {
        label = 'a',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    },
    {
        label = 'b',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    },
}

TEST [[
t.a = {}
function t:b()
end
t:$
]]
{
    {
        label = 'b',
        kind = CompletionItemKind.Method,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'b()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = EXISTS,
    },
}

TEST [[
local t = {
    a = {},
}
t.$
xxx()
]]
{
    {
        label = 'a',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    },
    {
        label = 'xxx',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'xxx()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = EXISTS,
    },
}

TEST [[
(''):$
]]
(EXISTS)

TEST 'local s = "a:$"' (nil)

TEST 'debug.$'
(EXISTS)

TEST [[
local xxxx = {
    xxyy = 1,
    xxzz = 2,
}

local t = {
    x$
}
]]
{
    {
        label = 'xxxx',
        kind = CompletionItemKind.Variable,
        detail = EXISTS,
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
        label = 'next',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'next()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = EXISTS,
    },
    {
        label = 'xpcall',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'xpcall()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = EXISTS,
    },
}

TEST [[
print(ff2)
local faa
local f$
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
    },
    {
        label = 'function name()',
        kind = CompletionItemKind.Snippet,
        insertText = EXISTS,
    },
    {
        label = 'ff2',
        kind = CompletionItemKind.Text,
    },
    {
        label = 'faa',
        kind = CompletionItemKind.Text,
    },
}

TEST [[
local function f(ff$)
    print(fff)
end
]]
{
    {
        label = 'fff',
        kind = CompletionItemKind.Variable,
    },
}

TEST [[
collectgarbage('$')
]]
{
    {
        label = 'collect',
        filterText = 'collect',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    },
    {
        label = 'stop',
        filterText = 'stop',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    },
    {
        label = 'restart',
        filterText = 'restart',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    },
    {
        label = 'count',
        filterText = 'count',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    },
    {
        label = 'step',
        filterText = 'step',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    },
    {
        label = 'setpause',
        filterText = 'setpause',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    },
    {
        label = 'setstepmul',
        filterText = 'setstepmul',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    },
    {
        label = 'isrunning',
        filterText = 'isrunning',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    },
}

TEST [[
collectgarbage($)
]]
(EXISTS)

TEST [[
io.read($)
]]
{
    {
        label = '"n"',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
    },
    {
        label = '"a"',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
    },
    {
        label = '"l"',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
    },
    {
        label = '"L"',
        kind = CompletionItemKind.EnumMember,
        documentation = EXISTS,
    },
}

TEST [[
local function f(a, $)
end
]]
(nil)

TEST [[
self.results.list[#$]
]]
{
    {
        label = 'self.results.list+1',
        kind = CompletionItemKind.Snippet,
        textEdit = {
            start = 20,
            finish = 20,
            newText = 'self.results.list+1] = ',
        },
    },
}

TEST [[
self.results.list[#self.re$]
]]
{
    {
        label = 'self.results.list+1',
        kind = CompletionItemKind.Snippet,
        textEdit = {
            start = 20,
            finish = 27,
            newText = 'self.results.list+1] = ',
        },
    },
    {
        label = 'results',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    },
}

TEST [[
fff[#ff$]
]]
{
    {
        label = 'fff+1',
        kind = CompletionItemKind.Snippet,
        textEdit = {
            start = 6,
            finish = 8,
            newText = 'fff+1] = ',
        },
    },
    {
        label = 'fff',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    }
}

TEST [[
local _ = fff.kkk[#$]
]]
{
    {
        label = 'fff.kkk',
        kind = CompletionItemKind.Snippet,
        textEdit = {
            start = 20,
            finish = 20,
            newText = 'fff.kkk]',
        },
    },
}

TEST [[
local t = {
    a = 1,
}

t .    $
]]
(EXISTS)

TEST [[
local t = {
    a = 1,
}

t .    $ b
]]
(EXISTS)

TEST [[
local t = {
    a = 1,
}

t $
]]
(nil)

TEST [[
local t = {
    a = 1,
}

t $.
]]
(nil)

TEST [[
local xxxx
xxxx$
]]
{
    {
        label = 'xxxx',
        kind = CompletionItemKind.Variable,
    },
}

TEST [[
local xxxx
local XXXX
xxxx$
]]
{
    {
        label = 'xxxx',
        kind = CompletionItemKind.Variable,
    },
    {
        label = 'XXXX',
        kind = CompletionItemKind.Variable,
    },
}

TEST [[
local t = {
    xxxxx = 1,
}
xx$
]]
{
    {
        label = 'xxxxx',
        kind = CompletionItemKind.Text,
    },
}

TEST [[
local index
tbl[ind$]
]]
{
    {
        label = 'index',
        kind = CompletionItemKind.Variable,
    },
}

TEST [[
return function ()
    local t = {
        a = {},
        b = {},
    }
    t.$
end
]]
{
    {
        label = 'a',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    },
    {
        label = 'b',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    },
}

TEST [[
local ast = 1
local t = 'as$'
local ask = 1
]]
(nil)

TEST [[
local add

function f(a$)
    local _ = add
end
]]
{
    {
        label = 'add',
        kind = CompletionItemKind.Variable,
    },
}

TEST [[
function table.i$
]]
(EXISTS)

TEST [[
do
    xx.$
end
]]
(nil)

require 'config' .config.runtime.version = 'Lua 5.4'
--TEST [[
--local $
--]]
--{
--    {
--        label = '<toclose>',
--        kind = CompletionItemKind.Keyword,
--    },
--    {
--        label = '<const>',
--        kind = CompletionItemKind.Keyword,
--    },
--}
--
--TEST [[
--local <toc$
--]]
--{
--    {
--        label = '<toclose>',
--        kind = CompletionItemKind.Keyword,
--    }
--}

TEST [[
local mt = {}
mt.__index = mt
local t = setmetatable({}, mt)

t.$
]]
{
    {
        label = '__index',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    }
}

TEST [[
local elseaaa
ELSE = 1
if a then
else$
]]
{
    {
        label = 'elseaaa',
        kind = CompletionItemKind.Variable,
    },
    {
        label = 'ELSE',
        kind = CompletionItemKind.Enum,
        detail = EXISTS,
    },
    {
        label = 'select',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'select()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = EXISTS,
    },
    {
        label = 'setmetatable',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'setmetatable()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = EXISTS,
    },
    {
        label = 'else',
        kind = CompletionItemKind.Keyword,
    },
    {
        label = 'elseif',
        kind = CompletionItemKind.Keyword,
    },
    {
        label = 'elseif .. then',
        kind = CompletionItemKind.Snippet,
        insertText = EXISTS,
    }
}

TEST [[
local xpcal
xpcal$
]]
{
    {
        label = 'xpcal',
        kind = CompletionItemKind.Variable,
    },
    {
        label = 'xpcall',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'xpcall()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = EXISTS,
    },
}

TEST [[
function mt:f(a, b, c)
end

mt:f$
]]
{
    {
        label = 'f',
        kind = CompletionItemKind.Method,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'f()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = 'f(${1:a: any}, ${2:b: any}, ${3:c: any})',
    },
}

TEST [[
---@$
]]
(EXISTS)

TEST [[
---@cl$
]]
{
    {
        label = 'class',
        kind = CompletionItemKind.Keyword
    }
}

TEST [[
---@class ZABC
---@class ZBBC : Z$
]]
{
    {
        label = 'ZABC',
        kind = CompletionItemKind.Class,
    },
    {
        label = 'ZBBC',
        kind = CompletionItemKind.Class,
    },
}

TEST [[
---@class zabc
local abcd
---@type za$
]]
{
    {
        label = 'zabc',
        kind = CompletionItemKind.Class,
    },
}

TEST [[
---@class abc
local abcd
---@type $
]]
(EXISTS)

TEST [[
---@class zabc
local abcd
---@type zxxx|z$
]]
{
    {
        label = 'zabc',
        kind = CompletionItemKind.Class,
    }
}

TEST [[
---@alias zabc zabb
---@type za$
]]
{
    {
        label = 'zabc',
        kind = CompletionItemKind.Class,
    },
}

TEST [[
---@class Class
---@param x C$
]]
{
    {
        label = 'Class',
        kind = CompletionItemKind.Class,
    },
    {
        label = 'function',
        kind = CompletionItemKind.Class,
    },
}

TEST [[
---@param $
function f(a, b, c)
end
]]
{
    {
        label = 'a, b, c',
        kind = CompletionItemKind.Snippet,
        insertText = [[
a any
---@param b any
---@param c any]]
    },
    {
        label = 'a',
        kind = CompletionItemKind.Interface,
    },
    {
        label = 'b',
        kind = CompletionItemKind.Interface,
    },
    {
        label = 'c',
        kind = CompletionItemKind.Interface,
    },
}

TEST [[
local function f()
    ---@param $
    function f(a, b, c)
    end
end
]]
{
    {
        label = 'a, b, c',
        kind = CompletionItemKind.Snippet,
        insertText = [[
a any
---@param b any
---@param c any]]
    },
    {
        label = 'a',
        kind = CompletionItemKind.Interface,
    },
    {
        label = 'b',
        kind = CompletionItemKind.Interface,
    },
    {
        label = 'c',
        kind = CompletionItemKind.Interface,
    },
}

TEST [[
---@param $
function mt:f(a, b, c)
end
]]
{
    {
        label = 'a, b, c',
        kind = CompletionItemKind.Snippet,
        insertText = [[
a any
---@param b any
---@param c any]]
    },
    {
        label = 'a',
        kind = CompletionItemKind.Interface,
    },
    {
        label = 'b',
        kind = CompletionItemKind.Interface,
    },
    {
        label = 'c',
        kind = CompletionItemKind.Interface,
    },
}

TEST [[
---@param xyz Class
---@param xxx Class
function f(x$)
]]
{
    {
        label = 'xyz, xxx',
        kind = CompletionItemKind.Snippet,
    },
    {
        label = 'xyz',
        kind = CompletionItemKind.Interface,
    },
    {
        label = 'xxx',
        kind = CompletionItemKind.Interface,
    },
}

TEST [[
---@param xyz Class
---@param xxx Class
function f($
]]
{
    {
        label = 'xyz, xxx',
        kind = CompletionItemKind.Snippet,
    },
    {
        label = 'xyz',
        kind = CompletionItemKind.Interface,
    },
    {
        label = 'xxx',
        kind = CompletionItemKind.Interface,
    },
}

TEST [[
---@param xyz Class
---@param xxx Class
function f($)
]]
{
    {
        label = 'xyz, xxx',
        kind = CompletionItemKind.Snippet,
    },
    {
        label = 'xyz',
        kind = CompletionItemKind.Interface,
    },
    {
        label = 'xxx',
        kind = CompletionItemKind.Interface,
    },
}

TEST [[
local function f()
    ---@t$
end
]]
{
    {
        label = 'type',
        kind = CompletionItemKind.Keyword,
    },
    {
        label = 'return',
        kind = CompletionItemKind.Keyword,
    }
}

TEST [[
---@class Class
---@field name string
---@field id integer
local mt = {}
mt.$
]]
{
    {
        label = 'id',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    },
    {
        label = 'name',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
    },
}

TEST [[
local function f()
    if a then
    else$
end
]]
{
    {
        label = 'select',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'select()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = EXISTS,
    },
    {
        label = 'setmetatable',
        kind = CompletionItemKind.Function,
        documentation = EXISTS,
        detail = EXISTS,
    },
    {
        label = 'setmetatable()',
        kind = CompletionItemKind.Snippet,
        documentation = EXISTS,
        detail = EXISTS,
        insertText = EXISTS,
    },
    {
        label = 'else',
        kind = CompletionItemKind.Keyword,
    },
    {
        label = 'elseif',
        kind = CompletionItemKind.Keyword,
    },
    {
        label = 'elseif .. then',
        kind = CompletionItemKind.Snippet,
        insertText = EXISTS,
    },
}

TEST [[
---@param x string | "'AAA'" | "'BBB'" | "'CCC'"
function f(y, x)
end

f(1, $)
]]
{
    {
        label = "'AAA'",
        kind = CompletionItemKind.EnumMember,
    },
    {
        label = "'BBB'",
        kind = CompletionItemKind.EnumMember,
    },
    {
        label = "'CCC'",
        kind = CompletionItemKind.EnumMember,
    }
}

TEST [[
---@param x string | "'AAA'" | "'BBB'" | "'CCC'"
function f(y, x)
end

f(1,$)
]]
{
    {
        label = "'AAA'",
        kind = CompletionItemKind.EnumMember,
    },
    {
        label = "'BBB'",
        kind = CompletionItemKind.EnumMember,
    },
    {
        label = "'CCC'",
        kind = CompletionItemKind.EnumMember,
    }
}

TEST [[
---@param x string | "'AAA'" | "'BBB'" | "'CCC'"
function f(x)
end

f($)
]]
{
    {
        label = "'AAA'",
        kind = CompletionItemKind.EnumMember,
    },
    {
        label = "'BBB'",
        kind = CompletionItemKind.EnumMember,
    },
    {
        label = "'CCC'",
        kind = CompletionItemKind.EnumMember,
    }
}

TEST [[
---@alias Option string | "'AAA'" | "'BBB'" | "'CCC'"
---@param x Option
function f(x)
end

f($)
]]
{
    {
        label = "'AAA'",
        kind = CompletionItemKind.EnumMember,
    },
    {
        label = "'BBB'",
        kind = CompletionItemKind.EnumMember,
    },
    {
        label = "'CCC'",
        kind = CompletionItemKind.EnumMember,
    }
}

TEST [[
---@param x string | "'AAA'" | "'BBB'" | "'CCC'"
function f(x)
end

f('$')
]]
{
    {
        label = "AAA",
        filterText = 'AAA',
        kind = CompletionItemKind.EnumMember,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    },
    {
        label = "BBB",
        filterText = 'BBB',
        kind = CompletionItemKind.EnumMember,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    },
    {
        label = "CCC",
        filterText = 'CCC',
        kind = CompletionItemKind.EnumMember,
        textEdit = EXISTS,
        additionalTextEdits = EXISTS,
    }
}

TEST [[
---@param x function | 'function () end'
function f(x)
end

f(function ()
    $
end)
]]
(nil)

TEST [[
local t = {
    ['a.b.c'] = {}
}

t.$
]]
{
    {
        label = 'a.b.c',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
        textEdit = {
            start = 37,
            finish = 36,
            newText = '["a.b.c"]',
        },
        additionalTextEdits = {
            {
                start = 36,
                finish = 36,
                newText = '',
            }
        }
    }
}

TEST [[
_ENV['z.b.c'] = {}

z$
]]
{
    {
        label = 'z.b.c',
        kind = CompletionItemKind.Field,
        detail = EXISTS,
        textEdit = {
            start = 22,
            finish = 21,
            newText = '_ENV["z.b.c"]',
        },
        additionalTextEdits = {
            {
                start = 21,
                finish = 21,
                newText = '',
            }
        }
    }
}

TEST [[
io.close(1, $)
]]
(nil)

TEST [[
--- JustTest
---@overload fun(list:table):string
---@overload fun(list:table, sep:string):string
---@overload fun(list:table, sep:string, i:number):string
---@param list table
---@param sep string
---@param i number
---@param j number
---@return string
local function zzzzz(list, sep, i, j) end

zzz$
]]
{
    {
        label = 'zzzzz',
        kind = CompletionItemKind.Function,
        detail = '(function)(4 prototypes)',
        documentation = {
            kind = 'markdown',
            value = [[
```lua
function zzzzz(list: table, sep: string, i: number, j: number)
  -> string
```
JustTest
```lua

```

]]
        },
    },
    {
        label = 'zzzzz()',
        kind = CompletionItemKind.Snippet,
        detail = '(function)(4 prototypes)',
        insertText = EXISTS,
        documentation = EXISTS,
    }
}

TEST [[
--- abc
zzz = 1
zz$
]]
{
    {
        label = 'zzz',
        kind = CompletionItemKind.Enum,
        detail = '(number) = 1',
        documentation = {
            kind = 'markdown',
            value = 'abc',
        }
    }
}

TEST [[
---@param x string
---| "'选项1'" # 注释1
---| "'选项2'" # 注释2
function f(x) end

f($)
]]
{
    {
        label = "'选项1'",
        kind = CompletionItemKind.EnumMember,
        documentation = '注释1',
    },
    {
        label = "'选项2'",
        kind = CompletionItemKind.EnumMember,
        documentation = '注释2',
    },
}
