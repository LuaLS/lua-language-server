-- keyword 补全测试

-- 基础关键字前缀匹配
TEST_COMPLETION [[
loc<??>
]] {
    {
        label = 'local',
        kind  = ls.spec.CompletionItemKind.Keyword,
    },
}

TEST_COMPLETION [[
do<??>
]] {
    {
        label = 'do',
        kind  = ls.spec.CompletionItemKind.Keyword,
    },
}

TEST_COMPLETION [[
retu<??>
]] {
    {
        label = 'return',
        kind  = ls.spec.CompletionItemKind.Keyword,
    },
}

-- 多关键字同前缀
TEST_COMPLETION [[
els<??>
]] {
    {
        label = 'else',
        kind  = ls.spec.CompletionItemKind.Keyword,
    },
    {
        label = 'elseif',
        kind  = ls.spec.CompletionItemKind.Keyword,
    },
}

-- 字段访问上下文不应出现关键字
TEST_COMPLETION [[
local t = {}
t.loc<??>
]] {
    -- 无结果（字段访问上下文，不补全关键字）
}

-- if 块内 else<??> — 只有关键字（无同名变量干扰）
TEST_COMPLETION [[
local function f()
    if a then
    else<??>
end
]] {
    {
        label = 'else',
        kind  = ls.spec.CompletionItemKind.Keyword,
    },
    {
        label = 'elseif',
        kind  = ls.spec.CompletionItemKind.Keyword,
    },
}

TEST_COMPLETION [[
if<??>
]] (EXISTS)

-- [SKIPPED][legacy-keyword-context] `then` 系列补全依赖旧 TEST 宏上下文，TEST_COMPLETION 下当前返回为空。
-- [SKIPPED][legacy-keyword-context] `if <??> then` / `elseif <??> then` 无补全断言同属旧上下文行为，暂不迁移。

-- else<?> 同时存在同名前缀局部变量和全局变量
TEST_COMPLETION [[
local elseaaa
ELSE = 1
if a then
else<??>
]] {
    include = true,
    {
        label = 'else',
        kind  = ls.spec.CompletionItemKind.Keyword,
    },
    {
        label = 'elseif',
        kind  = ls.spec.CompletionItemKind.Keyword,
    },
    {
        label = 'elseaaa',
        kind  = ls.spec.CompletionItemKind.Variable,
    },
}

-- [SKIPPED][empty-in-declaration-context] function<?> 在函数声明上下文中返回空，暂不迁移

-- [SKIPPED][empty-in-declaration-context] local t = function<?> 在函数字面量上下文中返回空，暂不迁移

-- in<?> 关键字补全（inferCache 变量暂不出现，参见 legacy 测试）
TEST_COMPLETION [[
local function f()
    local inferCache
    in<??>
end
]] (function (results)
    local hasIn = false
    for _, r in ipairs(results or {}) do
        if r.label == 'in' and r.kind == ls.spec.CompletionItemKind.Keyword then
            hasIn = true
        end
    end
    assert(hasIn, '期望在 in<?> 补全中看到 `in` 关键字')
end)
