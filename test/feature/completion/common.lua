---@diagnostic disable: undefined-global

local define = require 'proto.define'
local config = require 'config'

config.set(nil, 'Lua.completion.callSnippet',    'Both')
config.set(nil, 'Lua.completion.keywordSnippet', 'Both')
config.set(nil, 'Lua.completion.workspaceWord',  false)
config.set(nil, 'Lua.completion.showWord',       'Enable')

-- [已迁移至 test/feature/completion/word.lua]
-- [已迁移至 test/feature/completion/field.lua]
-- [已迁移至 test/feature/completion/special.lua]

IgnoreFunction = true
TEST [[
local xxxx = {
    xxyy = 1,
    xxzz = 2,
}

local t = {
    x<??>
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
local f<??>
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

-- [已迁移至 test/feature/completion/word.lua] local function f(ff<??>)

TEST [[
collectgarbage(<??>)
]]
(EXISTS)

TEST [[
collectgarbage('<??>')
]]
{
    {
        label       = "'collect'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 15,
            finish  = 17,
            newText = "'collect'",
        },
    },
    {
        label       = "'stop'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 15,
            finish  = 17,
            newText = "'stop'",
        },
    },
    {
        label       = "'restart'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 15,
            finish  = 17,
            newText = "'restart'",
        },
    },
    {
        label       = "'count'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 15,
            finish  = 17,
            newText = "'count'",
        },
    },
    {
        label       = "'step'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 15,
            finish  = 17,
            newText = "'step'",
        },
    },
    {
        label       = "'isrunning'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 15,
            finish  = 17,
            newText = "'isrunning'",
        },
    },
    {
        label       = "'incremental'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 15,
            finish  = 17,
            newText = "'incremental'",
        },
    },
    {
        label       = "'generational'",
        kind        = define.CompletionItemKind.EnumMember,
        textEdit    = {
            start   = 15,
            finish  = 17,
            newText = "'generational'",
        },
    },
}

TEST [[
io.read(<??>)
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
io.open('', <??>)
]]
(EXISTS)

TEST [[
local function f(a, <??>)
end
]]
(nil)

TEST [[
self.results.list[#<??>]
]]
{
    {
        label = '#self.results.list+1',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 18,
            finish = 20,
            newText = '#self.results.list+1] = ',
        },
    },
}

TEST [[
self.results.list[#<??>]
local n = 1
]]
{
    {
        label = '#self.results.list+1',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 18,
            finish = 20,
            newText = '#self.results.list+1] = ',
        },
    },
}

TEST [[
self.results.list[#<??>] = 1
]]
{
    {
        label = '#self.results.list+1',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 18,
            finish = 20,
            newText = '#self.results.list+1]',
        },
    },
}

TEST [[
self.results.list[#self.re<??>]
]]
{
    {
        label = '#self.results.list+1',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 18,
            finish = 27,
            newText = '#self.results.list+1] = ',
        },
    },
    {
        label = 'results',
        kind = define.CompletionItemKind.Text,
    },
}

TEST [[
fff[#ff<??>]
]]
{
    {
        label = '#fff+1',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 4,
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
local _ = fff.kkk[#<??>]
]]
{
    {
        label = '#fff.kkk',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 18,
            finish = 20,
            newText = '#fff.kkk]',
        },
    },
}

TEST [[
fff.kkk[#<??>].yy
]]
{
    {
        label = '#fff.kkk',
        kind = define.CompletionItemKind.Snippet,
        textEdit = {
            start = 8,
            finish = 10,
            newText = '#fff.kkk]',
        },
    },
}

-- [已迁移至 test/feature/completion/field.lua]
-- [已迁移至 test/feature/completion/word.lua] xxxx<??>, xxxx+XXXX, index
-- TODO: xxxxx text（workspaceWord）
-- TODO: 字符串内补全 local ast = 'as<??>'
-- TODO: 函数参数内 word 补全 function f(ad<??>)
-- TODO: 全局函数定义补全 function table.i<??>
-- TODO: 全局表字段补全 print(io.<??>)

require 'config'.set(nil, 'Lua.runtime.version', 'Lua 5.4')
--TEST [[
--local <??>
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
--local <toc<??>
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

t.<??>
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
else<??>
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
xpcal<??>
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

mt:f<??>
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
        insertText = 'f(${1:a}, ${2:b}, ${3:c})',
    },
}

TEST [[
function<??>
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
local t = function<??>
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

-- [已迁移至 test/feature/completion/keyword.lua] else<??>

TEST [[
local t = {
    ['a.b.c'] = {}
}

t.<??>
]]
{
    {
        label = "'a.b.c'",
        kind = define.CompletionItemKind.Field,
        textEdit = {
            start = 40002,
            finish = 40002,
            newText = "['a.b.c']",
        },
        additionalTextEdits = {
            {
                start   = 40001,
                finish  = 40002,
                newText = '',
            },
        },
    }
}

TEST [[
local t = {
    ['a.b.c'] = {}
}

t.   <??>
]]
{
    {
        label = "'a.b.c'",
        kind = define.CompletionItemKind.Field,
        textEdit = {
            start = 40005,
            finish = 40005,
            newText = "['a.b.c']",
        },
        additionalTextEdits = {
            {
                start   = 40001,
                finish  = 40002,
                newText = '',
            },
        },
    }
}

TEST [[
local t = {
    ['a.b.c'] = {}
}

t['<??>']
]]
{
    {
        label = "'a.b.c'",
        kind = define.CompletionItemKind.Field,
        textEdit = {
            start = 40003,
            finish = 40003,
            newText = 'a.b.c',
        }
    }
}

TEST [[
_G['z.b.c'] = {}

z<??>
]]
{
    {
        label = "'z.b.c'",
        kind = define.CompletionItemKind.Field,
        textEdit = {
            start = 20000,
            finish = 20001,
            newText = "_ENV['z.b.c']",
        },
    },
}

config.set(nil, 'Lua.runtime.version', 'Lua 5.1')

TEST [[
_G['z.b.c'] = {}

z<??>
]]
{
    {
        label = "'z.b.c'",
        kind = define.CompletionItemKind.Field,
        textEdit = {
            start = 20000,
            finish = 20001,
            newText = "_G['z.b.c']",
        },
    },
}

config.set(nil, 'Lua.runtime.version', 'Lua 5.4')

TEST [[
中文字段 = 1

中文<??>
]]
{
    {
        label = '中文字段',
        kind = define.CompletionItemKind.Enum,
        textEdit = {
            start = 20000,
            finish = 20006,
            newText = '_ENV["中文字段"]',
        },
    },
}

config.set(nil, 'Lua.runtime.unicodeName', true)
TEST [[
中文字段 = 1

中文<??>
]]
{
    {
        label = '中文字段',
        kind = define.CompletionItemKind.Enum,
    },
}
config.set(nil, 'Lua.runtime.unicodeName', false)

TEST [[
io.close(1, <??>)
]]
(nil)

TEST [[
io<??>
]]
(EXISTS)

IgnoreFunction = false
-- [已迁移至 test/feature/completion/special.lua]

-- [已迁移至 test/feature/completion/luadoc.lua] ---@cl<??>
-- [已迁移至 test/feature/completion/luadoc.lua] ---@class ZBBC : Z<??> (include nil case)

-- [已迁移至 test/feature/completion/luadoc.lua] class/type/param/field 其余 LuaDoc 测试块

-- [已迁移至 test/feature/completion/string.lua] 字符串枚举补全测试块（param/alias/array/string-literal）

-- [已迁移至 test/feature/completion/luadoc.lua] OptionObj 嵌套数组对象补全（type/param 与 nil 场景）
-- [已迁移至 test/feature/completion/luadoc.lua] 多行注释 alias 枚举补全（XXXX）

-- [已迁移至 test/feature/completion/luadoc.lua] function 类型参数内联函数体补全为空

TEST [[
--- JustTest
---@param list table
---@param sep string
---@param i number
---@param j number
---@return string
local function zzzzz(list, sep, i, j) end

zzz<??>
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
zz<??>
]]
{
    {
        label = 'zzz',
        kind = define.CompletionItemKind.Enum,
        detail = 'integer = 1',
        description = [[
```lua
(global) zzz: integer = 1
```

---

 abc]],
    }
}

-- [已迁移至 test/feature/completion/luadoc.lua] 字符串字面量参数注解补全（含注释 description）

TEST [[
utf8.charpatter<??>
]]
{
    {
        label       = 'charpattern',
        detail      = 'string',
        kind        = define.CompletionItemKind.Field,
        description = EXISTS,
    }
}

-- [已迁移至 test/feature/completion/string.lua] 基础字面量联合类型补全（"a"|"b"|"c"）

TEST [[
local t = type()

print(t == <??>)
]]
(EXISTS)

TEST [[
if type(arg) == '<??>'
]]
(EXISTS)

TEST [[
if type(arg) == <??>
]]
(EXISTS)

-- [已迁移至 test/feature/completion/luadoc.lua] 基础字符串类型字段补全（---@type string）

-- [已迁移至 test/feature/completion/luadoc.lua] assert 后变量类型保持补全（C -> vvv）

-- [已迁移至 test/feature/completion/luadoc.lua] 回调函数类型参数补全（insertText 模板）

TEST [[
--<??>
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
-- [已迁移至 test/feature/completion/luadoc.lua] 注解驱动对象属性补全（cc/C 类场景）

-- [已迁移至 test/feature/completion/string.lua] table<string, union-literal> 赋值补全

-- [已迁移至 test/feature/completion/luadoc.lua] A.B.C 成员函数补全（function/snippet）

TEST [[
if true then<??>
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
if true then<??>
end
]]
{
    {
        label = 'then',
        kind  = define.CompletionItemKind.Keyword,
    },
}

TEST [[
if true then<??>
else
]]
{
    {
        label = 'then',
        kind  = define.CompletionItemKind.Keyword,
    },
}

TEST [[
if true then<??>
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
    if true then<??>
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

-- [已迁移至 test/feature/completion/luadoc.lua] C 类型 vararg/type 表构造字段补全（4 场景）

TEST [[
if <??> then
]]
(nil)

TEST [[
elseif <??> then
]]
(nil)

-- [已迁移至 test/feature/completion/luadoc.lua] iolib 表构造补全

-- [已迁移至 test/feature/completion/string.lua] 类字段字面量字符串补全（表构造参数）

-- [已迁移至 test/feature/completion/luadoc.lua] AAA.BBB 类型命名空间补全

Cared['insertText'] = true
-- [已迁移至 test/feature/completion/luadoc.lua] overload/param/vararg 函数签名补全
Cared['insertText'] = false

-- [已迁移至 test/feature/completion/luadoc.lua] class Test2 index 推断补全

TEST [[
local function f()
    if type() == '<??>' then
    end
end
]]
(EXISTS)

config.set(nil, 'Lua.completion.callSnippet',    'Disable')

TEST [[
GGG = 1
GGG = function ()
end

GGG<??>
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

-- [已迁移至 test/feature/completion/luadoc.lua] 类字段函数值与 fun(...) 参数补全

-- [已迁移至 test/feature/completion/luadoc.lua] 单元素索引表字段补全（{[1]: number}）

-- [已迁移至 test/feature/completion/string.lua] alias enum 与 fun 参数字面量字符串补全

-- [已迁移至 test/feature/completion/luadoc.lua] fun 字段在冒号调用位置补全

-- [已迁移至 test/feature/completion/string.lua] fun 参数字面量字符串补全（self 与 dot 调用）

TEST [[
local m = {}

function m.f()
end

m.f()
m.<??>
]]
{
    [1] = EXISTS,
}

-- [已迁移至 test/feature/completion/luadoc.lua] class 继承方法补全（class2 : class1）

-- [已迁移至 test/feature/completion/luadoc.lua] Emit overload 回调推断补全（string / literal event）

TEST [[
local function f()
    local inferCache
    in<??>
end
]]
{
    [1] = {
        label = 'in',
        kind  = define.CompletionItemKind.Keyword,
    },
    [2] = {
        label = 'in ..',
        kind  = define.CompletionItemKind.Snippet,
    },
    [3] = {
        label = 'inferCache',
        kind  = define.CompletionItemKind.Variable,
    }
}

TEST [[
utf<??>'xxx'
]]
{
    [1] = {
        label = 'utf8',
        kind  = define.CompletionItemKind.Field,
    }
}

-- [已迁移至 test/feature/completion/luadoc.lua] AAA/BBB 类型与 A.zzzz 属性补全

-- [已迁移至 test/feature/completion/special.lua] postfix snippet 语法（pcall/xpcall/function/method/insert/++）

-- [已迁移至 test/feature/completion/luadoc.lua] TestClass/testAlias 注解驱动参数补全

TEST [[
require '<??>'
]]
(function (results)
    assert(#results == 9, require 'utility'.dump(results))
end)

TEST [[
AAA = 1

<??>
]]
(EXISTS)

TEST [[
if<??>
]]
(EXISTS)

TEST [[
local t = x[<??>]
]]
(function (results)
    for _, res in ipairs(results) do
        assert(res.label ~= 'do')
    end
end)

-- [已迁移至 test/feature/completion/luadoc.lua] 重复 class 去重补全

TEST [[
local x
x.y.z = xxx

x.y.<??>
]]
{
    {
        label = 'z',
        kind  = define.CompletionItemKind.Field,
    }
}

-- [已迁移至 test/feature/completion/luadoc.lua] ---@cast 变量补全

-- [已迁移至 test/feature/completion/string.lua] CONST 字面量联合补全

TEST [[
return function ()
    local function fff(xxx)
        for f in xx<??>
    end
end
]]
{
    {
        label = 'xxx',
        kind  = define.CompletionItemKind.Variable,
    },
}

-- [已迁移至 test/feature/completion/string.lua] 类字段字面量联合字符串补全

-- [已迁移至 test/feature/completion/string.lua] @enum 相关补全（T.x/T.y 与 key enum）

-- [已迁移至 test/feature/completion/string.lua] @enum(key) 字符串键补全

TEST [[
--
<??>
]]
(function (results)
    assert(#results > 2)
end)

TEST [[
--xxx
<??>
]]
(function (results)
    assert(#results > 2)
end)

TEST [[
---<??>
local x = function (x, y) end
]]
(EXISTS)

TEST [[
--- <??>
local x = function (x, y) end
]]
(EXISTS)

TEST [[
local x = {
<??>
})
]]
(function (results)
    for _, res in ipairs(results) do
        assert(res.label ~= 'do')
    end
end)

-- [已迁移至 test/feature/completion/luadoc.lua] 注解对象参数字面量字段补全（Options）

TEST [[
local t1 = {}

t1.A = {}
t1.A.B = {}
t1.A.B.C = 1

local t2 = t1

print(t2.A.<??>)
]]
{
    {
        label    = 'B',
        kind     = define.CompletionItemKind.Field,
    },
}

-- [已迁移至 test/feature/completion/luadoc.lua] overload 函数签名补全（local/global/table）

-- [已迁移至 test/feature/completion/luadoc.lua] private/protected 字段可见性补全

-- [已迁移至 test/feature/completion/luadoc.lua] @see 类名补全

-- [已迁移至 test/feature/completion/luadoc.lua] 类字段函数签名补全（fun(x: string): string）

-- [已迁移至 test/feature/completion/luadoc.lua] table<string, integer> 字段枚举补全

-- [已迁移至 test/feature/completion/luadoc.lua] 内联 table 注解参数字段补全

-- [已迁移至 test/feature/completion/luadoc.lua] 递归 alias 数组字面量补全

-- [已迁移至 test/feature/completion/luadoc.lua] 回调体内局部变量与字段补全混合场景

TEST [[
while true do
    continue<??>
end
]]
{
    {
        label      = 'continue',
        kind       = define.CompletionItemKind.Keyword,
    },
    {
        label      = 'goto continue ..',
        kind       = define.CompletionItemKind.Snippet,
        additionalTextEdits = {
            {
                start   = 10004,
                finish  = 10004,
                newText = 'goto ',
            },
            {
                start   = 20000,
                finish  = 20000,
                newText = '    ::continue::\n',
            },
        }
    },
}

TEST [[
while true do
    goto continue<??>
end
]]
{
    {
        label      = 'continue',
        kind       = define.CompletionItemKind.Keyword,
    },
    {
        label      = 'goto continue ..',
        kind       = define.CompletionItemKind.Snippet,
        additionalTextEdits = {
            {
                start   = 20000,
                finish  = 20000,
                newText = '    ::continue::\n',
            }
        }
    },
}

TEST [[
while true do
    goto continue<??>
    ::continue::
end
]]
{
    {
        label      = 'continue',
        kind       = define.CompletionItemKind.Keyword,
    },
    {
        label      = 'goto continue ..',
        kind       = define.CompletionItemKind.Snippet,
        additionalTextEdits = {
        }
    },
}

-- [已迁移至 test/feature/completion/luadoc.lua] 带引号字段名补全（含 description/textEdit）
-- [已迁移至 test/feature/completion/luadoc.lua] A 类型点号/冒号调用方法补全
-- [已迁移至 test/feature/completion/luadoc.lua] A 属性表构造补全（type/param）

-- [已迁移至 test/feature/completion/luadoc.lua] generic + overload 构造参数字段补全（含 namespace）

-- [已迁移至 test/feature/completion/string.lua] @enum(key) + 链式 self 调用参数补全

-- [已迁移至 test/feature/completion/luadoc.lua] 泛型类字段/方法补全（Array<T>）
