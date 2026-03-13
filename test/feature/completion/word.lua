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

-- 单个局部变量自身补全
TEST_COMPLETION [[
local xxxx
xxxx<??>
]] {
    {
        label = 'xxxx',
        kind = ls.spec.CompletionItemKind.Variable,
    },
}

-- 大小写混合变量同时匹配
TEST_COMPLETION [[
local xxxx
local XXXX
xxxx<??>
]] {
    {
        label = 'XXXX',
        kind = ls.spec.CompletionItemKind.Variable,
    },
    {
        label = 'xxxx',
        kind = ls.spec.CompletionItemKind.Variable,
    },
}

-- TODO: 表字段作为 word 补全（kind=Text）—— 需要 workspaceWord 特性支持
-- TEST_COMPLETION [[
-- local t = {
--     xxxxx = 1,
-- }
-- xx<??>
-- ]] {
--     {
--         label = 'xxxxx',
--         kind = ls.spec.CompletionItemKind.Text,
--     },
-- }

-- 方括号内的变量补全
TEST_COMPLETION [[
local index
tbl[inde<??>]
]] {
    {
        label = 'index',
        kind = ls.spec.CompletionItemKind.Variable,
    },
}

-- 函数调用括号内应有补全（EXISTS）
-- 原测试用 collectgarbage，新测试自定义函数避免依赖标准库
TEST_COMPLETION [[
local myarg = 1
local function myfunc(x) end
myfunc(<??>)
]] (EXISTS)

-- 函数调用参数位置（表达式上下文）不应出现关键字
TEST_COMPLETION [[
local fa = 1
local function myfunc(x) end
myfunc(fa<??>)
]] {
    {
        label = 'fa',
        kind = ls.spec.CompletionItemKind.Variable,
    },
}

-- 函数参数定义位置：只出现外部变量 fff，不出现参数名 ff 自身
TEST_COMPLETION [[
local fff
local function f(ff<??>)
end
]] {
    {
        label = 'fff',
        kind = ls.spec.CompletionItemKind.Variable,
    },
}
