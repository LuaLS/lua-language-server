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
    {
        label = 'myfunc',
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
        label = 'mymethod',
        kind  = ls.spec.CompletionItemKind.Method,
    },
}
