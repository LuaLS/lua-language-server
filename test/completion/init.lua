local core   = require 'core.completion'
local files  = require 'files'
local define = require 'proto.define'
local config = require 'config'

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

local Cared = {
    ['label']               = true,
    ['kind']                = true,
    ['textEdit']            = true,
    ['additionalTextEdits'] = true,
    ['deprecated']          = true,
}

function TEST(script)
    return function (expect)
        files.removeAll()
        local pos = script:find('$', 1, true) - 1
        local new_script = script:gsub('%$', '')

        files.setText('', new_script)
        local result = core.completion('', pos)
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
                if not Cared[k] then
                    item[k] = nil
                end
            end
        end
        assert(result)
        assert(eq(expect, result))
    end
end

config.config.completion.callSnippet    = 'Both'
config.config.completion.keywordSnippet = 'Both'

TEST [[
local zabcde
za$
]]
{
    {
        label = 'zabcde',
        kind = define.CompletionItemKind.Variable,
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
        kind = define.CompletionItemKind.Variable,
    },
    {
        label = 'zabcde',
        kind = define.CompletionItemKind.Variable,
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
        kind = define.CompletionItemKind.Variable,
    },
    {
        label = 'zabcde',
        kind = define.CompletionItemKind.Text,
    },
}

TEST [[
local zabcde
zace$
]]
{
    {
        label = 'zabcde',
        kind = define.CompletionItemKind.Variable,
    }
}

TEST [[
ZABC = x
local zabc
zac$
]]
{
    {
        label = 'zabc',
        kind = define.CompletionItemKind.Variable,
    },
    {
        label = 'ZABC',
        kind = define.CompletionItemKind.Field,
    },
}

TEST [[
ass$
]]
{
    {
        label = 'assert',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'assert()',
        kind  = define.CompletionItemKind.Snippet,
    },
}

TEST [[
local assert = 1
ass$
]]
{
    {
        label = 'assert',
        kind  = define.CompletionItemKind.Variable,
    },
}

TEST [[
local assert = 1
_G.ass$
]]
{
    {
        label = 'assert',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'assert()',
        kind  = define.CompletionItemKind.Snippet,
    },
}

TEST [[
local function ffff(a, b)
end
ff$
]]
{
    {
        label = 'ffff',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'ffff()',
        kind  = define.CompletionItemKind.Snippet,
    }
}

TEST [[
local zabc = 1
z$
]]
{
    {
        label = 'zabc',
        kind = define.CompletionItemKind.Variable,
    }
}

TEST [[
local zabc = 1.0
z$
]]
{
    {
        label = 'zabc',
        kind = define.CompletionItemKind.Variable,
    }
}

TEST [[
local t = {
    abc = 1,
}
t.ab$
]]
{
    {
        label = 'abc',
        kind = define.CompletionItemKind.Enum,
    }
}

TEST [[
local t = {
    abc = 1,
}
local n = t.abc
t.ab$
]]
{
    {
        label = 'abc',
        kind = define.CompletionItemKind.Enum,
    }
}

TEST [[
local mt = {}
mt.ggg = 1
function mt:get(a, b)
    return 1
end
mt:g$
]]
{
    {
        label = 'get',
        kind = define.CompletionItemKind.Method,
    },
    {
        label = 'get()',
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'ggg',
        kind  = define.CompletionItemKind.Text,
    }
}

TEST [[
loc$
]]
{
    {
        label = 'local',
        kind = define.CompletionItemKind.Keyword,
    },
    {
        label = 'local function',
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'collectgarbage',
        kind = define.CompletionItemKind.Function,
    },
    {
        label = 'collectgarbage()',
        kind = define.CompletionItemKind.Snippet,
    },
}

TEST [[
do$
]]
{
    {
        label = 'do',
        kind = define.CompletionItemKind.Keyword,
    },
    {
        label = 'do .. end',
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'dofile',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'dofile()',
        kind  = define.CompletionItemKind.Snippet,
    },
    {
        label = 'load',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'load()',
        kind  = define.CompletionItemKind.Snippet,
    },
    {
        label = 'loadfile',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'loadfile()',
        kind  = define.CompletionItemKind.Snippet,
    },
    {
        label = 'loadstring',
        kind  = define.CompletionItemKind.Function,
        deprecated = true,
    },
    {
        label = 'loadstring()',
        kind  = define.CompletionItemKind.Snippet,
        deprecated = true,
    },
    {
        label = 'module',
        kind  = define.CompletionItemKind.Function,
        deprecated = true,
    },
    {
        label = 'module()',
        kind  = define.CompletionItemKind.Snippet,
        deprecated = true,
    },
}

TEST [[
while true d$
]]
{
    {
        label = 'do',
        kind = define.CompletionItemKind.Keyword,
    },
    {
        label = 'do .. end',
        kind = define.CompletionItemKind.Snippet,
    },
}

TEST [[
results$
]]
(nil)

TEST [[
results$
local results
]]
(EXISTS)

TEST [[
local a$

local function f(fff)
    fff = ast
    fff = ast
    fff = ast
    fff = ast
    fff = ast
    fff = ast
end
]]
{
    {
        label = 'ast',
        kind = define.CompletionItemKind.Variable,
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
        kind = define.CompletionItemKind.Field,
    },
    {
        label = 'b',
        kind = define.CompletionItemKind.Field,
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
        kind = define.CompletionItemKind.Field,
    },
    {
        label = 'b',
        kind = define.CompletionItemKind.Field,
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
        kind = define.CompletionItemKind.Method,
    },
    {
        label = 'b()',
        kind = define.CompletionItemKind.Snippet,
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
        kind = define.CompletionItemKind.Field,
    },
}

TEST [[
(''):$
]]
(EXISTS)

TEST [[
local zzz

return 'aa' .. zz$
]]
{
    {
        label = 'zzz',
        kind = define.CompletionItemKind.Variable,
    },
}

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
        kind = define.CompletionItemKind.Variable,
    },
    {
        label = 'xxyy',
        kind = define.CompletionItemKind.Property,
    },
    {
        label = 'xxzz',
        kind = define.CompletionItemKind.Property,
    },
    {
        label = 'next',
        kind = define.CompletionItemKind.Function,
    },
    {
        label = 'next()',
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'xpcall',
        kind = define.CompletionItemKind.Function,
    },
    {
        label = 'xpcall()',
        kind = define.CompletionItemKind.Snippet,
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
        label = 'function',
        kind = define.CompletionItemKind.Keyword,
    },
    {
        label = 'function ()',
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'fff',
        kind = define.CompletionItemKind.Variable,
    },
    {
        label = 'ff2',
        kind = define.CompletionItemKind.Text,
    },
    {
        label = 'faa',
        kind = define.CompletionItemKind.Text,
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
        kind = define.CompletionItemKind.Variable,
    },
}

TEST [[
collectgarbage($)
]]
(EXISTS)

TEST [[
collectgarbage('$')
]]
{
    {
        label       = "'collect'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 16,
            finish  = 17,
            newText = "'collect'",
        },
    },
    {
        label       = "'stop'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 16,
            finish  = 17,
            newText = "'stop'",
        },
    },
    {
        label       = "'restart'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 16,
            finish  = 17,
            newText = "'restart'",
        },
    },
    {
        label       = "'count'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 16,
            finish  = 17,
            newText = "'count'",
        },
    },
    {
        label       = "'step'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 16,
            finish  = 17,
            newText = "'step'",
        },
    },
    {
        label       = "'isrunning'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 16,
            finish  = 17,
            newText = "'isrunning'",
        },
    },
    {
        label       = "'incremental'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 16,
            finish  = 17,
            newText = "'incremental'",
        },
    },
    {
        label       = "'generational'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 16,
            finish  = 17,
            newText = "'generational'",
        },
    },
}

TEST [[
io.read($)
]]
{
    {
        label       = '"n"',
        kind        = define.CompletionItemKind.EnumMember,
    },
    {
        label       = '"a"',
        kind        = define.CompletionItemKind.EnumMember,
    },
    {
        label       = '"l"',
        kind        = define.CompletionItemKind.EnumMember,
    },
    {
        label       = '"L"',
        kind        = define.CompletionItemKind.EnumMember,
    },
}

TEST [[
io.open('', $)
]]
(EXISTS)

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
        label = '#self.results.list+1',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 19,
            finish = 20,
            newText = '#self.results.list+1] = ',
        },
    },
}

TEST [[
self.results.list[#$]
local n = 1
]]
{
    {
        label = '#self.results.list+1',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 19,
            finish = 20,
            newText = '#self.results.list+1] = ',
        },
    },
}

TEST [[
self.results.list[#$] = 1
]]
{
    {
        label = '#self.results.list+1',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 19,
            finish = 20,
            newText = '#self.results.list+1]',
        },
    },
}

TEST [[
self.results.list[#self.re$]
]]
{
    {
        label = '#self.results.list+1',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 19,
            finish = 27,
            newText = '#self.results.list+1] = ',
        },
    },
    {
        label = 'results',
        kind = define.CompletionItemKind.Field,
    },
}

TEST [[
fff[#ff$]
]]
{
    {
        label = '#fff+1',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 5,
            finish = 8,
            newText = '#fff+1] = ',
        },
    },
    {
        label = 'fff',
        kind = define.CompletionItemKind.Text,
    }
}

TEST [[
local _ = fff.kkk[#$]
]]
{
    {
        label = '#fff.kkk',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 19,
            finish = 20,
            newText = '#fff.kkk]',
        },
    },
}

TEST [[
fff.kkk[#$].yy
]]
{
    {
        label = '#fff.kkk',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 9,
            finish = 10,
            newText = '#fff.kkk]',
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
        kind = define.CompletionItemKind.Variable,
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
        kind = define.CompletionItemKind.Variable,
    },
    {
        label = 'XXXX',
        kind = define.CompletionItemKind.Variable,
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
        kind = define.CompletionItemKind.Text,
    },
}

TEST [[
local index
tbl[inde$]
]]
{
    {
        label = 'index',
        kind = define.CompletionItemKind.Variable,
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
        kind = define.CompletionItemKind.Field,
    },
    {
        label = 'b',
        kind = define.CompletionItemKind.Field,
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

function f(ad$)
    local _ = add
end
]]
{
    {
        label = 'add',
        kind = define.CompletionItemKind.Variable,
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

TEST [[
print(io.$)
]]
(EXISTS)

require 'config' .config.runtime.version = 'Lua 5.4'
--TEST [[
--local $
--]]
--{
--    {
--        label = '<toclose>',
--        kind = define.CompletionItemKind.Keyword,
--    },
--    {
--        label = '<const>',
--        kind = define.CompletionItemKind.Keyword,
--    },
--}
--
--TEST [[
--local <toc$
--]]
--{
--    {
--        label = '<toclose>',
--        kind = define.CompletionItemKind.Keyword,
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
        kind = define.CompletionItemKind.Field,
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
        label = 'else',
        kind = define.CompletionItemKind.Keyword,
    },
    {
        label = 'elseif',
        kind = define.CompletionItemKind.Keyword,
    },
    {
        label = 'elseif .. then',
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'elseaaa',
        kind = define.CompletionItemKind.Variable,
    },
    {
        label = 'ELSE',
        kind = define.CompletionItemKind.Enum,
    },
    {
        label = 'select',
        kind = define.CompletionItemKind.Function,
    },
    {
        label = 'select()',
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'setmetatable',
        kind = define.CompletionItemKind.Function,
    },
    {
        label = 'setmetatable()',
        kind = define.CompletionItemKind.Snippet,
    },
}

Cared['insertText'] = true
TEST [[
local xpcal
xpcal$
]]
{
    {
        label = 'xpcal',
        kind = define.CompletionItemKind.Variable,
    },
    {
        label = 'xpcall',
        kind = define.CompletionItemKind.Function,
    },
    {
        label = 'xpcall()',
        kind = define.CompletionItemKind.Snippet,
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
        kind = define.CompletionItemKind.Method,
    },
    {
        label = 'f()',
        kind = define.CompletionItemKind.Snippet,
        insertText = 'f(${1:a: any}, ${2:b: any}, ${3:c: any})',
    },
}

TEST [[
function$
]]
{
    {
        label = 'function',
        kind  = define.CompletionItemKind.Keyword,
    },
    {
        label = 'function ()',
        kind  = define.CompletionItemKind.Snippet,
        insertText = "\z
function $1($2)\
\t$0\
end",
    },
}

TEST [[
local t = function$
]]
{
    {
        label = 'function',
        kind  = define.CompletionItemKind.Keyword,
    },
    {
        label = 'function ()',
        kind  = define.CompletionItemKind.Snippet,
        insertText = "\z
function ($1)\
\t$0\
end",
    },
}
Cared['insertText'] = false

TEST [[
local function f()
    if a then
    else$
end
]]
{
    {
        label = 'else',
        kind = define.CompletionItemKind.Keyword,
    },
    {
        label = 'elseif',
        kind = define.CompletionItemKind.Keyword,
    },
    {
        label = 'elseif .. then',
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'select',
        kind = define.CompletionItemKind.Function,
    },
    {
        label = 'select()',
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'setmetatable',
        kind = define.CompletionItemKind.Function,
    },
    {
        label = 'setmetatable()',
        kind = define.CompletionItemKind.Snippet,
    },
}

TEST [[
local t = {
    ['a.b.c'] = {}
}

t.$
]]
{
    {
        label = 'a.b.c',
        kind = define.CompletionItemKind.Field,
        textEdit = {
            start = 37,
            finish = 36,
            newText = '["a.b.c"]',
        },
        additionalTextEdits = {
            {
                start   = 36,
                finish  = 36,
                newText = '',
            },
        },
    }
}

TEST [[
local t = {
    ['a.b.c'] = {}
}

t.   $
]]
{
    {
        label = 'a.b.c',
        kind = define.CompletionItemKind.Field,
        textEdit = {
            start = 40,
            finish = 39,
            newText = '["a.b.c"]',
        },
        additionalTextEdits = {
            {
                start   = 36,
                finish  = 36,
                newText = '',
            },
        },
    }
}

TEST [[
local t = {
    ['a.b.c'] = {}
}

t['$']
]]
{
    {
        label = 'a.b.c',
        kind = define.CompletionItemKind.Field,
        textEdit = {
            start = 38,
            finish = 37,
            newText = 'a.b.c',
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
        kind = define.CompletionItemKind.Field,
        textEdit = {
            start = 21,
            finish = 21,
            newText = '_ENV["z.b.c"]',
        },
    },
    {
        label = 'z',
        kind = define.CompletionItemKind.Text,
    }
}

TEST [[
io.close(1, $)
]]
(nil)

TEST [[
io$
]]
(EXISTS)

TEST [[
loadstring$
]]
{
    {
        label = 'loadstring',
        kind  = define.CompletionItemKind.Function,
        deprecated = true,
    },
    {
        label = 'loadstring()',
        kind  = define.CompletionItemKind.Snippet,
        deprecated = true,
    },
}

TEST [[
bit32$
]]
{
    {
        label = 'bit32',
        kind  = define.CompletionItemKind.Field,
        deprecated = true,
    },
}

TEST [[
function loadstring()
end
loadstring$
]]
{
    {
        label = 'loadstring',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'loadstring()',
        kind  = define.CompletionItemKind.Snippet,
    },
}

TEST [[
debug.setcsta$
]]
{
    {
        label = 'setcstacklimit',
        kind = define.CompletionItemKind.Function,
        deprecated = true,
    },
    {
        label = 'setcstacklimit()',
        kind = define.CompletionItemKind.Snippet,
        deprecated = true,
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
        kind = define.CompletionItemKind.Event
    }
}

TEST [[
---@class ZABC
---@class ZBBC : Z$
]]
{
    {
        label = 'ZABC',
        kind = define.CompletionItemKind.Class,
    },
}

TEST [[
---@class ZABC
---@class ZBBC : $
]]
(EXISTS)

TEST [[
---@class zabc
local abcd
---@type za$
]]
{
    {
        label = 'zabc',
        kind = define.CompletionItemKind.Class,
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
        kind = define.CompletionItemKind.Class,
    }
}

TEST [[
---@alias zabc zabb
---@type za$
]]
{
    {
        label = 'zabc',
        kind = define.CompletionItemKind.Class,
    },
}

TEST [[
---@class ZClass
---@param x ZC$
]]
{
    {
        label = 'ZClass',
        kind = define.CompletionItemKind.Class,
    },
}

Cared['insertText'] = true
TEST [[
---@param $
function f(a, b, c)
end
]]
{
    {
        label = 'a, b, c',
        kind = define.CompletionItemKind.Snippet,
        insertText = [[
a ${1:any}
---@param b ${2:any}
---@param c ${3:any}]]
    },
    {
        label = 'a',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'b',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'c',
        kind = define.CompletionItemKind.Interface,
    },
}

TEST [[
---@param $
function f(a, b, c) end

function f2(a) end
]]
{
    {
        label = 'a, b, c',
        kind = define.CompletionItemKind.Snippet,
        insertText = [[
a ${1:any}
---@param b ${2:any}
---@param c ${3:any}]]
    },
    {
        label = 'a',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'b',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'c',
        kind = define.CompletionItemKind.Interface,
    },
}

TEST [[
---@param aa$
function f(aaa, bbb, ccc)
end
]]
{
    {
        label = 'aaa',
        kind = define.CompletionItemKind.Interface,
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
        kind = define.CompletionItemKind.Snippet,
        insertText = [[
a ${1:any}
---@param b ${2:any}
---@param c ${3:any}]]
    },
    {
        label = 'a',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'b',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'c',
        kind = define.CompletionItemKind.Interface,
    },
}

TEST [[
---@param $
function mt:f(a, b, c, ...)
end
]]
{
    {
        label = 'a, b, c',
        kind = define.CompletionItemKind.Snippet,
        insertText = [[
a ${1:any}
---@param b ${2:any}
---@param c ${3:any}]]
    },
    {
        label = 'a',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'b',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'c',
        kind = define.CompletionItemKind.Interface,
    },
}

TEST [[
---@param aaa $
function f(aaa, bbb, ccc)
end
]]
(EXISTS)

TEST [[
---@param xyz Class
---@param xxx Class
function f(x$)
]]
{
    {
        label = 'xyz, xxx',
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'xyz',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'xxx',
        kind = define.CompletionItemKind.Interface,
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
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'xyz',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'xxx',
        kind = define.CompletionItemKind.Interface,
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
        kind = define.CompletionItemKind.Snippet,
    },
    {
        label = 'xyz',
        kind = define.CompletionItemKind.Interface,
    },
    {
        label = 'xxx',
        kind = define.CompletionItemKind.Interface,
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
        kind = define.CompletionItemKind.Event,
    },
    {
        label = 'return',
        kind = define.CompletionItemKind.Event,
    },
    {
        label = 'deprecated',
        kind = define.CompletionItemKind.Event,
    },
    {
        label = 'meta',
        kind = define.CompletionItemKind.Event,
    },
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
        kind = define.CompletionItemKind.Field,
    },
    {
        label = 'name',
        kind = define.CompletionItemKind.Field,
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
        kind = define.CompletionItemKind.EnumMember,
    },
    {
        label = "'BBB'",
        kind = define.CompletionItemKind.EnumMember,
    },
    {
        label = "'CCC'",
        kind = define.CompletionItemKind.EnumMember,
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
        kind = define.CompletionItemKind.EnumMember,
    },
    {
        label = "'BBB'",
        kind = define.CompletionItemKind.EnumMember,
    },
    {
        label = "'CCC'",
        kind = define.CompletionItemKind.EnumMember,
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
        kind = define.CompletionItemKind.EnumMember,
    },
    {
        label = "'BBB'",
        kind = define.CompletionItemKind.EnumMember,
    },
    {
        label = "'CCC'",
        kind = define.CompletionItemKind.EnumMember,
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
        kind = define.CompletionItemKind.EnumMember,
    },
    {
        label = "'BBB'",
        kind = define.CompletionItemKind.EnumMember,
    },
    {
        label = "'CCC'",
        kind = define.CompletionItemKind.EnumMember,
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
        label = "'AAA'",
        kind = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
    },
    {
        label = "'BBB'",
        kind = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
    },
    {
        label = "'CCC'",
        kind = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
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
        kind = define.CompletionItemKind.Function,
    },
    {
        label = 'zzzzz()',
        kind = define.CompletionItemKind.Snippet,
        insertText = EXISTS,
    }
}

Cared['detail'] = true
Cared['description'] = true
TEST [[
--- abc
zzz = 1
zz$
]]
{
    {
        label = 'zzz',
        kind = define.CompletionItemKind.Enum,
        detail = 'integer = 1',
        description = [[
```lua
global zzz: integer = 1
```
---

 abc]],
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
        kind = define.CompletionItemKind.EnumMember,
        description = '注释1',
    },
    {
        label = "'选项2'",
        kind = define.CompletionItemKind.EnumMember,
        description = '注释2',
    },
}

TEST [[
utf8.charpatter$
]]
{
    {
        label       = 'charpattern',
        detail      = 'string',
        kind        = define.CompletionItemKind.Field,
        description = EXISTS,
    }
}

TEST [[
---@type "'a'"|"'b'"|"'c'"
local x

print(x == $)
]]
{
    {
        label  = "'a'",
        kind   = define.CompletionItemKind.EnumMember,
    },
    {
        label  = "'b'",
        kind   = define.CompletionItemKind.EnumMember,
    },
    {
        label  = "'c'",
        kind   = define.CompletionItemKind.EnumMember,
    },
}

TEST [[
---@type "'a'"|"'b'"|"'c'"
local x

x = $
]]
{
    {
        label  = "'a'",
        kind   = define.CompletionItemKind.EnumMember,
    },
    {
        label  = "'b'",
        kind   = define.CompletionItemKind.EnumMember,
    },
    {
        label  = "'c'",
        kind   = define.CompletionItemKind.EnumMember,
    },
}

TEST [[
---@type "'a'"|"'b'"|"'c'"
local x

print(x == '$')
]]
{
    {
        label  = "'a'",
        kind   = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
    },
    {
        label  = "'b'",
        kind   = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
    },
    {
        label  = "'c'",
        kind   = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
    },
}

TEST [[
---@type "'a'"|"'b'"|"'c'"
local x

x = '$'
]]
{
    {
        label  = "'a'",
        kind   = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
    },
    {
        label  = "'b'",
        kind   = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
    },
    {
        label  = "'c'",
        kind   = define.CompletionItemKind.EnumMember,
        textEdit = EXISTS,
    },
}

TEST [[
local t = type()

print(t == $)
]]
(EXISTS)

TEST [[
if type(arg) == '$'
]]
(EXISTS)

TEST [[
if type(arg) == $
]]
(EXISTS)

TEST [[
---@type string
local s
s.$
]]
(EXISTS)

TEST [[
---@class C
local t

local vvv = assert(t)
vvv$
]]
{
    {
        label  = 'vvv',
        detail = 'C',
        kind   = define.CompletionItemKind.Variable,
        description = EXISTS,
    },
}

Cared['insertText'] = true
TEST [[
---@param callback fun(x: number, y: number):string
local function f(callback) end

f($)
]]
{
    {
        label  = 'fun(x: number, y: number):string',
        kind   = define.CompletionItemKind.Function,
        insertText = "\z
function (${1:x}, ${2:y})\
\t$0\
end",
    },
}
Cared['insertText'] = nil
