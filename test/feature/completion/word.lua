TEST_COMPLETION [[
local zabcde
za<??>
]] {
    {
        label = 'zabcde',
        kind = ls.spec.CompletionItemKind.Variable,
    }
}
