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
