CHECK'nil'
{
    type   = "nil",
    start  = 0,
    finish = 3,
}
CHECK'a'
{
    type   = "getglobal",
    start  = 0,
    finish = 1,
    [1]    = "a",
}
CHECK'a.b'
{
    type   = "getfield",
    start  = 0,
    finish = 3,
    node   = "<IGNORE>",
    dot    = {
        type   = ".",
        start  = 1,
        finish = 2,
    },
    field  = {
        type   = "field",
        start  = 2,
        finish = 3,
        parent = "<IGNORE>",
        [1]    = "b",
    },
}
CHECK'a.b.c'
{
    type   = "getfield",
    start  = 0,
    finish = 5,
    node   = "<IGNORE>",
    dot    = {
        type   = ".",
        start  = 3,
        finish = 4,
    },
    field  = {
        type   = "field",
        start  = 4,
        finish = 5,
        parent = "<IGNORE>",
        [1]    = "c",
    },
}
CHECK'func()'
{
    type   = "call",
    start  = 0,
    finish = 6,
    node   = "<IGNORE>",
}
CHECK'a.b.c()'
{
    type   = "call",
    start  = 0,
    finish = 7,
    node   = "<IGNORE>",
}
CHECK'1 or 2'
{
    type   = "binary",
    start  = 0,
    finish = 6,
    op     = {
        type   = "or",
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
}
CHECK'1 < 2'
{
    type   = "binary",
    start  = 0,
    finish = 5,
    op     = {
        type   = "<",
        start  = 2,
        finish = 3,
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
        start  = 4,
        finish = 5,
        parent = "<IGNORE>",
        [1]    = 2,
    },
}
CHECK'- 1'
{
    type   = "integer",
    start  = 0,
    finish = 3,
    [1]    = -1,
}
CHECK'not not true'
{
    type   = "unary",
    start  = 0,
    finish = 12,
    op     = {
        type   = "not",
        start  = 0,
        finish = 3,
    },
    [1]    = {
        type   = "unary",
        start  = 4,
        finish = 12,
        parent = "<IGNORE>",
        op     = {
            type   = "not",
            start  = 4,
            finish = 7,
        },
        [1]    = {
            type   = "boolean",
            start  = 8,
            finish = 12,
            parent = "<IGNORE>",
            [1]    = true,
        },
    },
}
CHECK'1 ^ 2'
{
    type   = "binary",
    start  = 0,
    finish = 5,
    op     = {
        type   = "^",
        start  = 2,
        finish = 3,
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
        start  = 4,
        finish = 5,
        parent = "<IGNORE>",
        [1]    = 2,
    },
}
CHECK'1 ^ -2'
{
    type   = "binary",
    start  = 0,
    finish = 6,
    op     = {
        type   = "^",
        start  = 2,
        finish = 3,
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
        start  = 4,
        finish = 6,
        parent = "<IGNORE>",
        [1]    = -2,
    },
}
CHECK'-1 ^ 2'
{
    type   = "unary",
    start  = 0,
    finish = 6,
    op     = {
        type   = "-",
        start  = 0,
        finish = 1,
    },
    [1]    = {
        type   = "binary",
        start  = 1,
        finish = 6,
        parent = "<IGNORE>",
        op     = {
            type   = "^",
            start  = 3,
            finish = 4,
        },
        [1]    = {
            type   = 'integer',
            start  = 1,
            finish = 2,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [2]    = {
            type   = 'integer',
            start  = 5,
            finish = 6,
            parent = "<IGNORE>",
            [1]    = 2,
        },
    },
}
CHECK'...'
{
    type   = "varargs",
    start  = 0,
    finish = 3,
}
CHECK'1 + 2 + 3'
{
    type   = "binary",
    start  = 0,
    finish = 9,
    op     = {
        type   = "+",
        start  = 6,
        finish = 7,
    },
    [1]    = {
        type   = "binary",
        start  = 0,
        finish = 5,
        parent = "<IGNORE>",
        op     = {
            type   = "+",
            start  = 2,
            finish = 3,
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
            start  = 4,
            finish = 5,
            parent = "<IGNORE>",
            [1]    = 2,
        },
    },
    [2]    = {
        type   = "integer",
        start  = 8,
        finish = 9,
        parent = "<IGNORE>",
        [1]    = 3,
    },
}
CHECK'1 + 2 * 3'
{
    type   = "binary",
    start  = 0,
    finish = 9,
    op     = {
        type   = "+",
        start  = 2,
        finish = 3,
    },
    [1]    = {
        type   = "integer",
        start  = 0,
        finish = 1,
        parent = "<IGNORE>",
        [1]    = 1,
    },
    [2]    = {
        type   = "binary",
        start  = 4,
        finish = 9,
        parent = "<IGNORE>",
        op     = {
            type   = "*",
            start  = 6,
            finish = 7,
        },
        [1]    = {
            type   = "integer",
            start  = 4,
            finish = 5,
            parent = "<IGNORE>",
            [1]    = 2,
        },
        [2]    = {
            type   = "integer",
            start  = 8,
            finish = 9,
            parent = "<IGNORE>",
            [1]    = 3,
        },
    },
}
CHECK'- 1 + 2 * 3'
{
    type   = "binary",
    start  = 0,
    finish = 11,
    op     = {
        type   = "+",
        start  = 4,
        finish = 5,
    },
    [1]    = {
        type   = "integer",
        start  = 0,
        finish = 3,
        parent = "<IGNORE>",
        [1]    = -1,
    },
    [2]    = {
        type   = "binary",
        start  = 6,
        finish = 11,
        parent = "<IGNORE>",
        op     = {
            type   = "*",
            start  = 8,
            finish = 9,
        },
        [1]    = {
            type   = "integer",
            start  = 6,
            finish = 7,
            parent = "<IGNORE>",
            [1]    = 2,
        },
        [2]    = {
            type   = "integer",
            start  = 10,
            finish = 11,
            parent = "<IGNORE>",
            [1]    = 3,
        },
    },
}
CHECK'-1 + 2 * 3'
{
    type   = "binary",
    start  = 0,
    finish = 10,
    op     = {
        type   = "+",
        start  = 3,
        finish = 4,
    },
    [1]    = {
        type   = "integer",
        start  = 0,
        finish = 2,
        parent = "<IGNORE>",
        [1]    = -1,
    },
    [2]    = {
        type   = "binary",
        start  = 5,
        finish = 10,
        parent = "<IGNORE>",
        op     = {
            type   = "*",
            start  = 7,
            finish = 8,
        },
        [1]    = {
            type   = "integer",
            start  = 5,
            finish = 6,
            parent = "<IGNORE>",
            [1]    = 2,
        },
        [2]    = {
            type   = "integer",
            start  = 9,
            finish = 10,
            parent = "<IGNORE>",
            [1]    = 3,
        },
    },
}
CHECK"x and y == 'unary' and z"
{
    type   = "binary",
    start  = 0,
    finish = 24,
    op     = {
        type   = "and",
        start  = 19,
        finish = 22,
    },
    [1]    = {
        type   = "binary",
        start  = 0,
        finish = 18,
        parent = "<IGNORE>",
        op     = {
            type   = "and",
            start  = 2,
            finish = 5,
        },
        [1]    = {
            type   = "getglobal",
            start  = 0,
            finish = 1,
            parent = "<IGNORE>",
            [1]    = "x",
        },
        [2]    = {
            type   = "binary",
            start  = 6,
            finish = 18,
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
                [1]    = "y",
            },
            [2]    = {
                type   = "string",
                start  = 11,
                finish = 18,
                parent = "<IGNORE>",
                [1]    = "unary",
                [2]    = "'",
            },
        },
    },
    [2]    = {
        type   = "getglobal",
        start  = 23,
        finish = 24,
        parent = "<IGNORE>",
        [1]    = "z",
    },
}
CHECK"x and y or '' .. z"
{
    type   = "binary",
    start  = 0,
    finish = 18,
    op     = {
        type   = "or",
        start  = 8,
        finish = 10,
    },
    [1]    = {
        type   = "binary",
        start  = 0,
        finish = 7,
        parent = "<IGNORE>",
        op     = {
            type   = "and",
            start  = 2,
            finish = 5,
        },
        [1]    = {
            type   = "getglobal",
            start  = 0,
            finish = 1,
            parent = "<IGNORE>",
            [1]    = "x",
        },
        [2]    = {
            type   = "getglobal",
            start  = 6,
            finish = 7,
            parent = "<IGNORE>",
            [1]    = "y",
        },
    },
    [2]    = {
        type   = "binary",
        start  = 11,
        finish = 18,
        parent = "<IGNORE>",
        op     = {
            type   = "..",
            start  = 14,
            finish = 16,
        },
        [1]    = {
            type   = "string",
            start  = 11,
            finish = 13,
            parent = "<IGNORE>",
            [1]    = "",
            [2]    = "'",
        },
        [2]    = {
            type   = "getglobal",
            start  = 17,
            finish = 18,
            parent = "<IGNORE>",
            [1]    = "z",
        },
    },
}
-- 幂运算从右向左连接
CHECK'1 ^ 2 ^ 3'
{
    type   = "binary",
    start  = 0,
    finish = 9,
    op     = {
        type   = "^",
        start  = 2,
        finish = 3,
    },
    [1]    = {
        type   = "integer",
        start  = 0,
        finish = 1,
        parent = "<IGNORE>",
        [1]    = 1,
    },
    [2]    = {
        type   = "binary",
        start  = 4,
        finish = 9,
        parent = "<IGNORE>",
        op     = {
            type   = "^",
            start  = 6,
            finish = 7,
        },
        [1]    = {
            type   = "integer",
            start  = 4,
            finish = 5,
            parent = "<IGNORE>",
            [1]    = 2,
        },
        [2]    = {
            type   = "integer",
            start  = 8,
            finish = 9,
            parent = "<IGNORE>",
            [1]    = 3,
        },
    },
}
-- 连接运算从右向左连接
CHECK'1 .. 2 .. 3'
{
    type   = "binary",
    start  = 0,
    finish = 11,
    op     = {
        type   = "..",
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
        type   = "binary",
        start  = 5,
        finish = 11,
        parent = "<IGNORE>",
        op     = {
            type   = "..",
            start  = 7,
            finish = 9,
        },
        [1]    = {
            type   = "integer",
            start  = 5,
            finish = 6,
            parent = "<IGNORE>",
            [1]    = 2,
        },
        [2]    = {
            type   = "integer",
            start  = 10,
            finish = 11,
            parent = "<IGNORE>",
            [1]    = 3,
        },
    },
}
CHECK'1 + - - - - - - - 1'
{
    type   = "binary",
    start  = 0,
    finish = 19,
    op     = {
        type   = "+",
        start  = 2,
        finish = 3,
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
        start  = 4,
        finish = 19,
        parent = "<IGNORE>",
        [1]    = -1,
    },
}
CHECK'(1)'
{
    type   = "paren",
    start  = 0,
    finish = 3,
    exp    = {
        type   = "integer",
        start  = 1,
        finish = 2,
        parent = "<IGNORE>",
        [1]    = 1,
    },
}
CHECK'(1 + 2)'
{
    type   = "paren",
    start  = 0,
    finish = 7,
    exp    = {
        type   = "binary",
        start  = 1,
        finish = 6,
        parent = "<IGNORE>",
        op     = {
            type   = "+",
            start  = 3,
            finish = 4,
        },
        [1]    = {
            type   = "integer",
            start  = 1,
            finish = 2,
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
CHECK'func(1)'
{
    type   = "call",
    start  = 0,
    finish = 7,
    node   = "<IGNORE>",
    args   = {
        type   = "callargs",
        start  = 4,
        finish = 7,
        parent = "<IGNORE>",
        [1]    = {
            type   = "integer",
            start  = 5,
            finish = 6,
            parent = "<IGNORE>",
            [1]    = 1,
        },
    },
}
CHECK'func(1, 2)'
{
    type   = "call",
    start  = 0,
    finish = 10,
    node   = "<IGNORE>",
    args   = {
        type   = "callargs",
        start  = 4,
        finish = 10,
        parent = "<IGNORE>",
        [1]    = {
            type   = "integer",
            start  = 5,
            finish = 6,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [2]    = {
            type   = "integer",
            start  = 8,
            finish = 9,
            parent = "<IGNORE>",
            [1]    = 2,
        },
    },
}
CHECK'func(...)'
{
    type   = "call",
    start  = 0,
    finish = 9,
    node   = "<IGNORE>",
    args   = {
        type   = "callargs",
        start  = 4,
        finish = 9,
        parent = "<IGNORE>",
        [1]    = {
            type   = "varargs",
            start  = 5,
            finish = 8,
            parent = "<IGNORE>",
        },
    },
}
CHECK'func(1, ...)'
{
    type   = "call",
    start  = 0,
    finish = 12,
    node   = "<IGNORE>",
    args   = {
        type   = "callargs",
        start  = 4,
        finish = 12,
        parent = "<IGNORE>",
        [1]    = {
            type   = "integer",
            start  = 5,
            finish = 6,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [2]    = {
            type   = "varargs",
            start  = 8,
            finish = 11,
            parent = "<IGNORE>",
        },
    },
}
CHECK'func ""'
{
    type   = "call",
    start  = 0,
    finish = 7,
    node   = "<IGNORE>",
    args   = {
        type   = "callargs",
        start  = 5,
        finish = 7,
        parent = "<IGNORE>",
        [1]    = {
            type   = "string",
            start  = 5,
            finish = 7,
            parent = "<IGNORE>",
            [1]    = "",
            [2]    = "\"",
        },
    },
}
CHECK'func {}'
{
    type   = "call",
    start  = 0,
    finish = 7,
    node   = "<IGNORE>",
    args   = {
        type   = "callargs",
        start  = 5,
        finish = 7,
        parent = "<IGNORE>",
        [1]    = {
            type    = "table",
            start   = 5,
            bstart  = 6,
            finish  = 7,
            parent  = "<IGNORE>",
            bfinish = 6,
        },
    },
}
CHECK'table[1]'
{
    type   = "getindex",
    start  = 0,
    finish = 8,
    node   = "<IGNORE>",
    index  = {
        type   = "integer",
        start  = 6,
        finish = 7,
        parent = "<IGNORE>",
        [1]    = 1,
    },
}
CHECK'table[[1]]'
{
    type   = "call",
    start  = 0,
    finish = 10,
    node   = "<IGNORE>",
    args   = {
        type   = "callargs",
        start  = 5,
        finish = 10,
        parent = "<IGNORE>",
        [1]    = {
            type   = "string",
            start  = 5,
            finish = 10,
            parent = "<IGNORE>",
            [1]    = '1',
            [2]    = '[['
        },
    },
}
CHECK'get_point().x'
{
    type   = "getfield",
    start  = 0,
    finish = 13,
    node   = "<IGNORE>",
    dot    = {
        type   = ".",
        start  = 11,
        finish = 12,
    },
    field  = {
        type   = "field",
        start  = 12,
        finish = 13,
        parent = "<IGNORE>",
        [1]    = "x",
    },
}
CHECK'obj:remove()'
{
    type   = "call",
    start  = 0,
    finish = 12,
    node   = "<IGNORE>",
    args   = {
        type   = "callargs",
        start  = 0,
        finish = 12,
        parent = "<IGNORE>",
        [1]    = {
            type   = "self",
            start  = 3,
            finish = 4,
            parent = "<IGNORE>",
            [1]    = "self",
        },
    },
}
CHECK'(...)[1]'
{
    type   = "getindex",
    start  = 0,
    finish = 8,
    node   = "<IGNORE>",
    index  = {
        type   = "integer",
        start  = 6,
        finish = 7,
        parent = "<IGNORE>",
        [1]    = 1,
    },
}
CHECK'function () end'
{
    type    = "function",
    start   = 0,
    bstart  = 11,
    finish  = 15,
    keyword = {
        [1] = 0,
        [2] = 8,
        [3] = 12,
        [4] = 15,
    },
    args    = {
        type   = "funcargs",
        start  = 9,
        finish = 11,
        parent = "<IGNORE>",
    },
    bfinish = 12,
}
CHECK'function (...) end'
{
    type    = "function",
    start   = 0,
    bstart  = 14,
    finish  = 18,
    keyword = {
        [1] = 0,
        [2] = 8,
        [3] = 15,
        [4] = 18,
    },
    vararg  = "<IGNORE>",
    args    = {
        type   = "funcargs",
        start  = 9,
        finish = 14,
        parent = "<IGNORE>",
        [1]    = {
            type   = "...",
            start  = 10,
            finish = 13,
            parent = "<IGNORE>",
            [1]    = "...",
        },
    },
    bfinish = 15,
}
CHECK'function (a, ...) end'
{
    type    = "function",
    start   = 0,
    bstart  = 17,
    finish  = 21,
    keyword = {
        [1] = 0,
        [2] = 8,
        [3] = 18,
        [4] = 21,
    },
    vararg  = "<IGNORE>",
    args    = {
        type   = "funcargs",
        start  = 9,
        finish = 17,
        parent = "<IGNORE>",
        [1]    = {
            type   = "local",
            start  = 10,
            finish = 11,
            effect = 11,
            parent = "<IGNORE>",
            [1]    = "a",
        },
        [2]    = {
            type   = "...",
            start  = 13,
            finish = 16,
            parent = "<IGNORE>",
            [1]    = "...",
        },
    },
    locals  = "<IGNORE>",
    bfinish = 18,
}
CHECK'{}'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 2,
    bfinish = 1,
}
CHECK'{...}'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 5,
    bfinish = 4,
    [1]     = {
        type   = "varargs",
        start  = 1,
        finish = 4,
        parent = "<IGNORE>",
    },
}
CHECK'{1, 2, 3}'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 9,
    bfinish = 8,
    [1]     = {
        type   = "tableexp",
        start  = 1,
        finish = 2,
        tindex = 1,
        parent = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 1,
            finish = 2,
            parent = "<IGNORE>",
            [1]    = 1,
        },
    },
    [2]     = {
        type   = "tableexp",
        start  = 4,
        finish = 5,
        tindex = 2,
        parent = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 4,
            finish = 5,
            parent = "<IGNORE>",
            [1]    = 2,
        },
    },
    [3]     = {
        type   = "tableexp",
        start  = 7,
        finish = 8,
        tindex = 3,
        parent = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 7,
            finish = 8,
            parent = "<IGNORE>",
            [1]    = 3,
        },
    },
}
CHECK'{x = 1, y = 2}'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 14,
    bfinish = 13,
    [1]     = {
        type   = "tablefield",
        start  = 1,
        finish = 2,
        range  = 6,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        field  = {
            type   = "field",
            start  = 1,
            finish = 2,
            parent = "<IGNORE>",
            [1]    = "x",
        },
        value  = {
            type   = "integer",
            start  = 5,
            finish = 6,
            parent = "<IGNORE>",
            [1]    = 1,
        },
    },
    [2]     = {
        type   = "tablefield",
        start  = 8,
        finish = 9,
        range  = 13,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        field  = {
            type   = "field",
            start  = 8,
            finish = 9,
            parent = "<IGNORE>",
            [1]    = "y",
        },
        value  = {
            type   = "integer",
            start  = 12,
            finish = 13,
            parent = "<IGNORE>",
            [1]    = 2,
        },
    },
}
CHECK'{["x"] = 1, ["y"] = 2}'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 22,
    bfinish = 21,
    [1]     = {
        type   = "tableindex",
        start  = 1,
        finish = 6,
        range  = 10,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        index  = {
            type   = "string",
            start  = 2,
            finish = 5,
            parent = "<IGNORE>",
            [1]    = "x",
            [2]    = "\"",
        },
        value  = {
            type   = "integer",
            start  = 9,
            finish = 10,
            parent = "<IGNORE>",
            [1]    = 1,
        },
    },
    [2]     = {
        type   = "tableindex",
        start  = 12,
        finish = 17,
        range  = 21,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        index  = {
            type   = "string",
            start  = 13,
            finish = 16,
            parent = "<IGNORE>",
            [1]    = "y",
            [2]    = "\"",
        },
        value  = {
            type   = "integer",
            start  = 20,
            finish = 21,
            parent = "<IGNORE>",
            [1]    = 2,
        },
    },
}
CHECK'{[x] = 1, [y] = 2}'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 18,
    bfinish = 17,
    [1]     = {
        type   = "tableindex",
        start  = 1,
        finish = 4,
        range  = 8,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        index  = {
            type   = "getglobal",
            start  = 2,
            finish = 3,
            parent = "<IGNORE>",
            [1]    = "x",
        },
        value  = {
            type   = "integer",
            start  = 7,
            finish = 8,
            parent = "<IGNORE>",
            [1]    = 1,
        },
    },
    [2]     = {
        type   = "tableindex",
        start  = 10,
        finish = 13,
        range  = 17,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        index  = {
            type   = "getglobal",
            start  = 11,
            finish = 12,
            parent = "<IGNORE>",
            [1]    = "y",
        },
        value  = {
            type   = "integer",
            start  = 16,
            finish = 17,
            parent = "<IGNORE>",
            [1]    = 2,
        },
    },
}
CHECK'{x = 1, y = 2, 3}'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 17,
    bfinish = 16,
    [1]     = {
        type   = "tablefield",
        start  = 1,
        finish = 2,
        range  = 6,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        field  = {
            type   = "field",
            start  = 1,
            finish = 2,
            parent = "<IGNORE>",
            [1]    = "x",
        },
        value  = {
            type   = "integer",
            start  = 5,
            finish = 6,
            parent = "<IGNORE>",
            [1]    = 1,
        },
    },
    [2]     = {
        type   = "tablefield",
        start  = 8,
        finish = 9,
        range  = 13,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        field  = {
            type   = "field",
            start  = 8,
            finish = 9,
            parent = "<IGNORE>",
            [1]    = "y",
        },
        value  = {
            type   = "integer",
            start  = 12,
            finish = 13,
            parent = "<IGNORE>",
            [1]    = 2,
        },
    },
    [3]     = {
        type   = "tableexp",
        start  = 15,
        finish = 16,
        tindex = 1,
        parent = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 15,
            finish = 16,
            parent = "<IGNORE>",
            [1]    = 3,
        },
    },
}
CHECK'{{}}'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 4,
    bfinish = 3,
    [1]     = {
        type   = "tableexp",
        start  = 1,
        finish = 3,
        tindex = 1,
        parent = "<IGNORE>",
        value  = {
            type    = "table",
            start   = 1,
            bstart  = 2,
            finish  = 3,
            parent  = "<IGNORE>",
            bfinish = 2,
        },
    },
}
CHECK'{ a = { b = { c = {} } } }'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 26,
    bfinish = 25,
    [1]     = {
        type   = "tablefield",
        start  = 2,
        finish = 3,
        range  = 24,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        field  = {
            type   = "field",
            start  = 2,
            finish = 3,
            parent = "<IGNORE>",
            [1]    = "a",
        },
        value  = {
            type    = "table",
            start   = 6,
            bstart  = 7,
            finish  = 24,
            parent  = "<IGNORE>",
            bfinish = 23,
            [1]     = {
                type   = "tablefield",
                start  = 8,
                finish = 9,
                range  = 22,
                parent = "<IGNORE>",
                node   = "<IGNORE>",
                field  = {
                    type   = "field",
                    start  = 8,
                    finish = 9,
                    parent = "<IGNORE>",
                    [1]    = "b",
                },
                value  = {
                    type    = "table",
                    start   = 12,
                    bstart  = 13,
                    finish  = 22,
                    parent  = "<IGNORE>",
                    bfinish = 21,
                    [1]     = {
                        type   = "tablefield",
                        start  = 14,
                        finish = 15,
                        range  = 20,
                        parent = "<IGNORE>",
                        node   = "<IGNORE>",
                        field  = {
                            type   = "field",
                            start  = 14,
                            finish = 15,
                            parent = "<IGNORE>",
                            [1]    = "c",
                        },
                        value  = {
                            type    = "table",
                            start   = 18,
                            bstart  = 19,
                            finish  = 20,
                            parent  = "<IGNORE>",
                            bfinish = 19,
                        },
                    },
                },
            },
        },
    },
}
CHECK'{{}, {}, {{}, {}}}'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 18,
    bfinish = 17,
    [1]     = {
        type   = "tableexp",
        start  = 1,
        finish = 3,
        tindex = 1,
        parent = "<IGNORE>",
        value  = {
            type    = "table",
            start   = 1,
            bstart  = 2,
            finish  = 3,
            parent  = "<IGNORE>",
            bfinish = 2,
        },
    },
    [2]     = {
        type   = "tableexp",
        start  = 5,
        finish = 7,
        tindex = 2,
        parent = "<IGNORE>",
        value  = {
            type    = "table",
            start   = 5,
            bstart  = 6,
            finish  = 7,
            parent  = "<IGNORE>",
            bfinish = 6,
        },
    },
    [3]     = {
        type   = "tableexp",
        start  = 9,
        finish = 17,
        tindex = 3,
        parent = "<IGNORE>",
        value  = {
            type    = "table",
            start   = 9,
            bstart  = 10,
            finish  = 17,
            parent  = "<IGNORE>",
            bfinish = 16,
            [1]     = {
                type   = "tableexp",
                start  = 10,
                finish = 12,
                tindex = 1,
                parent = "<IGNORE>",
                value  = {
                    type    = "table",
                    start   = 10,
                    bstart  = 11,
                    finish  = 12,
                    parent  = "<IGNORE>",
                    bfinish = 11,
                },
            },
            [2]     = {
                type   = "tableexp",
                start  = 14,
                finish = 16,
                tindex = 2,
                parent = "<IGNORE>",
                value  = {
                    type    = "table",
                    start   = 14,
                    bstart  = 15,
                    finish  = 16,
                    parent  = "<IGNORE>",
                    bfinish = 15,
                },
            },
        },
    },
}
CHECK'{1, 2, 3,}'
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 10,
    bfinish = 9,
    [1]     = {
        type   = "tableexp",
        start  = 1,
        finish = 2,
        tindex = 1,
        parent = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 1,
            finish = 2,
            parent = "<IGNORE>",
            [1]    = 1,
        },
    },
    [2]     = {
        type   = "tableexp",
        start  = 4,
        finish = 5,
        tindex = 2,
        parent = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 4,
            finish = 5,
            parent = "<IGNORE>",
            [1]    = 2,
        },
    },
    [3]     = {
        type   = "tableexp",
        start  = 7,
        finish = 8,
        tindex = 3,
        parent = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 7,
            finish = 8,
            parent = "<IGNORE>",
            [1]    = 3,
        },
    },
}

CHECK 'notify'
{
    type   = "getglobal",
    start  = 0,
    finish = 6,
    [1]    = "notify",
}

CHECK 'a ^ - b'
{
    type   = "binary",
    start  = 0,
    finish = 7,
    op     = {
        type   = "^",
        start  = 2,
        finish = 3,
    },
    [1]    = {
        type   = "getglobal",
        start  = 0,
        finish = 1,
        parent = "<IGNORE>",
        [1]    = "a",
    },
    [2]    = {
        type   = "unary",
        start  = 4,
        finish = 7,
        parent = "<IGNORE>",
        op     = {
            type   = "-",
            start  = 4,
            finish = 5,
        },
        [1]    = {
            type   = "getglobal",
            start  = 6,
            finish = 7,
            parent = "<IGNORE>",
            [1]    = "b",
        },
    },
}

CHECK [=[
{
[[]]
}]=]
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 20001,
    bfinish = 20000,
    [1]     = {
        type   = "tableexp",
        start  = 10000,
        finish = 10004,
        tindex = 1,
        parent = "<IGNORE>",
        value  = {
            type   = "string",
            start  = 10000,
            finish = 10004,
            parent = "<IGNORE>",
            [1]    = "",
            [2]    = "[[",
        },
    },
}

CHECK [[
{
    [xxx]
}
]]
{
    type    = "table",
    start   = 0,
    bstart  = 1,
    finish  = 20001,
    bfinish = 20000,
    [1]     = {
        type   = "tableindex",
        start  = 10004,
        finish = 10009,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        index  = {
            type   = "getglobal",
            start  = 10005,
            finish = 10008,
            parent = "<IGNORE>",
            [1]    = "xxx",
        },
    },
}
