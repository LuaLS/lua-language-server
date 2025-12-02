LuaDoc [[
---@class Class
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.class",
        start           = 10,
        finish          = 15,
        range           = 15,
        parent          = "<IGNORE>",
        bindComments    = {
        },
        calls           = {
        },
        class           = {
            type   = "doc.class.name",
            start  = 10,
            finish = 15,
            parent = "<IGNORE>",
            [1]    = "Class",
        },
        fields          = {
        },
        operators       = {
        },
        originalComment = "<IGNORE>",
    },
}

LuaDoc [[
---@class Class : SuperClass
local x = 1
]]
{
    type   = "doc",
    start  = 0,
    finish = 20000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.class",
        start           = 10,
        finish          = 28,
        range           = 28,
        parent          = "<IGNORE>",
        bindComments    = {
        },
        bindSource      = "<IGNORE>",
        calls           = {
        },
        class           = {
            type   = "doc.class.name",
            start  = 10,
            finish = 15,
            parent = "<IGNORE>",
            [1]    = "Class",
        },
        extends         = {
            [1] = {
                type   = "doc.extends.name",
                start  = 18,
                finish = 28,
                parent = "<IGNORE>",
                [1]    = "SuperClass",
            },
        },
        fields          = {
        },
        operators       = {
        },
        originalComment = "<IGNORE>",
    },
}

LuaDoc [[
---@type Type
x = 1
]]
{
    type   = "doc",
    start  = 0,
    finish = 20000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.type",
        start           = 9,
        finish          = 13,
        range           = 13,
        parent          = "<IGNORE>",
        bindSource      = "<IGNORE>",
        firstFinish     = 13,
        originalComment = "<IGNORE>",
        types           = {
            [1] = {
                type   = "doc.type.name",
                start  = 9,
                finish = 13,
                parent = "<IGNORE>",
                [1]    = "Type",
            },
        },
    },
}

LuaDoc [[
---@type Type1|Type2|Type3
x = 1
]]
{
    type   = "doc",
    start  = 0,
    finish = 20000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.type",
        start           = 9,
        finish          = 26,
        range           = 26,
        parent          = "<IGNORE>",
        bindSource      = "<IGNORE>",
        firstFinish     = 26,
        originalComment = "<IGNORE>",
        types           = {
            [1] = {
                type   = "doc.type.name",
                start  = 9,
                finish = 14,
                parent = "<IGNORE>",
                [1]    = "Type1",
            },
            [2] = {
                type   = "doc.type.name",
                start  = 15,
                finish = 20,
                parent = "<IGNORE>",
                [1]    = "Type2",
            },
            [3] = {
                type   = "doc.type.name",
                start  = 21,
                finish = 26,
                parent = "<IGNORE>",
                [1]    = "Type3",
            },
        },
    },
}

LuaDoc [[
---@type x | "'a'" | "'b'"
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.type",
        start           = 9,
        finish          = 26,
        range           = 26,
        parent          = "<IGNORE>",
        firstFinish     = 26,
        originalComment = "<IGNORE>",
        types           = {
            [1] = {
                type   = "doc.type.name",
                start  = 9,
                finish = 10,
                parent = "<IGNORE>",
                [1]    = "x",
            },
            [2] = {
                type   = "doc.type.string",
                start  = 13,
                finish = 18,
                parent = "<IGNORE>",
                [1]    = "a",
                [2]    = "'",
            },
            [3] = {
                type   = "doc.type.string",
                start  = 21,
                finish = 26,
                parent = "<IGNORE>",
                [1]    = "b",
                [2]    = "'",
            },
        },
    },
}

LuaDoc [[
---@type "'a'" | "'b'" | "'c'"
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.type",
        start           = 9,
        finish          = 30,
        range           = 30,
        parent          = "<IGNORE>",
        firstFinish     = 30,
        originalComment = "<IGNORE>",
        types           = {
            [1] = {
                type   = "doc.type.string",
                start  = 9,
                finish = 14,
                parent = "<IGNORE>",
                [1]    = "a",
                [2]    = "'",
            },
            [2] = {
                type   = "doc.type.string",
                start  = 17,
                finish = 22,
                parent = "<IGNORE>",
                [1]    = "b",
                [2]    = "'",
            },
            [3] = {
                type   = "doc.type.string",
                start  = 25,
                finish = 30,
                parent = "<IGNORE>",
                [1]    = "c",
                [2]    = "'",
            },
        },
    },
}

LuaDoc [[
---@alias Handler LongType
x = 1
]]
{
    type   = "doc",
    start  = 0,
    finish = 20000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.alias",
        start           = 10,
        finish          = 26,
        range           = 26,
        parent          = "<IGNORE>",
        alias           = {
            type   = "doc.alias.name",
            start  = 10,
            finish = 17,
            parent = "<IGNORE>",
            [1]    = "Handler",
        },
        bindComments    = {
        },
        extends         = {
            type        = "doc.type",
            start       = 18,
            finish      = 26,
            parent      = "<IGNORE>",
            firstFinish = 26,
            types       = {
                [1] = {
                    type   = "doc.type.name",
                    start  = 18,
                    finish = 26,
                    parent = "<IGNORE>",
                    [1]    = "LongType",
                },
            },
        },
        originalComment = "<IGNORE>",
    },
}

LuaDoc [[
---@param a1 t1
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.param",
        start           = 10,
        finish          = 15,
        range           = 15,
        parent          = "<IGNORE>",
        extends         = {
            type        = "doc.type",
            start       = 13,
            finish      = 15,
            parent      = "<IGNORE>",
            firstFinish = 15,
            types       = {
                [1] = {
                    type   = "doc.type.name",
                    start  = 13,
                    finish = 15,
                    parent = "<IGNORE>",
                    [1]    = "t1",
                },
            },
        },
        firstFinish     = 15,
        originalComment = "<IGNORE>",
        param           = {
            type   = "doc.param.name",
            start  = 10,
            finish = 12,
            parent = "<IGNORE>",
            [1]    = "a1",
        },
    },
}

LuaDoc [[
---@return Type1|Type2|Type3
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.return",
        start           = 11,
        finish          = 28,
        range           = 28,
        parent          = "<IGNORE>",
        returns         = "<IGNORE>",
        originalComment = "<IGNORE>",
    },
}

LuaDoc [[
---@return Type1,Type2,Type3
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.return",
        start           = 11,
        finish          = 28,
        range           = 28,
        parent          = "<IGNORE>",
        returns         = "<IGNORE>",
        originalComment = "<IGNORE>",
    },
}

LuaDoc [[
---@field open function
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.field",
        start           = 10,
        finish          = 23,
        range           = 23,
        parent          = "<IGNORE>",
        field           = {
            type   = "doc.field.name",
            start  = 10,
            finish = 14,
            parent = "<IGNORE>",
            [1]    = "open",
        },
        bindComments    = {
        },
        extends         = {
            type        = "doc.type",
            start       = 15,
            finish      = 23,
            parent      = "<IGNORE>",
            firstFinish = 23,
            types       = {
                [1] = {
                    type   = "doc.type.name",
                    start  = 15,
                    finish = 23,
                    parent = "<IGNORE>",
                    [1]    = "function",
                },
            },
        },
        originalComment = "<IGNORE>",
    },
}

LuaDoc [[
---@field private open function|string
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.field",
        start           = 10,
        finish          = 38,
        range           = 38,
        parent          = "<IGNORE>",
        field           = {
            type   = "doc.field.name",
            start  = 18,
            finish = 22,
            parent = "<IGNORE>",
            [1]    = "open",
        },
        bindComments    = {
        },
        extends         = {
            type        = "doc.type",
            start       = 23,
            finish      = 38,
            parent      = "<IGNORE>",
            firstFinish = 38,
            types       = {
                [1] = {
                    type   = "doc.type.name",
                    start  = 23,
                    finish = 31,
                    parent = "<IGNORE>",
                    [1]    = "function",
                },
                [2] = {
                    type   = "doc.type.name",
                    start  = 32,
                    finish = 38,
                    parent = "<IGNORE>",
                    [1]    = "string",
                },
            },
        },
        originalComment = "<IGNORE>",
        visible         = "private",
    },
}

LuaDoc [[
---@generic T
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.generic",
        start           = 12,
        finish          = 13,
        range           = 13,
        parent          = "<IGNORE>",
        generics        = {
            [1] = {
                type    = "doc.generic.object",
                start   = 12,
                finish  = 13,
                parent  = "<IGNORE>",
                generic = {
                    type   = "doc.generic.name",
                    start  = 12,
                    finish = 13,
                    parent = "<IGNORE>",
                    [1]    = "T",
                },
            },
        },
        originalComment = "<IGNORE>",
    },
}

LuaDoc [[
---@generic T : handle
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.generic",
        start           = 12,
        finish          = 22,
        range           = 22,
        parent          = "<IGNORE>",
        generics        = {
            [1] = {
                type    = "doc.generic.object",
                start   = 12,
                finish  = 22,
                parent  = "<IGNORE>",
                extends = {
                    type        = "doc.type",
                    start       = 16,
                    finish      = 22,
                    parent      = "<IGNORE>",
                    firstFinish = 22,
                    types       = {
                        [1] = {
                            type   = "doc.type.name",
                            start  = 16,
                            finish = 22,
                            parent = "<IGNORE>",
                            [1]    = "handle",
                        },
                    },
                },
                generic = {
                    type   = "doc.generic.name",
                    start  = 12,
                    finish = 13,
                    parent = "<IGNORE>",
                    [1]    = "T",
                },
            },
        },
        originalComment = "<IGNORE>",
    },
}

LuaDoc [[
---@generic T : handle, K : handle
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.generic",
        start           = 12,
        finish          = 34,
        range           = 34,
        parent          = "<IGNORE>",
        generics        = {
            [1] = {
                type    = "doc.generic.object",
                start   = 12,
                finish  = 22,
                parent  = "<IGNORE>",
                extends = {
                    type        = "doc.type",
                    start       = 16,
                    finish      = 22,
                    parent      = "<IGNORE>",
                    firstFinish = 22,
                    types       = {
                        [1] = {
                            type   = "doc.type.name",
                            start  = 16,
                            finish = 22,
                            parent = "<IGNORE>",
                            [1]    = "handle",
                        },
                    },
                },
                generic = {
                    type   = "doc.generic.name",
                    start  = 12,
                    finish = 13,
                    parent = "<IGNORE>",
                    [1]    = "T",
                },
            },
            [2] = {
                type    = "doc.generic.object",
                start   = 24,
                finish  = 34,
                parent  = "<IGNORE>",
                extends = {
                    type        = "doc.type",
                    start       = 28,
                    finish      = 34,
                    parent      = "<IGNORE>",
                    firstFinish = 34,
                    types       = {
                        [1] = {
                            type   = "doc.type.name",
                            start  = 28,
                            finish = 34,
                            parent = "<IGNORE>",
                            [1]    = "handle",
                        },
                    },
                },
                generic = {
                    type   = "doc.generic.name",
                    start  = 24,
                    finish = 25,
                    parent = "<IGNORE>",
                    [1]    = "K",
                },
            },
        },
        originalComment = "<IGNORE>",
    },
}

LuaDoc [[
---@vararg string
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.vararg",
        start           = 11,
        finish          = 17,
        range           = 17,
        parent          = "<IGNORE>",
        vararg          = "<IGNORE>",
        originalComment = "<IGNORE>",
    },
}

LuaDoc [[
---@type Type[]
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.type",
        start           = 9,
        finish          = 15,
        range           = 15,
        parent          = "<IGNORE>",
        firstFinish     = 15,
        originalComment = "<IGNORE>",
        types           = {
            [1] = {
                type   = "doc.type.array",
                start  = 9,
                finish = 15,
                parent = "<IGNORE>",
                node   = "<IGNORE>",
            },
        },
    },
}

LuaDoc [[
---@type table<key, value>
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.type",
        start           = 9,
        finish          = 26,
        range           = 26,
        parent          = "<IGNORE>",
        firstFinish     = 26,
        originalComment = "<IGNORE>",
        types           = {
            [1] = {
                type   = "doc.type.sign",
                start  = 9,
                finish = 26,
                parent = "<IGNORE>",
                node   = "<IGNORE>",
                signs  = {
                    [1] = {
                        type        = "doc.type",
                        start       = 15,
                        finish      = 18,
                        parent      = "<IGNORE>",
                        firstFinish = 18,
                        types       = {
                            [1] = {
                                type   = "doc.type.name",
                                start  = 15,
                                finish = 18,
                                parent = "<IGNORE>",
                                [1]    = "key",
                            },
                        },
                    },
                    [2] = {
                        type        = "doc.type",
                        start       = 20,
                        finish      = 25,
                        parent      = "<IGNORE>",
                        firstFinish = 25,
                        types       = {
                            [1] = {
                                type   = "doc.type.name",
                                start  = 20,
                                finish = 25,
                                parent = "<IGNORE>",
                                [1]    = "value",
                            },
                        },
                    },
                },
            },
        },
    },
}

IGNORE_MAP['returns'] = nil
IGNORE_MAP['extends'] = true
LuaDoc [[
---@type fun(key1:t1, key2:t2):t3
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.type",
        start           = 9,
        finish          = 33,
        range           = 33,
        parent          = "<IGNORE>",
        firstFinish     = 33,
        originalComment = "<IGNORE>",
        types           = {
            [1] = {
                type    = "doc.type.function",
                start   = 9,
                finish  = 33,
                parent  = "<IGNORE>",
                args    = {
                    [1] = {
                        type    = "doc.type.arg",
                        start   = 13,
                        finish  = 20,
                        parent  = "<IGNORE>",
                        extends = "<IGNORE>",
                        name    = {
                            type   = "doc.type.arg.name",
                            start  = 13,
                            finish = 17,
                            parent = "<IGNORE>",
                            [1]    = "key1",
                        },
                    },
                    [2] = {
                        type    = "doc.type.arg",
                        start   = 22,
                        finish  = 29,
                        parent  = "<IGNORE>",
                        extends = "<IGNORE>",
                        name    = {
                            type   = "doc.type.arg.name",
                            start  = 22,
                            finish = 26,
                            parent = "<IGNORE>",
                            [1]    = "key2",
                        },
                    },
                },
                returns = {
                    [1] = {
                        type        = "doc.type",
                        start       = 31,
                        finish      = 33,
                        parent      = "<IGNORE>",
                        firstFinish = 33,
                        types       = {
                            [1] = {
                                type   = "doc.type.name",
                                start  = 31,
                                finish = 33,
                                parent = "<IGNORE>",
                                [1]    = "t3",
                            },
                        },
                    },
                },
            },
        },
    },
}

IGNORE_MAP['returns'] = true
IGNORE_MAP['extends'] = nil
LuaDoc [[
---@param event string | "'onClosed'" | "'onData'"
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.param",
        start           = 10,
        finish          = 50,
        range           = 50,
        parent          = "<IGNORE>",
        extends         = {
            type        = "doc.type",
            start       = 16,
            finish      = 50,
            parent      = "<IGNORE>",
            firstFinish = 50,
            types       = {
                [1] = {
                    type   = "doc.type.name",
                    start  = 16,
                    finish = 22,
                    parent = "<IGNORE>",
                    [1]    = "string",
                },
                [2] = {
                    type   = "doc.type.string",
                    start  = 25,
                    finish = 37,
                    parent = "<IGNORE>",
                    [1]    = "onClosed",
                    [2]    = "'",
                },
                [3] = {
                    type   = "doc.type.string",
                    start  = 40,
                    finish = 50,
                    parent = "<IGNORE>",
                    [1]    = "onData",
                    [2]    = "'",
                },
            },
        },
        firstFinish     = 50,
        originalComment = "<IGNORE>",
        param           = {
            type   = "doc.param.name",
            start  = 10,
            finish = 15,
            parent = "<IGNORE>",
            [1]    = "event",
        },
    },
}

LuaDoc [[
---@overload fun(a:number):number
]]
{
    type   = "doc",
    start  = 0,
    finish = 10000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.overload",
        start           = 13,
        finish          = 33,
        range           = 33,
        parent          = "<IGNORE>",
        originalComment = "<IGNORE>",
        overload        = {
            type    = "doc.type.function",
            start   = 13,
            finish  = 33,
            parent  = "<IGNORE>",
            args    = {
                [1] = {
                    type    = "doc.type.arg",
                    start   = 17,
                    finish  = 25,
                    parent  = "<IGNORE>",
                    extends = {
                        type        = "doc.type",
                        start       = 19,
                        finish      = 25,
                        parent      = "<IGNORE>",
                        firstFinish = 25,
                        types       = {
                            [1] = {
                                type   = "doc.type.name",
                                start  = 19,
                                finish = 25,
                                parent = "<IGNORE>",
                                [1]    = "number",
                            },
                        },
                    },
                    name    = {
                        type   = "doc.type.arg.name",
                        start  = 17,
                        finish = 18,
                        parent = "<IGNORE>",
                        [1]    = "a",
                    },
                },
            },
            returns = "<IGNORE>",
        },
    },
}

LuaDoc [[
---@type {
--- x: number,
--- y: number,
--- [number]: boolean,
---}
]]
{
    type   = "doc",
    start  = 0,
    finish = 50000,
    parent = "<IGNORE>",
    [1]    = {
        type            = "doc.type",
        start           = 9,
        finish          = 40004,
        range           = 40004,
        parent          = "<IGNORE>",
        firstFinish     = 40004,
        originalComment = "<IGNORE>",
        types           = {
            [1] = {
                type   = "doc.type.table",
                start  = 9,
                finish = 40004,
                parent = "<IGNORE>",
                fields = {
                    [1] = {
                        type    = "doc.type.field",
                        start   = 10004,
                        finish  = 10013,
                        parent  = "<IGNORE>",
                        extends = {
                            type        = "doc.type",
                            start       = 10007,
                            finish      = 10013,
                            parent      = "<IGNORE>",
                            firstFinish = 10013,
                            types       = {
                                [1] = {
                                    type   = "doc.type.name",
                                    start  = 10007,
                                    finish = 10013,
                                    parent = "<IGNORE>",
                                    [1]    = "number",
                                },
                            },
                        },
                        name    = {
                            type   = "doc.field.name",
                            start  = 10004,
                            finish = 10005,
                            parent = "<IGNORE>",
                            [1]    = "x",
                        },
                    },
                    [2] = {
                        type    = "doc.type.field",
                        start   = 20004,
                        finish  = 20013,
                        parent  = "<IGNORE>",
                        extends = {
                            type        = "doc.type",
                            start       = 20007,
                            finish      = 20013,
                            parent      = "<IGNORE>",
                            firstFinish = 20013,
                            types       = {
                                [1] = {
                                    type   = "doc.type.name",
                                    start  = 20007,
                                    finish = 20013,
                                    parent = "<IGNORE>",
                                    [1]    = "number",
                                },
                            },
                        },
                        name    = {
                            type   = "doc.field.name",
                            start  = 20004,
                            finish = 20005,
                            parent = "<IGNORE>",
                            [1]    = "y",
                        },
                    },
                    [3] = {
                        type    = "doc.type.field",
                        start   = 30005,
                        finish  = 30021,
                        parent  = "<IGNORE>",
                        extends = {
                            type        = "doc.type",
                            start       = 30014,
                            finish      = 30021,
                            parent      = "<IGNORE>",
                            firstFinish = 30021,
                            types       = {
                                [1] = {
                                    type   = "doc.type.name",
                                    start  = 30014,
                                    finish = 30021,
                                    parent = "<IGNORE>",
                                    [1]    = "boolean",
                                },
                            },
                        },
                        name    = {
                            type        = "doc.type",
                            start       = 30005,
                            finish      = 30011,
                            parent      = "<IGNORE>",
                            firstFinish = 30011,
                            types       = {
                                [1] = {
                                    type   = "doc.type.name",
                                    start  = 30005,
                                    finish = 30011,
                                    parent = "<IGNORE>",
                                    [1]    = "number",
                                },
                            },
                        },
                    },
                },
            },
        },
    },
}
