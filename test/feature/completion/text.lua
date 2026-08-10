-- 上下文词（workspaceWord）补全测试
-- 对应 script/feature/completion/text.lua

local config = test.scope.config

-- 表字段作为 word 补全（kind=Text，workspaceWord 当前文档词）
-- Fallback 模式（默认）：无语义结果时显示上下文词
TEST_COMPLETION [[
local t = {
    xxxxx = 1,
}
xx<??>
]] {
    {
        label = 'xxxxx',
        kind  = ls.spec.CompletionItemKind.Text,
    },
}

-- 声明位置的 1 字符前缀也能出 Text 词（Enable 模式）
config:set(test.fileUri, 'Lua.completion.showWord', 'Enable')
TEST_COMPLETION [[
print(ff2)
local f<??>
]] {
    care = { kind = ls.spec.CompletionItemKind.Text },
    {
        label = 'ff2',
        kind  = ls.spec.CompletionItemKind.Text,
    },
}
config:set(test.fileUri, 'Lua.completion.showWord', nil)
