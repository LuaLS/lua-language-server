CHECK[['123']]
{
    type   = "string",
    start  = 0,
    finish = 5,
    [1]    = "123",
    [2]    = "'",
}
CHECK[['123\'']]
{
    type   = "string",
    start  = 0,
    finish = 7,
    escs   = {
        [1] = 4,
        [2] = 6,
        [3] = "normal",
    },
    [1]    = "123'",
    [2]    = "'",
}
CHECK[['123\z
    345']]
{
    type   = "string",
    start  = 0,
    finish = 10008,
    escs   = {
        [1] = 4,
        [2] = 6,
        [3] = "normal",
    },
    [1]    = "123345",
    [2]    = "'",
}

CHECK[['123\
345']]
{
    type   = "string",
    start  = 0,
    finish = 10004,
    escs   = {
        [1] = 4,
        [2] = 5,
        [3] = "normal",
    },
    [1]    = "123\
345",
    [2]    = "'",
}
CHECK[===[[[123]]]===]
{
    type   = "string",
    start  = 0,
    finish = 7,
    [1]    = "123",
    [2]    = "[[",
}
CHECK[===[[[123
345]]]===]
{
    type   = "string",
    start  = 0,
    finish = 10005,
    [1]    = "123\
345",
    [2]    = "[[",
}
CHECK[['alo\n123"']]
{
    type   = "string",
    start  = 0,
    finish = 11,
    escs   = {
        [1] = 4,
        [2] = 6,
        [3] = "normal",
    },
    [1]    = "alo\
123\"",
    [2]    = "'",
}
CHECK[['\97lo\10\04923"']]
{
    type   = "string",
    start  = 0,
    finish = 17,
    escs   = {
        [1] = 1,
        [2] = 4,
        [3] = "byte",
        [4] = 6,
        [5] = 9,
        [6] = "byte",
        [7] = 9,
        [8] = 13,
        [9] = "byte",
    },
    [1]    = "alo\
123\"",
    [2]    = "'",
}
CHECK[['\xff']]
{
    type   = "string",
    start  = 0,
    finish = 6,
    escs   = {
        [1] = 1,
        [2] = 6,
        [3] = "byte",
    },
    [1]    = "\xff",
    [2]    = "'",
}
CHECK[['\x1A']]
{
    type   = "string",
    start  = 0,
    finish = 6,
    escs   = {
        [1] = 1,
        [2] = 6,
        [3] = "byte",
    },
    [1]    = "\26",
    [2]    = "'",
}
CHECK[['\492']]
{
    type   = "string",
    start  = 0,
    finish = 6,
    escs   = {
        [1] = 1,
        [2] = 5,
        [3] = "byte",
    },
    [1]    = "",
    [2]    = "'",
}
CHECK[['\u{3b1}']]
{
    type   = "string",
    start  = 0,
    finish = 9,
    escs   = {
        [1] = 1,
        [2] = 9,
        [3] = "unicode",
    },
    [1]    = "α",
    [2]    = "'",
}
CHECK[['\u{0}']]
{
    type   = "string",
    start  = 0,
    finish = 7,
    escs   = {
        [1] = 1,
        [2] = 7,
        [3] = "unicode",
    },
    [1]    = "\0",
    [2]    = "'",
}
CHECK[['\u{ffffff}']]
{
    type   = "string",
    start  = 0,
    finish = 12,
    escs   = {
        [1] = 1,
        [2] = 12,
        [3] = "unicode",
    },
    [1]    = "",
    [2]    = "'",
}
CHECK[=[[[
abcdef]]]=]
{
    type   = "string",
    start  = 0,
    finish = 10008,
    [1]    = "abcdef",
    [2]    = "[[",
}
CHECK[['aaa]]
{
    type   = "string",
    start  = 0,
    finish = 4,
    [1]    = "aaa",
    [2]    = "'",
}
CHECK[['aaa
]]
{
    type   = "string",
    start  = 0,
    finish = 4,
    [1]    = "aaa",
    [2]    = "'",
}
CHECK[[`12345`]]
{
    type   = "string",
    start  = 0,
    finish = 7,
    [1]    = "12345",
    [2]    = "`",
}
