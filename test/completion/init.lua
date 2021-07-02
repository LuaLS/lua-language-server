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

local function include(a, b)
    if a == EXISTS and b ~= nil then
        return true
    end
    local tp1, tp2 = type(a), type(b)
    if tp1 ~= tp2 then
        return false
    end
    if tp1 == 'table' then
        for k in pairs(a) do
            if not eq(a[k], b[k]) then
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

local IgnoreFunction = false

function TEST(script)
    return function (expect)
        files.removeAll()
        local pos = script:find('$', 1, true) - 1
        local new_script = script:gsub('%$', '')

        files.setText('', new_script)
        core.clearCache()
        local triggerCharacter = script:sub(pos - 1, pos - 1)
        local result = core.completion('', pos, triggerCharacter)
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
        end
        if IgnoreFunction then
            for i = #result, 1, -1 do
                local item = result[i]
                if item.label:find '%('
                and not item.label:find 'function' then
                    result[i] = result[#result]
                    result[#result] = nil
                end
            end
        end
        assert(result)
        if expect.include then
            expect.include = nil
            assert(include(expect, result))
        else
            assert(eq(expect, result))
        end
    end
end

config.set('Lua.completion.callSnippet',    'Both')
config.set('Lua.completion.keywordSnippet', 'Both')
config.set('Lua.completion.workspaceWord',  false)

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
        label = 'assert(v, message)',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'assert(v, message)',
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
        label = 'assert(v, message)',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'assert(v, message)',
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
        label = 'ffff(a, b)',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'ffff(a, b)',
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
        label = 'get(a, b)',
        kind = define.CompletionItemKind.Method,
    },
    {
        label = 'get(a, b)',
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
        label = 'collectgarbage(opt, ...)',
        kind = define.CompletionItemKind.Function,
    },
    {
        label = 'collectgarbage(opt, ...)',
        kind = define.CompletionItemKind.Snippet,
    },
}

IgnoreFunction = true
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
result$
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

IgnoreFunction = false
TEST [[
t.a = {}
function t:b()
end
t:$
]]
{
    {
        label = 'b()',
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

IgnoreFunction = true
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
(EXISTS)

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

require 'config'.set('Lua.runtime.version', 'Lua 5.4')
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
}

Cared['insertText'] = true
IgnoreFunction = false
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
        label = 'xpcall(f, msgh, arg1, ...)',
        kind = define.CompletionItemKind.Function,
        insertText = EXISTS,
    },
    {
        label = 'xpcall(f, msgh, arg1, ...)',
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
        label = 'f(a, b, c)',
        kind = define.CompletionItemKind.Method,
        insertText = EXISTS,
    },
    {
        label = 'f(a, b, c)',
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
IgnoreFunction = true

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
}

TEST [[
io.close(1, $)
]]
(nil)

TEST [[
io$
]]
(EXISTS)

IgnoreFunction = false
TEST [[
loadstring$
]]
{
    {
        label = 'loadstring(text, chunkname)',
        kind  = define.CompletionItemKind.Function,
        deprecated = true,
    },
    {
        label = 'loadstring(text, chunkname)',
        kind  = define.CompletionItemKind.Snippet,
        deprecated = true,
    },
}

--TEST [[
--bit32$
--]]
--{
--    {
--        label = 'bit32',
--        kind  = define.CompletionItemKind.Field,
--        deprecated = true,
--    },
--}

TEST [[
function loadstring()
end
loadstring$
]]
{
    {
        label = 'loadstring()',
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'loadstring()',
        kind  = define.CompletionItemKind.Snippet,
    },
    {
        label = 'loadstring(text, chunkname)',
        deprecated = true,
        kind  = define.CompletionItemKind.Function,
    },
    {
        label = 'loadstring(text, chunkname)',
        deprecated = true,
        kind  = define.CompletionItemKind.Snippet,
    },
}

TEST [[
debug.setcsta$
]]
{
    {
        label = 'setcstacklimit(limit)',
        kind = define.CompletionItemKind.Function,
        deprecated = true,
    },
    {
        label = 'setcstacklimit(limit)',
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
---@param c ${3:any}]],
    },
    {
        label = 'self',
        kind = define.CompletionItemKind.Interface,
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
    {
        label = 'diagnostic',
        kind = define.CompletionItemKind.Event,
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
---this is
---a multi line
---comment
---@alias XXXX
---comment 1
---comment 1
---| '1'
---comment 2
---comment 2
---| '2'

---@param x XXXX
local function f(x)
end

f($)
]]
{
    {
        label = '1',
        kind  = define.CompletionItemKind.EnumMember,
    },
    {
        label = '2',
        kind  = define.CompletionItemKind.EnumMember,
    },
}

TEST [[
---this is
---a multi line
---comment
---@alias XXXX
---comment 1
---comment 1
---| '1'
---comment 2
---comment 2
---| '2'
---@param x XXXX
local function f(x)
end


---comment 3
---comment 3
---| '3'

f($)
]]
{
    {
        label = '1',
        kind  = define.CompletionItemKind.EnumMember,
    },
    {
        label = '2',
        kind  = define.CompletionItemKind.EnumMember,
    },
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
        label = 'zzzzz(list, sep, i, j)',
        kind = define.CompletionItemKind.Function,
        insertText = EXISTS,
    },
    {
        label = 'zzzzz(list, sep, i, j)',
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

TEST [[
---$
local function f(a, b, c)
    return a + 1, b .. '', c[1]
end
]]
{
    {
        label  = '@param;@return',
        kind   = define.CompletionItemKind.Snippet,
        insertText = "\z
${1:comment}\
---@param a ${2:number}\
---@param b ${3:string}\
---@param c ${4:table}\
---@return ${5:number}\
---@return ${6:string}\
---@return ${7:any}",
    },
}

Cared['insertText'] = nil

TEST [[
--$
]]
{
    {
        label = '#region',
        kind  = define.CompletionItemKind.Snippet,
    },
    {
        label = '#endregion',
        kind  = define.CompletionItemKind.Snippet,
    }
}

Cared['description'] = nil
Cared['detail'] = nil
TEST [[
---@class cc
---@field aaa number # a1
---@field bbb number # a2

---@param x cc
local function f(x) end

f({
    $
})
]]
{
    {
        label = 'aaa',
        kind  = define.CompletionItemKind.Property,
    },
    {
        label = 'bbb',
        kind  = define.CompletionItemKind.Property,
    },
}

TEST [[
---@class cc
---@field aaa number # a1
---@field bbb number # a2

---@param x cc
local function f(x) end

f({
    aaa = 1,
    $
})
]]
{
    {
        label = 'bbb',
        kind  = define.CompletionItemKind.Property,
    },
}

TEST [[
---@class cc
---@field aaa number # a1
---@field bbb number # a2

---@param x cc
local function f(x) end

f({aaa = 1,$})
]]
{
    {
        label = 'bbb',
        kind  = define.CompletionItemKind.Property,
    },
}

TEST [[
---@class cc
---@field aaa number # a1
---@field bbb number # a2

---@param x cc
local function f(x) end

f({aaa $})
]]
(nil)

TEST [[
---@class cc
---@field iffff number # a1

---@param x cc
local function f(x) end

f({if$})
]]
{
    include = true,
    {
        label = 'iffff',
        kind  = define.CompletionItemKind.Property,
    },
}

TEST [[
---@class cc
---@field aaa number # a1
---@field bbb number # a2

---@param x cc
local function f(x) end

f({
    {
        $
    }
})
]]
(nil)

TEST [[
---@return string
local function f() end

local s = f()

s.$
]]
(EXISTS)

Cared['description'] = true
TEST [[
---@class cc
---@field aaa number
---@field bbb number

---@type cc
local t
print(t.aa$)
]]
{
    {
        label = 'aaa',
        kind  = define.CompletionItemKind.Field,
        description = [[
```lua
field cc.aaa: number
```]]
    },
}
Cared['description'] = nil

TEST [[
---@type table<string, "'a'"|"'b'"|"'c'">
local x

x.a = $
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
---@type table<string, "'a'"|"'b'"|"'c'">
local x

x['a'] = $
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
---@type table<string, "'a'"|"'b'"|"'c'">
local x = {
    a = $
}
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
---@type table<string, "'a'"|"'b'"|"'c'">
local x = {
    ['a'] = $
}
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

Cared['insertText'] = true
TEST [[
---@class A.B.C
local m

function m.f()
end

m.f$
]]{
    {
        label  = "f()",
        kind   = define.CompletionItemKind.Function,
        insertText = EXISTS,
    },
    {
        label  = "f()",
        kind   = define.CompletionItemKind.Snippet,
        insertText = 'f()',
    },
}
Cared['insertText'] = nil

TEST [[
if true then$
]]
{
    {
        label = 'then',
        kind  = define.CompletionItemKind.Keyword,
    },
    {
        label = 'then .. end',
        kind  = define.CompletionItemKind.Snippet,
    }
}

TEST [[
if true then$
end
]]
{
    {
        label = 'then',
        kind  = define.CompletionItemKind.Keyword,
    },
}

TEST [[
if true then$
else
]]
{
    {
        label = 'then',
        kind  = define.CompletionItemKind.Keyword,
    },
}

TEST [[
if true then$
elseif
]]
{
    {
        label = 'then',
        kind  = define.CompletionItemKind.Keyword,
    },
}

TEST [[
do
    if true then$
end
]]
{
    {
        label = 'then',
        kind  = define.CompletionItemKind.Keyword,
    },
    {
        label = 'then .. end',
        kind  = define.CompletionItemKind.Snippet,
    }
}

TEST [[
---@class C
---@field x number
---@field y number

---@vararg C
local function f(x, ...)
end

f(1, {
    $
})
]]
{
    {
        label = 'x',
        kind  = define.CompletionItemKind.Property,
    },
    {
        label = 'y',
        kind  = define.CompletionItemKind.Property,
    }
}

TEST [[
---@class C
---@field x number
---@field y number

---@vararg C
local function f(x, ...)
end

f(1, {}, {}, {
    $
})
]]
{
    {
        label = 'x',
        kind  = define.CompletionItemKind.Property,
    },
    {
        label = 'y',
        kind  = define.CompletionItemKind.Property,
    }
}

TEST [[
---@class C
---@field x number
---@field y number

---@type C
local t = {
    $
}

]]
{
    {
        label = 'x',
        kind  = define.CompletionItemKind.Property,
    },
    {
        label = 'y',
        kind  = define.CompletionItemKind.Property,
    }
}

TEST [[
---@class C
---@field x number
---@field y number

---@type C
local t = {
    x$
}

]]
{
    include = true,
    {
        label = 'x',
        kind  = define.CompletionItemKind.Property,
    },
}

TEST [[
if $ then
]]
(nil)

TEST [[
elseif $ then
]]
(nil)

TEST [[
---@type iolib
local t = {
    $
]]
(EXISTS)

TEST [[
---@class A
---@field a '"hello"'|'"world"'

---@param t A
function api(t) end

api({$})
]]
(EXISTS)

TEST [[
---@class A
---@field a '"hello"'|'"world"'

---@param t A
function m:api(t) end

m:api({$})
]]
(EXISTS)

TEST [[
---@class AAA.BBB

---@type AAA.$
]]
{
    {
        label = 'AAA.BBB',
        kind  = define.CompletionItemKind.Class,
        textEdit    = {
            start   = 29,
            finish  = 32,
            newText = 'AAA.BBB',
        },
    }
}

Cared['insertText'] = true
TEST [[
---@overload fun(a: any, b: any)
local function zzzz(a) end
zzzz$
]]
{
    {
        label = 'zzzz(a)',
        kind  = define.CompletionItemKind.Function,
        insertText = 'zzzz',
    },
    {
        label = 'zzzz(a)',
        kind  = define.CompletionItemKind.Snippet,
        insertText = 'zzzz(${1:a: any})',
    },
    {
        label = 'zzzz(a, b)',
        kind  = define.CompletionItemKind.Function,
        insertText = 'zzzz',
    },
    {
        label = 'zzzz(a, b)',
        kind  = define.CompletionItemKind.Snippet,
        insertText = 'zzzz(${1:a: any}, ${2:b: any})',
    },
}
Cared['insertText'] = false

TEST [[
--- @diagnostic disable: unused-local
--- @class Test2
--- @field world integer
local Test2 = {}

--- @type Test2
local tdirect
--- @type Test2[]
local tarray

-- Direct inference
local b = tdirect    -- type . here, shows "world"

-- Inferred by index
local c = tarray[1].$  -- type . here, no auto completion
]]
(EXISTS)

TEST [[
local function f()
    if type() == '$' then
    end
end
]]
(EXISTS)

config.set('Lua.completion.callSnippet',    'Disable')

TEST [[
GGG = 1
GGG = function ()
end

GGG$
]]
{
    {
        label = 'GGG',
        kind  = define.CompletionItemKind.Enum,
    },
    {
        label = 'GGG()',
        kind  = define.CompletionItemKind.Function,
    },
}

TEST [[
---@class C
---@field GGG number
local t = {}

t.GGG = function ()
end

t.GGG$
]]
{
    {
        label = 'GGG',
        kind  = define.CompletionItemKind.Field,
    },
    {
        label = 'GGG()',
        kind  = define.CompletionItemKind.Function,
    },
}
