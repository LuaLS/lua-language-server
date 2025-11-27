CHECK'a.'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 2,
    locals  = "<IGNORE>",
    bfinish = 2,
    [1]     = {
        type   = "getfield",
        start  = 0,
        finish = 2,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        dot    = {
            type   = ".",
            start  = 1,
            finish = 2,
        },
    },
}

CHECK'a:'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 2,
    locals  = "<IGNORE>",
    bfinish = 2,
    [1]     = {
        type   = "getmethod",
        start  = 0,
        finish = 2,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        colon  = {
            type   = ":",
            start  = 1,
            finish = 2,
        },
    },
}

CHECK [[
if true
a
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20000,
    locals  = "<IGNORE>",
    bfinish = 20000,
    [1]     = {
        type   = "if",
        start  = 0,
        finish = 20000,
        parent = "<IGNORE>",
        [1]    = {
            type    = "ifblock",
            start   = 0,
            bstart  = 7,
            finish  = 20000,
            keyword = {
                [1] = 0,
                [2] = 2,
            },
            parent  = "<IGNORE>",
            filter  = {
                type   = "boolean",
                start  = 3,
                finish = 7,
                parent = "<IGNORE>",
                [1]    = true,
            },
            bfinish = 20000,
            [1]     = {
                type   = "getglobal",
                start  = 10000,
                finish = 10001,
                parent = "<IGNORE>",
                node   = "<IGNORE>",
                [1]    = "a",
            },
        },
    },
}

CHECK [[
if true then
a
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20000,
    locals  = "<IGNORE>",
    bfinish = 20000,
    [1]     = {
        type   = "if",
        start  = 0,
        finish = 20000,
        parent = "<IGNORE>",
        [1]    = {
            type    = "ifblock",
            start   = 0,
            bstart  = 12,
            finish  = 20000,
            keyword = {
                [1] = 0,
                [2] = 2,
                [3] = 8,
                [4] = 12,
            },
            parent  = "<IGNORE>",
            filter  = {
                type   = "boolean",
                start  = 3,
                finish = 7,
                parent = "<IGNORE>",
                [1]    = true,
            },
            bfinish = 20000,
            [1]     = {
                type   = "getglobal",
                start  = 10000,
                finish = 10001,
                parent = "<IGNORE>",
                node   = "<IGNORE>",
                [1]    = "a",
            },
        },
    },
}

CHECK [[
x =
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 10000,
    locals  = "<IGNORE>",
    bfinish = 10000,
    [1]     = {
        type   = "setglobal",
        start  = 0,
        finish = 1,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        [1]    = "x",
    },
}

CHECK'1 == 2'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 6,
    locals  = "<IGNORE>",
    bfinish = 6,
    [1]     = {
        type   = "binary",
        start  = 0,
        finish = 6,
        parent = "<IGNORE>",
        op     = {
            type   = "==",
            start  = 2,
            finish = 4,
        },
        [1]    = {
            type   = "integer",
            start  = 0,
            finish = 1,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [2]    = {
            type   = "integer",
            start  = 5,
            finish = 6,
            parent = "<IGNORE>",
            [1]    = 2,
        },
    },
}

CHECK 'local function a'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 16,
    locals  = "<IGNORE>",
    bfinish = 16,
    [1]     = {
        type   = "local",
        start  = 15,
        vstart = 6,
        finish = 16,
        effect = 16,
        range  = 16,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type    = "function",
            start   = 6,
            bstart  = 16,
            finish  = 16,
            keyword = {
                [1] = 6,
                [2] = 14,
            },
            parent  = "<IGNORE>",
            bfinish = 16,
        },
        [1]    = "a",
    },
}

CHECK 'local function'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 14,
    locals  = "<IGNORE>",
    bfinish = 14,
    [1]     = {
        type    = "function",
        start   = 6,
        bstart  = 14,
        finish  = 14,
        keyword = {
            [1] = 6,
            [2] = 14,
        },
        parent  = "<IGNORE>",
        bfinish = 14,
    },
}

CHECK 'local function f('
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 17,
    locals  = "<IGNORE>",
    bfinish = 17,
    [1]     = {
        type   = "local",
        start  = 15,
        vstart = 6,
        finish = 16,
        effect = 16,
        range  = 17,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type    = "function",
            start   = 6,
            bstart  = 17,
            finish  = 17,
            keyword = {
                [1] = 6,
                [2] = 14,
            },
            parent  = "<IGNORE>",
            args    = {
                type   = "funcargs",
                start  = 16,
                finish = 17,
                parent = "<IGNORE>",
            },
            bfinish = 17,
        },
        [1]    = "f",
    },
}

CHECK 'local function a(v'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 18,
    locals  = "<IGNORE>",
    bfinish = 18,
    [1]     = {
        type   = "local",
        start  = 15,
        vstart = 6,
        finish = 16,
        effect = 16,
        range  = 18,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type    = "function",
            start   = 6,
            bstart  = 18,
            finish  = 18,
            keyword = {
                [1] = 6,
                [2] = 14,
            },
            parent  = "<IGNORE>",
            args    = {
                type   = "funcargs",
                start  = 16,
                finish = 18,
                parent = "<IGNORE>",
                [1]    = {
                    type   = "local",
                    start  = 17,
                    finish = 18,
                    effect = 18,
                    parent = "<IGNORE>",
                    [1]    = "v",
                },
            },
            locals  = "<IGNORE>",
            bfinish = 18,
        },
        [1]    = "a",
    },
}

CHECK 'function a'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 10,
    locals  = "<IGNORE>",
    bfinish = 10,
    [1]     = {
        type   = "setglobal",
        start  = 9,
        vstart = 0,
        finish = 10,
        range  = 10,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type    = "function",
            start   = 0,
            bstart  = 10,
            finish  = 10,
            keyword = {
                [1] = 0,
                [2] = 8,
            },
            parent  = "<IGNORE>",
            bfinish = 10,
        },
        [1]    = "a",
    },
}

CHECK 'function a:'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 11,
    locals  = "<IGNORE>",
    bfinish = 11,
    [1]     = {
        type   = "setmethod",
        start  = 9,
        vstart = 0,
        finish = 11,
        range  = 11,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        colon  = {
            type   = ":",
            start  = 10,
            finish = 11,
        },
        value  = {
            type    = "function",
            start   = 0,
            bstart  = 11,
            finish  = 11,
            keyword = {
                [1] = 0,
                [2] = 8,
            },
            parent  = "<IGNORE>",
            locals  = "<IGNORE>",
            bfinish = 11,
        },
    },
}

CHECK 'function a:b(v'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 14,
    locals  = "<IGNORE>",
    bfinish = 14,
    [1]     = {
        type   = "setmethod",
        start  = 9,
        vstart = 0,
        finish = 12,
        range  = 14,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        colon  = {
            type   = ":",
            start  = 10,
            finish = 11,
        },
        method = {
            type   = "method",
            start  = 11,
            finish = 12,
            parent = "<IGNORE>",
            [1]    = "b",
        },
        value  = {
            type    = "function",
            start   = 0,
            bstart  = 14,
            finish  = 14,
            keyword = {
                [1] = 0,
                [2] = 8,
            },
            parent  = "<IGNORE>",
            args    = {
                type   = "funcargs",
                start  = 12,
                finish = 14,
                parent = "<IGNORE>",
                [1]    = {
                    type   = "self",
                    start  = 8,
                    finish = 8,
                    effect = 8,
                    parent = "<IGNORE>",
                    [1]    = "self",
                },
                [2]    = {
                    type   = "local",
                    start  = 13,
                    finish = 14,
                    effect = 14,
                    parent = "<IGNORE>",
                    [1]    = "v",
                },
            },
            locals  = "<IGNORE>",
            bfinish = 14,
        },
    },
}

CHECK 'return local a'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 14,
    locals  = "<IGNORE>",
    returns = "<IGNORE>",
    bfinish = 14,
    [1]     = {
        type   = "return",
        start  = 0,
        finish = 6,
        parent = "<IGNORE>",
    },
    [2]     = {
        type   = "local",
        start  = 13,
        finish = 14,
        effect = 14,
        parent = "<IGNORE>",
        locPos = 7,
        [1]    = "a",
    },
}

CHECK 'end'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 3,
    locals  = "<IGNORE>",
    bfinish = 3,
}

CHECK 'local x = ,'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 11,
    locals  = "<IGNORE>",
    bfinish = 11,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 7,
        parent = "<IGNORE>",
        locPos = 0,
        [1]    = "x",
    },
}

CHECK 'local x = (a && b)'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 18,
    locals  = "<IGNORE>",
    bfinish = 18,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 18,
        range  = 18,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "paren",
            start  = 10,
            finish = 18,
            parent = "<IGNORE>",
            exp    = {
                type   = "binary",
                start  = 11,
                finish = 17,
                parent = "<IGNORE>",
                op     = {
                    type   = "and",
                    start  = 13,
                    finish = 15,
                },
                [1]    = {
                    type   = "getglobal",
                    start  = 11,
                    finish = 12,
                    parent = "<IGNORE>",
                    node   = "<IGNORE>",
                    [1]    = "a",
                },
                [2]    = {
                    type   = "getglobal",
                    start  = 16,
                    finish = 17,
                    parent = "<IGNORE>",
                    node   = "<IGNORE>",
                    [1]    = "b",
                },
            },
        },
        [1]    = "x",
    },
}

CHECK 'return 1 + + 1'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 14,
    locals  = "<IGNORE>",
    returns = "<IGNORE>",
    bfinish = 14,
    [1]     = {
        type   = "return",
        start  = 0,
        finish = 14,
        parent = "<IGNORE>",
        [1]    = {
            type   = "binary",
            start  = 7,
            finish = 14,
            parent = "<IGNORE>",
            op     = {
                type   = "+",
                start  = 9,
                finish = 10,
            },
            [1]    = {
                type   = "integer",
                start  = 7,
                finish = 8,
                parent = "<IGNORE>",
                [1]    = 1,
            },
            [2]    = {
                type   = "integer",
                start  = 13,
                finish = 14,
                parent = "<IGNORE>",
                [1]    = 1,
            },
        },
    },
}

CHECK 'return 1 + # + 2'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 16,
    locals  = "<IGNORE>",
    returns = "<IGNORE>",
    bfinish = 16,
    [1]     = {
        type   = "return",
        start  = 0,
        finish = 16,
        parent = "<IGNORE>",
        [1]    = {
            type   = "binary",
            start  = 7,
            finish = 16,
            parent = "<IGNORE>",
            op     = {
                type   = "+",
                start  = 13,
                finish = 14,
            },
            [1]    = {
                type   = "binary",
                start  = 7,
                finish = 12,
                parent = "<IGNORE>",
                op     = {
                    type   = "+",
                    start  = 9,
                    finish = 10,
                },
                [1]    = {
                    type   = "integer",
                    start  = 7,
                    finish = 8,
                    parent = "<IGNORE>",
                    [1]    = 1,
                },
                [2]    = {
                    type   = "unary",
                    start  = 11,
                    finish = 12,
                    parent = "<IGNORE>",
                    op     = {
                        type   = "#",
                        start  = 11,
                        finish = 12,
                    },
                },
            },
            [2]    = {
                type   = "integer",
                start  = 15,
                finish = 16,
                parent = "<IGNORE>",
                [1]    = 2,
            },
        },
    },
}

CHECK 'return 1 + 2 + # + 3'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20,
    locals  = "<IGNORE>",
    returns = "<IGNORE>",
    bfinish = 20,
    [1]     = {
        type   = "return",
        start  = 0,
        finish = 20,
        parent = "<IGNORE>",
        [1]    = {
            type   = "binary",
            start  = 7,
            finish = 20,
            parent = "<IGNORE>",
            op     = {
                type   = "+",
                start  = 17,
                finish = 18,
            },
            [1]    = {
                type   = "binary",
                start  = 7,
                finish = 16,
                parent = "<IGNORE>",
                op     = {
                    type   = "+",
                    start  = 13,
                    finish = 14,
                },
                [1]    = {
                    type   = "binary",
                    start  = 7,
                    finish = 12,
                    parent = "<IGNORE>",
                    op     = {
                        type   = "+",
                        start  = 9,
                        finish = 10,
                    },
                    [1]    = {
                        type   = "integer",
                        start  = 7,
                        finish = 8,
                        parent = "<IGNORE>",
                        [1]    = 1,
                    },
                    [2]    = {
                        type   = "integer",
                        start  = 11,
                        finish = 12,
                        parent = "<IGNORE>",
                        [1]    = 2,
                    },
                },
                [2]    = {
                    type   = "unary",
                    start  = 15,
                    finish = 16,
                    parent = "<IGNORE>",
                    op     = {
                        type   = "#",
                        start  = 15,
                        finish = 16,
                    },
                },
            },
            [2]    = {
                type   = "integer",
                start  = 19,
                finish = 20,
                parent = "<IGNORE>",
                [1]    = 3,
            },
        },
    },
}

CHECK [[
-
return
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20000,
    locals  = "<IGNORE>",
    bfinish = 20000,
    [1]     = {
        type   = "unary",
        start  = 0,
        finish = 10006,
        parent = "<IGNORE>",
        op     = {
            type   = "-",
            start  = 0,
            finish = 1,
        },
        [1]    = {
            type   = "getglobal",
            start  = 10000,
            finish = 10006,
            parent = "<IGNORE>",
            node   = "<IGNORE>",
            [1]    = "return",
        },
    },
}

CHECK [[
return;
::::
return;
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 30000,
    locals  = "<IGNORE>",
    returns = "<IGNORE>",
    bfinish = 30000,
    [1]     = {
        type   = "return",
        start  = 0,
        finish = 6,
        parent = "<IGNORE>",
    },
    [2]     = {
        type   = "return",
        start  = 20000,
        finish = 20006,
        parent = "<IGNORE>",
    },
}

CHECK [[
return;
goto;
return;
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 30000,
    locals  = "<IGNORE>",
    returns = "<IGNORE>",
    bfinish = 30000,
    [1]     = {
        type   = "return",
        start  = 0,
        finish = 6,
        parent = "<IGNORE>",
    },
    [2]     = {
        type   = "return",
        start  = 20000,
        finish = 20006,
        parent = "<IGNORE>",
    },
}

CHECK [[
call(,-,not,1)
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 10000,
    locals  = "<IGNORE>",
    bfinish = 10000,
    [1]     = {
        type   = "call",
        start  = 0,
        finish = 14,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        args   = {
            type   = "callargs",
            start  = 4,
            finish = 14,
            parent = "<IGNORE>",
            [1]    = {
                type   = "unary",
                start  = 6,
                finish = 7,
                parent = "<IGNORE>",
                op     = {
                    type   = "-",
                    start  = 6,
                    finish = 7,
                },
            },
            [2]    = {
                type   = "unary",
                start  = 8,
                finish = 11,
                parent = "<IGNORE>",
                op     = {
                    type   = "not",
                    start  = 8,
                    finish = 11,
                },
            },
            [3]    = {
                type   = "integer",
                start  = 12,
                finish = 13,
                parent = "<IGNORE>",
                [1]    = 1,
            },
        },
    },
}

CHECK [[
{
    ;,-;,1
}
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 30000,
    locals  = "<IGNORE>",
    bfinish = 30000,
    [1]     = {
        type    = "table",
        start   = 0,
        bstart  = 1,
        finish  = 20001,
        parent  = "<IGNORE>",
        bfinish = 20000,
        [1]     = {
            type   = "tableexp",
            start  = 10006,
            finish = 10007,
            tindex = 1,
            parent = "<IGNORE>",
            value  = {
                type   = "unary",
                start  = 10006,
                finish = 10007,
                parent = "<IGNORE>",
                op     = {
                    type   = "-",
                    start  = 10006,
                    finish = 10007,
                },
            },
        },
        [2]     = {
            type   = "tableexp",
            start  = 10009,
            finish = 10010,
            tindex = 2,
            parent = "<IGNORE>",
            value  = {
                type   = "integer",
                start  = 10009,
                finish = 10010,
                parent = "<IGNORE>",
                [1]    = 1,
            },
        },
    },
}

CHECK [[
local a,b,,d
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 10000,
    locals  = "<IGNORE>",
    bfinish = 10000,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 12,
        parent = "<IGNORE>",
        locPos = 0,
        [1]    = "a",
    },
    [2]     = {
        type   = "local",
        start  = 8,
        finish = 9,
        effect = 12,
        parent = "<IGNORE>",
        [1]    = "b",
    },
    [3]     = {
        type   = "local",
        start  = 11,
        finish = 12,
        effect = 12,
        parent = "<IGNORE>",
        [1]    = "d",
    },
}

CHECK [[
if /**/ then
end
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20000,
    locals  = "<IGNORE>",
    bfinish = 20000,
    [1]     = {
        type   = "if",
        start  = 0,
        finish = 10003,
        parent = "<IGNORE>",
        [1]    = {
            type    = "ifblock",
            start   = 0,
            bstart  = 12,
            finish  = 10000,
            keyword = {
                [1] = 0,
                [2] = 2,
                [3] = 8,
                [4] = 12,
            },
            parent  = "<IGNORE>",
            bfinish = 10000,
        },
    },
}

CHECK [[
f(break)
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 10000,
    locals  = "<IGNORE>",
    bfinish = 10000,
    [1]     = {
        type   = "call",
        start  = 0,
        finish = 8,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        args   = {
            type   = "callargs",
            start  = 1,
            finish = 8,
            parent = "<IGNORE>",
            [1]    = {
                type   = "getglobal",
                start  = 2,
                finish = 7,
                parent = "<IGNORE>",
                node   = "<IGNORE>",
                [1]    = "break",
            },
        },
    },
}

CHECK [[
print(x == )
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 10000,
    locals  = "<IGNORE>",
    bfinish = 10000,
    [1]     = {
        type   = "call",
        start  = 0,
        finish = 12,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        args   = {
            type   = "callargs",
            start  = 5,
            finish = 12,
            parent = "<IGNORE>",
            [1]    = {
                type   = "binary",
                start  = 6,
                finish = 10,
                parent = "<IGNORE>",
                op     = {
                    type   = "==",
                    start  = 8,
                    finish = 10,
                },
                [1]    = {
                    type   = "getglobal",
                    start  = 6,
                    finish = 7,
                    parent = "<IGNORE>",
                    node   = "<IGNORE>",
                    [1]    = "x",
                },
            },
        },
    },
}
CHECK [[
local t = {
    a = 1,
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20000,
    locals  = "<IGNORE>",
    bfinish = 20000,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 10010,
        range  = 10010,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type    = "table",
            start   = 10,
            bstart  = 11,
            finish  = 10010,
            parent  = "<IGNORE>",
            bfinish = 20000,
            [1]     = {
                type   = "tablefield",
                start  = 10004,
                finish = 10005,
                range  = 10009,
                parent = "<IGNORE>",
                node   = "<IGNORE>",
                field  = {
                    type   = "field",
                    start  = 10004,
                    finish = 10005,
                    parent = "<IGNORE>",
                    [1]    = "a",
                },
                value  = {
                    type   = "integer",
                    start  = 10008,
                    finish = 10009,
                    parent = "<IGNORE>",
                    [1]    = 1,
                },
            },
        },
        [1]    = "t",
    },
}

CHECK [[
local t = function f() end
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 10000,
    locals  = "<IGNORE>",
    bfinish = 10000,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 26,
        range  = 26,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type    = "function",
            start   = 10,
            bstart  = 22,
            finish  = 26,
            keyword = {
                [1] = 10,
                [2] = 18,
                [3] = 23,
                [4] = 26,
            },
            parent  = "<IGNORE>",
            args    = {
                type   = "funcargs",
                start  = 20,
                finish = 22,
                parent = "<IGNORE>",
            },
            bfinish = 23,
            name    = {
                type   = "getglobal",
                start  = 19,
                finish = 20,
                parent = "<IGNORE>",
                node   = "<IGNORE>",
                [1]    = "f",
            },
        },
        [1]    = "t",
    },
}

CHECK [[
function F()
    in
end
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 30000,
    locals  = "<IGNORE>",
    bfinish = 30000,
    [1]     = {
        type   = "setglobal",
        start  = 9,
        vstart = 0,
        finish = 10,
        range  = 20003,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type    = "function",
            start   = 0,
            bstart  = 12,
            finish  = 20003,
            keyword = {
                [1] = 0,
                [2] = 8,
                [3] = 20000,
                [4] = 20003,
            },
            parent  = "<IGNORE>",
            args    = {
                type   = "funcargs",
                start  = 10,
                finish = 12,
                parent = "<IGNORE>",
            },
            bfinish = 20000,
        },
        [1]    = "F",
    },
}

CHECK [[
if true then
    1
end
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 30000,
    locals  = "<IGNORE>",
    bfinish = 30000,
    [1]     = {
        type   = "if",
        start  = 0,
        finish = 20003,
        parent = "<IGNORE>",
        [1]    = {
            type    = "ifblock",
            start   = 0,
            bstart  = 12,
            finish  = 20000,
            keyword = {
                [1] = 0,
                [2] = 2,
                [3] = 8,
                [4] = 12,
            },
            parent  = "<IGNORE>",
            filter  = {
                type   = "boolean",
                start  = 3,
                finish = 7,
                parent = "<IGNORE>",
                [1]    = true,
            },
            bfinish = 20000,
            [1]     = {
                type   = "integer",
                start  = 10004,
                finish = 10005,
                parent = "<IGNORE>",
                [1]    = 1,
            },
        },
    },
}
CHECK [[
local
local x = 1
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20000,
    locals  = "<IGNORE>",
    bfinish = 20000,
    [1]     = {
        type   = "local",
        start  = 10006,
        finish = 10007,
        effect = 10011,
        range  = 10011,
        parent = "<IGNORE>",
        locPos = 10000,
        value  = {
            type   = "integer",
            start  = 10010,
            finish = 10011,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [1]    = "x",
    },
}
CHECK [[
return function ()
    local function fff(xxx)
        for f in xx
    end
end
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 50000,
    locals  = "<IGNORE>",
    returns = "<IGNORE>",
    bfinish = 50000,
    [1]     = {
        type   = "return",
        start  = 0,
        finish = 40003,
        parent = "<IGNORE>",
        [1]    = {
            type    = "function",
            start   = 7,
            bstart  = 18,
            finish  = 40003,
            keyword = {
                [1] = 7,
                [2] = 15,
            },
            parent  = "<IGNORE>",
            args    = {
                type   = "funcargs",
                start  = 16,
                finish = 18,
                parent = "<IGNORE>",
            },
            locals  = "<IGNORE>",
            bfinish = 50000,
            [1]     = {
                type   = "local",
                start  = 10019,
                vstart = 10010,
                finish = 10022,
                effect = 10022,
                range  = 40003,
                parent = "<IGNORE>",
                locPos = 10004,
                value  = {
                    type    = "function",
                    start   = 10010,
                    bstart  = 10027,
                    finish  = 40003,
                    keyword = {
                        [1] = 10010,
                        [2] = 10018,
                        [3] = 40000,
                        [4] = 40003,
                    },
                    parent  = "<IGNORE>",
                    args    = {
                        type   = "funcargs",
                        start  = 10022,
                        finish = 10027,
                        parent = "<IGNORE>",
                        [1]    = {
                            type   = "local",
                            start  = 10023,
                            finish = 10026,
                            effect = 10026,
                            parent = "<IGNORE>",
                            [1]    = "xxx",
                        },
                    },
                    locals  = "<IGNORE>",
                    bfinish = 40000,
                    [1]     = {
                        type    = "in",
                        start   = 20008,
                        bstart  = 20019,
                        finish  = 30007,
                        keyword = {
                            [1] = 20008,
                            [2] = 20011,
                            [3] = 20014,
                            [4] = 20016,
                            [5] = 30004,
                            [6] = 30007,
                        },
                        parent  = "<IGNORE>",
                        keys    = {
                            type   = "list",
                            start  = 20012,
                            finish = 20013,
                            range  = 20016,
                            parent = "<IGNORE>",
                            [1]    = {
                                type   = "local",
                                start  = 20012,
                                finish = 20013,
                                effect = 20019,
                                parent = "<IGNORE>",
                                [1]    = "f",
                            },
                        },
                        exps    = {
                            type   = "list",
                            start  = 20017,
                            finish = 20019,
                            parent = "<IGNORE>",
                            [1]    = {
                                type   = "getglobal",
                                start  = 20017,
                                finish = 20019,
                                parent = "<IGNORE>",
                                node   = "<IGNORE>",
                                [1]    = "xx",
                            },
                        },
                        locals  = "<IGNORE>",
                        bfinish = 30004,
                    },
                },
                [1]    = "fff",
            },
        },
    },
}
