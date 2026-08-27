print('[feature.completion.field] 测试中...')

-- 无前缀的字段访问补全（t.<??>）
TEST_COMPLETION [[
local t = {}
t.abc = 1
t.abd = 2
t.<??>
]] {
    {
        label = 'abc',
        kind  = ls.spec.CompletionItemKind.Field,
    },
    {
        label = 'abd',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

-- 带前缀的字段补全（基础场景）
TEST_COMPLETION [[
local t = {}
t.abc = 1
t.abd = 2
t.ab<??>
]] {
    {
        label = 'abc',
        kind  = ls.spec.CompletionItemKind.Field,
    },
    {
        label = 'abd',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

-- 方法字段补全（function 值）
TEST_COMPLETION [[
local t = {}
function t.myfunc() end
t.my<??>
]] {
    care = {
        kind = ls.spec.CompletionItemKind.Function,
    },
    {
        label = 'myfunc()',
        kind  = ls.spec.CompletionItemKind.Function,
    },
}

-- 冒号方法补全（kind = Method）
TEST_COMPLETION [[
local t = {}
function t:mymethod() end
t:my<??>
]] {
    {
		label = 'mymethod()',
        kind  = ls.spec.CompletionItemKind.Method,
    },
}

-- 局部表字段，触发符与对象之间有空白
TEST_COMPLETION [[
local t = {}
t.a = {}
t.b = {}
t.   <??>
]] {
    {
        label = 'a',
        kind  = ls.spec.CompletionItemKind.Field,
    },
    {
        label = 'b',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

-- 补全后下一行有其他语句
TEST_COMPLETION [[
local t = {
    a = {},
}
t.<??>
xxx()
]] {
    {
        label = 'a',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

-- 触发符与后面还有其他 token（t .    <??> b）→ 应该仍有结果
TEST_COMPLETION [[
local t = {
    a = 1,
}
t .    <??> b
]] (EXISTS)

-- 未定义变量的字段（xx.<??>）→ 没有字段信息，nil
TEST_COMPLETION [[
do
    xx.<??>
end
]] (nil)

-- 函数内的局部表字段
TEST_COMPLETION [[
return function ()
    local t = {
        a = {},
        b = {},
    }
    t.<??>
end
]] {
    {
        label = 'a',
        kind  = ls.spec.CompletionItemKind.Field,
    },
    {
        label = 'b',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

-- 光标位于字段名前缀与点号之间（ab|.c）时，应对 t 的字段名做前缀补全
TEST_COMPLETION [[
local t = {}
t.ab = {}
t.ab<??>.c
]] {
    {
        label = 'ab',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

-- 光标位于点号之后（ab.|c）时，应对 t.ab 的字段补全
TEST_COMPLETION [[
local t = {}
t.ab = {
    c1 = 1,
    c2 = 2,
}
t.ab.<??>c
]] {
    {
        label = 'c1',
        kind  = ls.spec.CompletionItemKind.Field,
    },
    {
        label = 'c2',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

-- setmetatable + __index 场景
TEST_COMPLETION [[
--!include setmetatable
local mt = {}
mt.__index = mt
local t = setmetatable({}, mt)
t.<??>
]] {
    {
        label = '__index',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

-- setmetatable + __index 指向另一个表：字段来自 __index 目标
TEST_COMPLETION [[
--!include setmetatable
local base = { aaa = 1, bbb = 2 }
local mt = { __index = base }
local t = setmetatable({}, mt)
t.a<??>
]] {
    {
        label = 'aaa',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

-- 关键字字段名（`log.in` 中 `in` 是关键字）：
-- 应解析为真实 field 并阻止 word/global 补全，而不是输出 `in` 前缀词
TEST_COMPLETION [[
inxx = 1
local log
log.in<??>
]] (nil)

-- 全局表字段补全
TEST_COMPLETION [[
debug = {}
debug.x = 1
debug.<??>
]] (EXISTS)

TEST_COMPLETION [[
io = { x = 1 }
print(io.<??>)
]] (EXISTS)

TEST_COMPLETION [[
local x
x.y.z = xxx

x.y.<??>
]] {
    {
        label = 'z',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

TEST_COMPLETION [[
local t1 = {}

t1.A = {}
t1.A.B = {}
t1.A.B.C = 1

local t2 = t1

print(t2.A.<??>)
]] {
    {
        label = 'B',
        kind  = ls.spec.CompletionItemKind.Field,
    },
}

-- [SKIPPED][legacy-field-context] `utf<??>'xxx'` 在 TEST_COMPLETION 下当前无结果，暂不迁移。

TEST_COMPLETION [[
local m = {}

function m.f()
end

m.f()
m.<??>
]] {
    [1] = EXISTS,
}

-- setmetatable + __index 场景（已迁移，见上方两处 TEST_COMPLETION）

-- 全局表方法补全（function mt:f）
TEST_COMPLETION [[
mt = {}
function mt:f(a, b, c)
end
mt:f<??>
]] {
    {
        label = 'f(a, b, c)',
        kind  = ls.spec.CompletionItemKind.Method,
        insertText = EXISTS,
    },
    {
        label = 'f(a, b, c)',
        kind  = ls.spec.CompletionItemKind.Snippet,
        insertText = 'f(${1:a}, ${2:b}, ${3:c})',
    },
}

-- 带点号字段名（['a.b.c']）：特殊 textEdit 补全
TEST_COMPLETION [[
local t = {
    ['a.b.c'] = {}
}
t.<??>
]] {
    {
        label = "'a.b.c'",
        kind  = ls.spec.CompletionItemKind.Field,
        textEdit = {
            start   = 30002,
            finish  = 30002,
            newText = "['a.b.c']",
        },
        additionalTextEdits = EXISTS,
    },
}

do
    test.scope.config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.4')
    TEST_COMPLETION [[
_G['z.b.c'] = {}

z<??>
]] {
        {
            label = "'z.b.c'",
            kind  = ls.spec.CompletionItemKind.Field,
            textEdit = {
                start   = 20000,
                finish  = 20001,
                newText = "_ENV['z.b.c']",
            },
        },
    }
    test.scope.config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.1')
    TEST_COMPLETION [[
_G['z.b.c'] = {}

z<??>
]] {
        {
            label = "'z.b.c'",
            kind  = ls.spec.CompletionItemKind.Field,
            textEdit = {
                start   = 20000,
                finish  = 20001,
                newText = "_G['z.b.c']",
            },
        },
    }
    test.scope.config:set(test.rootUri, 'Lua.runtime.version', nil)
end

do
    test.scope.config:set(test.rootUri, 'Lua.runtime.unicodeName', true)
    TEST_COMPLETION [[
中文字段 = 1

中文<??>
]] {
        {
            label = '中文字段',
            kind  = ls.spec.CompletionItemKind.Enum,
        },
    }
    test.scope.config:set(test.rootUri, 'Lua.runtime.unicodeName', false)
    TEST_COMPLETION [[
中文字段 = 1

中文<??>
]] {
        {
            label = '中文字段',
            kind  = ls.spec.CompletionItemKind.Enum,
            textEdit = {
                start   = 20000,
                finish  = 20002,
                newText = '_ENV["中文字段"]',
            },
        },
    }
    test.scope.config:set(test.rootUri, 'Lua.runtime.unicodeName', nil)
end

-- [SKIPPED][stdlib-dependent] io<?> EXISTS 依赖跨文件全局字段推断（env child value 为 field↔variable 引用循环，赋值 table 不在 value 链上），暂不迁移
TEST_COMPLETION [[
print(io.<??>)
]] (EXISTS)

do
    TEST_COMPLETION [[
GG = {}
function GG.ff()
end

GG.<??>
]] {
        {
            label      = 'ff()',
            kind       = ls.spec.CompletionItemKind.Function,
            insertText = 'ff',
        },
    }
end
-- [SKIPPED][stdlib-dependent] utf8.charpatter<?> detail/description 依赖标准库，暂不迁移

print('[feature.completion.field] 测试完毕')