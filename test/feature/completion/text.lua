-- 上下文词（workspaceWord）补全测试
-- 对应 script/feature/completion/text.lua

local config = test.scope.config

-- 表字段作为 word 补全（kind=Text，workspaceWord 当前文档词）
-- Enable 模式：有语义结果时仍显示上下文词（stdlib 全局会模糊混入）
config:set(test.fileUri, 'Lua.completion.showWord', 'Enable')
TEST_COMPLETION [[
local t = {
    xxxxx = 1,
}
xx<??>
]] {
    include = true,
    {
        label = 'xxxxx',
        kind  = ls.spec.CompletionItemKind.Text,
    },
}
config:set(test.fileUri, 'Lua.completion.showWord', nil)

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