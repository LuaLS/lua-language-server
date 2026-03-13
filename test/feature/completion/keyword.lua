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
