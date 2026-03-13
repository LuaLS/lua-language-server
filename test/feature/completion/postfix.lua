-- postfix 补全测试（当前入口未加载）

TEST_COMPLETION [[
xx@pcall<??>
]] {
    [1] = {
        label = 'pcall',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = {
            start   = 3,
            finish  = 8,
            newText = 'pcall(xx$1)$0',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 3,
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
        textEdit = {
            start   = 5,
            finish  = 10,
            newText = 'pcall(xx)',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 5,
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
        textEdit = {
            start   = 12,
            finish  = 17,
            newText = 'pcall(xx, 1, 2, 3)',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 12,
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
        textEdit = {
            start   = 3,
            finish  = 9,
            newText = 'xpcall(xx, ${1:debug.traceback}$2)$0',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 3,
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
        textEdit = {
            start   = 5,
            finish  = 11,
            newText = 'xpcall(xx, ${1:debug.traceback})$0',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 5,
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
        textEdit = {
            start   = 12,
            finish  = 18,
            newText = 'xpcall(xx, ${1:debug.traceback}, 1, 2, 3)$0',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 12,
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
        textEdit = {
            start   = 3,
            finish  = 11,
            newText = 'function xx($1)\n\t$0\nend',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 3,
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
        textEdit = {
            start   = 6,
            finish  = 12,
            newText = 'function xx:yy($1)\n\t$0\nend',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 6,
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
        textEdit = {
            start   = 6,
            finish  = 12,
            newText = 'function xx:yy($1)\n\t$0\nend',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 6,
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
        textEdit = {
            start   = 3,
            finish  = 9,
            newText = 'table.insert(xx, $0)',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 3,
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
        textEdit = {
            start   = 2,
            finish  = 4,
            newText = 'xx = xx + 1',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 2,
                newText = ''
            }
        }
    },
    [2] = {
        label = '++?',
        kind  = ls.spec.CompletionItemKind.Snippet,
        textEdit = {
            start   = 2,
            finish  = 4,
            newText = 'xx = (xx or 0) + 1',
        },
        additionalTextEdits = {
            {
                start   = 0,
                finish  = 2,
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
        textEdit = {
            start   = 10007,
            finish  = 10013,
            newText = 'xpcall(xx, ${1:debug.traceback}$2)$0',
        },
        additionalTextEdits = {
            {
                start   = 10004,
                finish  = 10007,
                newText = '',
            }
        }
    },
}
