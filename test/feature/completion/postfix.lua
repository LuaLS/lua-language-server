-- postfix 补全测试（当前入口未加载）

TEST_COMPLETION [[
xx@pcall<??>
]] {
    [1] = {
        label = 'pcall',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
xx()@pcall<??>
]] {
    [1] = {
        label = 'pcall',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
xx(1, 2, 3)@pcall<??>
]] {
    [1] = {
        label = 'pcall',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
xx@xpcall<??>
]] {
    [1] = {
        label = 'xpcall',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
xx()@xpcall<??>
]] {
    [1] = {
        label = 'xpcall',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
xx(1, 2, 3)@xpcall<??>
]] {
    [1] = {
        label = 'xpcall',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
xx@function<??>
]] {
    [1] = {
        label = 'function',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
xx.yy@method<??>
]] {
    [1] = {
        label = 'method',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
xx:yy@method<??>
]] {
    [1] = {
        label = 'method',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
xx@insert<??>
]] {
    [1] = {
        label = 'insert',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
xx++<??>
]] {
    [1] = {
        label = '++',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
    [2] = {
        label = '++?',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = ''
            }
        }
    },
}

TEST_COMPLETION [[
fff(function ()
    xx@xpcall<??>
end)
]] {
    [1] = {
        label = 'xpcall',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = EXISTS,
        additionalTextEdits = {
            {
                start   = EXISTS,
                finish  = EXISTS,
                newText = '',
            }
        }
    },
}
