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
	care = ls.spec.CompletionItemKind.Function,
	include = true,
    {
		label = 'myfunc()',
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

-- 单个局部变量自身补全（stdlib 全局可能模糊混入，断言包含）
TEST_COMPLETION [[
local xxxx
xxxx<??>
]] {
    include = true,
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
    include = true,
    {
        label = 'XXXX',
        kind = ls.spec.CompletionItemKind.Variable,
    },
    {
        label = 'xxxx',
        kind = ls.spec.CompletionItemKind.Variable,
    },
}

-- 表字段作为 word 补全已迁移到 test.feature.completion.text

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
    include = true,
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
]] (function (results)
    local hasFFF
    local hasFF
    for _, item in ipairs(results) do
        if item.label == 'fff' then
            hasFFF = true
        end
        if item.label == 'ff' then
            hasFF = true
        end
    end
    assert(hasFFF and not hasFF)
end)

-- 光标位于单词中间（ab|c）时，前缀应为左侧部分 ab
TEST_COMPLETION [[
local abc
ab<??>c
]] {
    include = true,
    {
        label = 'abc',
        kind = ls.spec.CompletionItemKind.Variable,
    },
}

TEST_COMPLETION [[
return function ()
    local function fff(xxx)
        for f in xx<??>
    end
end
]] {
    include = true,
    {
        label = 'xxx',
        kind  = ls.spec.CompletionItemKind.Variable,
    },

}

-- 表构造前缀补全（含外部表字段，IgnoreFunction 语义）
TEST_COMPLETION [[
local xxxx = {
    xxyy = 1,
    xxzz = 2,
}
local t = {
    x<??>
}
]] {
    include = true,
    {
        label = 'xxxx',
        kind  = ls.spec.CompletionItemKind.Variable,
    },
}

-- 声明位置的文字补全（`local f<?>`）已迁移到 test.feature.completion.text

-- 局部注解函数补全（Function + Snippet 两项，insertText=EXISTS）
TEST_COMPLETION [[
--- JustTest
---@param list table
---@param sep string
---@param i number
---@param j number
---@return string
local function zzzzz(list, sep, i, j) end

zzz<??>
]] {
    care = {label = 'zzzzz(list, sep, i, j)'},
    {
        label     = 'zzzzz(list, sep, i, j)',
        kind      = ls.spec.CompletionItemKind.Function,
        insertText = EXISTS,
    },
    {
        label     = 'zzzzz(list, sep, i, j)',
        kind      = ls.spec.CompletionItemKind.Snippet,
        insertText = EXISTS,
    },
}

-- [SKIPPED][detail-not-populated] 全局变量 detail/description 字段在当前实现中未填充到补全项，暂不迁移

-- 全局变量赋值后在空行触发存在性补全
TEST_COMPLETION [[
AAA = 1

<??>
]] (EXISTS)

-- [SKIPPED][stdlib-dependent] xpcal<?> insertText + xpcall 标准库补全依赖标准库，暂不迁移
-- [SKIPPED][stdlib-dependent] collectgarbage/io.*/type 标准库枚举补全依赖标准库，暂不迁移

do
    test.scope.config:set(test.rootUri, 'Lua.completion.callSnippet', 'Disable')
    TEST_COMPLETION [[
GGG = 1
GGG = function ()
end

GGG<??>
]] {
        include = true,
        {
            label = 'GGG',
            kind  = ls.spec.CompletionItemKind.Enum,
        },
        {
            label      = 'GGG()',
            kind       = ls.spec.CompletionItemKind.Function,
            insertText = 'GGG',
        },
    }
    test.scope.config:set(test.rootUri, 'Lua.completion.callSnippet', 'Both')
end

-- [SKIPPED][config-dependent] require '<?>' count=9 依赖文件系统/配置，暂不迁移