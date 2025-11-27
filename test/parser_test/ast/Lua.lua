CHECK''
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 0,
    locals  = "<IGNORE>",
    bfinish = 0,
}

CHECK';;;'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 3,
    locals  = "<IGNORE>",
    bfinish = 3,
}

CHECK';;;x = 1'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 8,
    locals  = "<IGNORE>",
    bfinish = 8,
    [1]     = {
        type   = "setglobal",
        start  = 3,
        finish = 4,
        range  = 8,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 7,
            finish = 8,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [1]    = "x",
    },
}
CHECK'x, y, z = 1, 2, 3'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 17,
    locals  = "<IGNORE>",
    bfinish = 17,
    [1]     = {
        type   = "setglobal",
        start  = 0,
        finish = 1,
        range  = 11,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 10,
            finish = 11,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "setglobal",
        start  = 3,
        finish = 4,
        range  = 14,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 13,
            finish = 14,
            parent = "<IGNORE>",
            [1]    = 2,
        },
        [1]    = "y",
    },
    [3]     = {
        type   = "setglobal",
        start  = 6,
        finish = 7,
        range  = 17,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 16,
            finish = 17,
            parent = "<IGNORE>",
            [1]    = 3,
        },
        [1]    = "z",
    },
}
CHECK'local x, y, z'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 13,
    locals  = "<IGNORE>",
    bfinish = 13,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 13,
        parent = "<IGNORE>",
        locPos = 0,
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 13,
        parent = "<IGNORE>",
        [1]    = "y",
    },
    [3]     = {
        type   = "local",
        start  = 12,
        finish = 13,
        effect = 13,
        parent = "<IGNORE>",
        [1]    = "z",
    },
}
CHECK'local x, y, z = 1, 2, 3'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 23,
    locals  = "<IGNORE>",
    bfinish = 23,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 23,
        range  = 17,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "integer",
            start  = 16,
            finish = 17,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 23,
        range  = 20,
        parent = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 19,
            finish = 20,
            parent = "<IGNORE>",
            [1]    = 2,
        },
        [1]    = "y",
    },
    [3]     = {
        type   = "local",
        start  = 12,
        finish = 13,
        effect = 23,
        range  = 23,
        parent = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 22,
            finish = 23,
            parent = "<IGNORE>",
            [1]    = 3,
        },
        [1]    = "z",
    },
}
CHECK'local x, y = y, x'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 17,
    locals  = "<IGNORE>",
    bfinish = 17,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 17,
        range  = 14,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "getglobal",
            start  = 13,
            finish = 14,
            parent = "<IGNORE>",
            node   = "<IGNORE>",
            [1]    = "y",
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 17,
        range  = 17,
        parent = "<IGNORE>",
        value  = {
            type   = "getglobal",
            start  = 16,
            finish = 17,
            parent = "<IGNORE>",
            node   = "<IGNORE>",
            [1]    = "x",
        },
        [1]    = "y",
    },
}
CHECK'local x, y = f()'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 16,
    locals  = "<IGNORE>",
    bfinish = 16,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 16,
        range  = 16,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "select",
            start  = 13,
            finish = 16,
            parent = "<IGNORE>",
            vararg = "<IGNORE>",
            sindex = 1,
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 16,
        range  = 16,
        parent = "<IGNORE>",
        value  = {
            type   = "select",
            start  = 13,
            finish = 16,
            parent = "<IGNORE>",
            vararg = "<IGNORE>",
            sindex = 2,
        },
        [1]    = "y",
    },
}
CHECK'local x, y = (f())'
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
            start  = 13,
            finish = 18,
            parent = "<IGNORE>",
            exp    = {
                type   = "call",
                start  = 14,
                finish = 17,
                parent = "<IGNORE>",
                node   = "<IGNORE>",
            },
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 18,
        parent = "<IGNORE>",
        [1]    = "y",
    },
}
CHECK'local x, y = f(), nil'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 21,
    locals  = "<IGNORE>",
    bfinish = 21,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 21,
        range  = 16,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "select",
            start  = 13,
            finish = 16,
            parent = "<IGNORE>",
            vararg = "<IGNORE>",
            sindex = 1,
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 21,
        range  = 21,
        parent = "<IGNORE>",
        value  = {
            type   = "nil",
            start  = 18,
            finish = 21,
            parent = "<IGNORE>",
        },
        [1]    = "y",
    },
}
CHECK'local x, y = ...'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 16,
    locals  = "<IGNORE>",
    bfinish = 16,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 16,
        range  = 16,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "select",
            start  = 13,
            finish = 16,
            parent = "<IGNORE>",
            vararg = "<IGNORE>",
            sindex = 1,
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 16,
        range  = 16,
        parent = "<IGNORE>",
        value  = {
            type   = "select",
            start  = 13,
            finish = 16,
            parent = "<IGNORE>",
            vararg = "<IGNORE>",
            sindex = 2,
        },
        [1]    = "y",
    },
}
CHECK'local x, y = (...)'
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
            start  = 13,
            finish = 18,
            parent = "<IGNORE>",
            exp    = {
                type   = "varargs",
                start  = 14,
                finish = 17,
                parent = "<IGNORE>",
            },
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 18,
        parent = "<IGNORE>",
        [1]    = "y",
    },
}
CHECK'local x, y = ..., nil'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 21,
    locals  = "<IGNORE>",
    bfinish = 21,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 21,
        range  = 16,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "select",
            start  = 13,
            finish = 16,
            parent = "<IGNORE>",
            vararg = "<IGNORE>",
            sindex = 1,
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 21,
        range  = 21,
        parent = "<IGNORE>",
        value  = {
            type   = "nil",
            start  = 18,
            finish = 21,
            parent = "<IGNORE>",
        },
        [1]    = "y",
    },
}
CHECK'local x <const>, y <close> = 1'
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 30,
    locals  = "<IGNORE>",
    bfinish = 30,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 30,
        range  = 30,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "integer",
            start  = 29,
            finish = 30,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        attrs  = {
            type   = "localattrs",
            parent = "<IGNORE>",
            [1]    = {
                type   = "localattr",
                start  = 8,
                finish = 15,
                parent = "<IGNORE>",
                [1]    = "const",
            },
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 17,
        finish = 18,
        effect = 30,
        parent = "<IGNORE>",
        attrs  = {
            type   = "localattrs",
            parent = "<IGNORE>",
            [1]    = {
                type   = "localattr",
                start  = 19,
                finish = 26,
                parent = "<IGNORE>",
                [1]    = "close",
            },
        },
        [1]    = "y",
    },
}
CHECK[[
x = 1
y = 2
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20000,
    locals  = "<IGNORE>",
    bfinish = 20000,
    [1]     = {
        type   = "setglobal",
        start  = 0,
        finish = 1,
        range  = 5,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 4,
            finish = 5,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "setglobal",
        start  = 10000,
        finish = 10001,
        range  = 10005,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 10004,
            finish = 10005,
            parent = "<IGNORE>",
            [1]    = 2,
        },
        [1]    = "y",
    },
}

CHECK[[
x, y = 1, 2
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
        range  = 8,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 7,
            finish = 8,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "setglobal",
        start  = 3,
        finish = 4,
        range  = 11,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 10,
            finish = 11,
            parent = "<IGNORE>",
            [1]    = 2,
        },
        [1]    = "y",
    },
}
CHECK[[
local function a()
    return
end]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20003,
    locals  = "<IGNORE>",
    bfinish = 20003,
    [1]     = {
        type   = "local",
        start  = 15,
        vstart = 6,
        finish = 16,
        effect = 16,
        range  = 20003,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type      = "function",
            start     = 6,
            bstart    = 18,
            finish    = 20003,
            keyword   = {
                [1] = 6,
                [2] = 14,
                [3] = 20000,
                [4] = 20003,
            },
            parent    = "<IGNORE>",
            args      = {
                type   = "funcargs",
                start  = 16,
                finish = 18,
                parent = "<IGNORE>",
            },
            returns   = "<IGNORE>",
            bfinish   = 20000,
            hasReturn = true,
            [1]       = {
                type   = "return",
                start  = 10004,
                finish = 10010,
                parent = "<IGNORE>",
            },
        },
        [1]    = "a",
    },
}
CHECK[[
local function f()
    return f()
end]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20003,
    locals  = "<IGNORE>",
    bfinish = 20003,
    [1]     = {
        type   = "local",
        start  = 15,
        vstart = 6,
        finish = 16,
        effect = 16,
        range  = 20003,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type      = "function",
            start     = 6,
            bstart    = 18,
            finish    = 20003,
            keyword   = {
                [1] = 6,
                [2] = 14,
                [3] = 20000,
                [4] = 20003,
            },
            parent    = "<IGNORE>",
            args      = {
                type   = "funcargs",
                start  = 16,
                finish = 18,
                parent = "<IGNORE>",
            },
            returns   = "<IGNORE>",
            bfinish   = 20000,
            hasReturn = true,
            [1]       = {
                type   = "return",
                start  = 10004,
                finish = 10014,
                parent = "<IGNORE>",
                [1]    = {
                    type   = "call",
                    start  = 10011,
                    finish = 10014,
                    parent = "<IGNORE>",
                    node   = "<IGNORE>",
                },
            },
        },
        ref    = "<IGNORE>",
        [1]    = "f",
    },
}
CHECK[[
local function a(b, c)
    return
end]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 20003,
    locals  = "<IGNORE>",
    bfinish = 20003,
    [1]     = {
        type   = "local",
        start  = 15,
        vstart = 6,
        finish = 16,
        effect = 16,
        range  = 20003,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type      = "function",
            start     = 6,
            bstart    = 22,
            finish    = 20003,
            keyword   = {
                [1] = 6,
                [2] = 14,
                [3] = 20000,
                [4] = 20003,
            },
            parent    = "<IGNORE>",
            args      = {
                type   = "funcargs",
                start  = 16,
                finish = 22,
                parent = "<IGNORE>",
                [1]    = {
                    type   = "local",
                    start  = 17,
                    finish = 18,
                    effect = 18,
                    parent = "<IGNORE>",
                    [1]    = "b",
                },
                [2]    = {
                    type   = "local",
                    start  = 20,
                    finish = 21,
                    effect = 21,
                    parent = "<IGNORE>",
                    [1]    = "c",
                },
            },
            locals    = "<IGNORE>",
            returns   = "<IGNORE>",
            bfinish   = 20000,
            hasReturn = true,
            [1]       = {
                type   = "return",
                start  = 10004,
                finish = 10010,
                parent = "<IGNORE>",
            },
        },
        [1]    = "a",
    },
}

CHECK[[
local x, y, z = 1, 2
local function f()
end
y, z = 3, 4
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 40000,
    locals  = "<IGNORE>",
    bfinish = 40000,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 20,
        range  = 17,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "integer",
            start  = 16,
            finish = 17,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 20,
        range  = 20,
        parent = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 19,
            finish = 20,
            parent = "<IGNORE>",
            [1]    = 2,
        },
        ref    = "<IGNORE>",
        [1]    = "y",
    },
    [3]     = {
        type   = "local",
        start  = 12,
        finish = 13,
        effect = 20,
        parent = "<IGNORE>",
        ref    = "<IGNORE>",
        [1]    = "z",
    },
    [4]     = {
        type   = "local",
        start  = 10015,
        vstart = 10006,
        finish = 10016,
        effect = 10016,
        range  = 20003,
        parent = "<IGNORE>",
        locPos = 10000,
        value  = {
            type    = "function",
            start   = 10006,
            bstart  = 10018,
            finish  = 20003,
            keyword = {
                [1] = 10006,
                [2] = 10014,
                [3] = 20000,
                [4] = 20003,
            },
            parent  = "<IGNORE>",
            args    = {
                type   = "funcargs",
                start  = 10016,
                finish = 10018,
                parent = "<IGNORE>",
            },
            bfinish = 20000,
        },
        [1]    = "f",
    },
    [5]     = {
        type   = "setlocal",
        start  = 30000,
        finish = 30001,
        range  = 30008,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 30007,
            finish = 30008,
            parent = "<IGNORE>",
            [1]    = 3,
        },
        [1]    = "y",
    },
    [6]     = {
        type   = "setlocal",
        start  = 30003,
        finish = 30004,
        range  = 30011,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 30010,
            finish = 30011,
            parent = "<IGNORE>",
            [1]    = 4,
        },
        [1]    = "z",
    },
}
CHECK[[
local f = require
local z = f
z'xxx'
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 30000,
    locals  = "<IGNORE>",
    bfinish = 30000,
    [1]     = {
        type    = "local",
        start   = 6,
        finish  = 7,
        effect  = 17,
        range   = 17,
        special = "require",
        parent  = "<IGNORE>",
        locPos  = 0,
        value   = {
            type    = "getglobal",
            start   = 10,
            finish  = 17,
            special = "require",
            parent  = "<IGNORE>",
            node    = "<IGNORE>",
            [1]     = "require",
        },
        ref     = "<IGNORE>",
        [1]     = "f",
    },
    [2]     = {
        type    = "local",
        start   = 10006,
        finish  = 10007,
        effect  = 10011,
        range   = 10011,
        special = "require",
        parent  = "<IGNORE>",
        locPos  = 10000,
        value   = {
            type    = "getlocal",
            start   = 10010,
            finish  = 10011,
            special = "require",
            parent  = "<IGNORE>",
            node    = "<IGNORE>",
            [1]     = "f",
        },
        ref     = "<IGNORE>",
        [1]     = "z",
    },
    [3]     = {
        type   = "call",
        start  = 20000,
        finish = 20006,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        args   = {
            type   = "callargs",
            start  = 20001,
            finish = 20006,
            parent = "<IGNORE>",
            [1]    = {
                type   = "string",
                start  = 20001,
                finish = 20006,
                parent = "<IGNORE>",
                [1]    = "xxx",
                [2]    = "'",
            },
        },
    },
}
CHECK[[
A:B(1):C(2)
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
        finish = 11,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        args   = {
            type   = "callargs",
            start  = 8,
            finish = 11,
            parent = "<IGNORE>",
            [1]    = {
                type   = "self",
                start  = 6,
                finish = 7,
                parent = "<IGNORE>",
                [1]    = "self",
            },
            [2]    = {
                type   = "integer",
                start  = 9,
                finish = 10,
                parent = "<IGNORE>",
                [1]    = 2,
            },
        },
    },
}

CHECK [[

local s = [ [=[111]=] ]
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
        effect = 10007,
        parent = "<IGNORE>",
        locPos = 10000,
        [1]    = "s",
    },
    [2]     = {
        type   = "string",
        start  = 10012,
        finish = 10021,
        parent = "<IGNORE>",
        [1]    = "111",
        [2]    = "[=[",
    },
}
CHECK([[
local x = 1 // 2
]], {
    nonstandardSymbol = { ['//'] = true }
})
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
        effect = 11,
        range  = 11,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "integer",
            start  = 10,
            finish = 11,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [1]    = "x",
    },
}

CHECK([[
local x = {
    1, // BAD
    2, // GOOD
    3, // GOOD
}
]], {
    nonstandardSymbol = { ['//'] = true }
})
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 50000,
    locals  = "<IGNORE>",
    bfinish = 50000,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 40001,
        range  = 40001,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type    = "table",
            start   = 10,
            bstart  = 11,
            finish  = 40001,
            parent  = "<IGNORE>",
            bfinish = 40000,
            [1]     = {
                type   = "tableexp",
                start  = 10004,
                finish = 10005,
                tindex = 1,
                parent = "<IGNORE>",
                value  = {
                    type   = "integer",
                    start  = 10004,
                    finish = 10005,
                    parent = "<IGNORE>",
                    [1]    = 1,
                },
            },
            [2]     = {
                type   = "tableexp",
                start  = 20004,
                finish = 20005,
                tindex = 2,
                parent = "<IGNORE>",
                value  = {
                    type   = "integer",
                    start  = 20004,
                    finish = 20005,
                    parent = "<IGNORE>",
                    [1]    = 2,
                },
            },
            [3]     = {
                type   = "tableexp",
                start  = 30004,
                finish = 30005,
                tindex = 3,
                parent = "<IGNORE>",
                value  = {
                    type   = "integer",
                    start  = 30004,
                    finish = 30005,
                    parent = "<IGNORE>",
                    [1]    = 3,
                },
            },
        },
        [1]    = "x",
    },
}

CHECK [[
local x
return {
    x = 1,
}
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 40000,
    locals  = "<IGNORE>",
    returns = "<IGNORE>",
    bfinish = 40000,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 7,
        parent = "<IGNORE>",
        locPos = 0,
        [1]    = "x",
    },
    [2]     = {
        type   = "return",
        start  = 10000,
        finish = 30001,
        parent = "<IGNORE>",
        [1]    = {
            type    = "table",
            start   = 10007,
            bstart  = 10008,
            finish  = 30001,
            parent  = "<IGNORE>",
            bfinish = 30000,
            [1]     = {
                type   = "tablefield",
                start  = 20004,
                finish = 20005,
                range  = 20009,
                parent = "<IGNORE>",
                node   = "<IGNORE>",
                field  = {
                    type   = "field",
                    start  = 20004,
                    finish = 20005,
                    parent = "<IGNORE>",
                    [1]    = "x",
                },
                value  = {
                    type   = "integer",
                    start  = 20008,
                    finish = 20009,
                    parent = "<IGNORE>",
                    [1]    = 1,
                },
            },
        },
    },
}

CHECK [[
local x
a = {
    x
}
]]
{
    type    = "main",
    start   = 0,
    bstart  = 0,
    finish  = 40000,
    locals  = "<IGNORE>",
    bfinish = 40000,
    [1]     = {
        type   = "local",
        start  = 6,
        finish = 7,
        effect = 7,
        parent = "<IGNORE>",
        locPos = 0,
        ref    = "<IGNORE>",
        [1]    = "x",
    },
    [2]     = {
        type   = "setglobal",
        start  = 10000,
        finish = 10001,
        range  = 30001,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type    = "table",
            start   = 10004,
            bstart  = 10005,
            finish  = 30001,
            parent  = "<IGNORE>",
            bfinish = 30000,
            [1]     = {
                type   = "tableexp",
                start  = 20004,
                finish = 20005,
                tindex = 1,
                parent = "<IGNORE>",
                value  = {
                    type   = "getlocal",
                    start  = 20004,
                    finish = 20005,
                    parent = "<IGNORE>",
                    node   = "<IGNORE>",
                    [1]    = "x",
                },
            },
        },
        [1]    = "a",
    },
}

CHECK [[
x, y, z = 1, func()
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
        range  = 11,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "integer",
            start  = 10,
            finish = 11,
            parent = "<IGNORE>",
            [1]    = 1,
        },
        [1]    = "x",
    },
    [2]     = {
        type   = "setglobal",
        start  = 3,
        finish = 4,
        range  = 19,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "select",
            start  = 13,
            finish = 19,
            parent = "<IGNORE>",
            vararg = "<IGNORE>",
            sindex = 1,
        },
        [1]    = "y",
    },
    [3]     = {
        type   = "setglobal",
        start  = 6,
        finish = 7,
        range  = 19,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        value  = {
            type   = "select",
            start  = 13,
            finish = 19,
            parent = "<IGNORE>",
            vararg = "<IGNORE>",
            sindex = 2,
        },
        [1]    = "z",
    },
}

CHECK [[
local x, y
-- comments
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
        effect = 10,
        parent = "<IGNORE>",
        locPos = 0,
        [1]    = "x",
    },
    [2]     = {
        type   = "local",
        start  = 9,
        finish = 10,
        effect = 10,
        parent = "<IGNORE>",
        [1]    = "y",
    },
}

CHECK [[
local _ENV = nil
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
        finish = 10,
        effect = 16,
        range  = 16,
        parent = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "nil",
            start  = 13,
            finish = 16,
            parent = "<IGNORE>",
        },
        [1]    = "_ENV",
    },
}

CHECK [[
_ENV = nil
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
        start  = 0,
        finish = 4,
        effect = 10,
        range  = 10,
        parent = "<IGNORE>",
        node   = "<IGNORE>",
        locPos = 0,
        value  = {
            type   = "nil",
            start  = 7,
            finish = 10,
            parent = "<IGNORE>",
        },
        [1]    = "_ENV",
    },
}
