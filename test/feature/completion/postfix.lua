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

-- ifcall: 标识符形式
TEST_COMPLETION [[
xx@ifcall<??>
]] {
    [1] = {
        label = 'ifcall',
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

-- ifcall: 调用形式（无参数）
TEST_COMPLETION [[
xx()@ifcall<??>
]] {
    [1] = {
        label = 'ifcall',
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

-- ifcall: 调用形式（有参数）
TEST_COMPLETION [[
xx(1, 2)@ifcall<??>
]] {
    [1] = {
        label = 'ifcall',
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

-- local
TEST_COMPLETION [[
xx@local<??>
]] {
    [1] = {
        label = 'local',
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

-- ipairs
TEST_COMPLETION [[
xx@ipairs<??>
]] {
    [1] = {
        label = 'ipairs',
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

-- pairs
TEST_COMPLETION [[
xx@pairs<??>
]] {
    [1] = {
        label = 'pairs',
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

-- unpack
TEST_COMPLETION [[
xx@unpack<??>
]] {
    [1] = {
        label = 'unpack',
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

-- remove
TEST_COMPLETION [[
xx@remove<??>
]] {
    [1] = {
        label = 'remove',
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

-- concat
TEST_COMPLETION [[
xx@concat<??>
]] {
    [1] = {
        label = 'concat',
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

-- 修复前会崩溃: [#] 中 unary 节点 exp=nil 导致 assert
-- cursor 紧跟 # 后，word 为空，返回所有可见局部变量（主 chunk 的 ...）
TEST_COMPLETION [[
self.results.list[#<??>]
]] (EXISTS)

-- word=ff，无匹配局部或全局，返回 nil
TEST_COMPLETION [[
fff[#ff<??>]
]] (nil)

-- cursor 紧跟 # 后，同 case 1
TEST_COMPLETION [[
local b = fff.kkk[#<??>]
]] (EXISTS)

TEST_COMPLETION [[
local c = fff.kkk[#<??>].yy
]] (EXISTS)
