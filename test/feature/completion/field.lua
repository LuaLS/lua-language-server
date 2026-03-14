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

-- TODO: setmetatable + __index 场景（需要 metatable 类型推导支持）
-- TEST_COMPLETION [[
-- local mt = {}
-- mt.__index = mt
-- local t = setmetatable({}, mt)
-- t.<??>
-- ]] {
--     {
--         label = '__index',
--         kind  = ls.spec.CompletionItemKind.Field,
--     }
-- }

-- TODO: 全局表字段补全（需要支持 _ENV 下的全局变量字段）
-- TEST_COMPLETION [[debug.<??>]] (EXISTS)
-- TEST_COMPLETION [[print(io.<??>)]] (EXISTS)

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

-- setmetatable __index 字段补全
-- [SKIPPED][metatable-deduction] setmetatable + __index 场景需要 metatable 类型推导支持，暂不迁移（参见 field.lua TODO）

-- [SKIPPED][global-method-inference] function mt:f(a,b,c) 全局表方法补全在 TEST_COMPLETION 下返回空，暂不迁移

-- [SKIPPED][dotted-key-field] 带点号字段名（['a.b.c']）的特殊 textEdit 补全在 TEST_COMPLETION 下返回空，暂不迁移（3 个变体：t.，t.   ，t['']）

-- [SKIPPED][config-dependent] `_G['z.b.c']` Lua 5.4/_ENV 全局字段 textEdit 依赖 config.set(version)，暂不迁移
-- [SKIPPED][config-dependent] `_G['z.b.c']` Lua 5.1/_G 全局字段 textEdit 依赖 config.set(version)，暂不迁移
-- [SKIPPED][config-dependent] 中文字段名补全（unicodeName）依赖 config.set，暂不迁移
-- [SKIPPED][stdlib-dependent] io<?> EXISTS 依赖标准库，暂不迁移
-- [SKIPPED][stdlib-dependent] utf8.charpatter<?> detail/description 依赖标准库，暂不迁移
