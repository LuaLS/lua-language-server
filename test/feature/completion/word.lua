TEST_COMPLETION [[
local zabcdefg
local zabcde
zabcde<??>
]] {
    {
        label = 'zabcde',
        kind = ls.spec.CompletionItemKind.Variable,
    },
    {
        label = 'zabcdefg',
        kind = ls.spec.CompletionItemKind.Variable,
    },
}

TEST_COMPLETION [[
local zabcde
za<??>
]] {
    {
        label = 'zabcde',
        kind = ls.spec.CompletionItemKind.Variable,
    }
}

TEST_COMPLETION [[
local zabcde
zace<??>
]] {
    {
        label = 'zabcde',
        kind = ls.spec.CompletionItemKind.Variable,
    }
}

TEST_COMPLETION [[
ZABC = x
local zabc
zac<??>
]] {
    {
        label = 'zabc',
        kind = ls.spec.CompletionItemKind.Variable,
    },
    {
        label = 'ZABC',
        kind = ls.spec.CompletionItemKind.Field,
    },
}

-- 全局函数补全
TEST_COMPLETION [[
function myfunc() end
myf<??>
]] {
    {
        label = 'myfunc',
        kind  = ls.spec.CompletionItemKind.Function,
    },
}

-- 局部变量遮蔽全局：局部 myfunc 遮蔽全局 function myfunc
TEST_COMPLETION [[
function myfunc() end
local myfunc = 1
myf<??>
]] {
    {
        label = 'myfunc',
        kind  = ls.spec.CompletionItemKind.Variable,
    },
}
