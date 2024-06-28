local class = require 'class'

local function TEST(code)
    return function (expect)
        ---@class LuaParser.Ast
        local ast = New 'LuaParser.Ast' (code)
        local node = ast:parseLocal()
        assert(node)
        Match(node, expect)
    end
end

TEST [[local x]]
{
    left    = 0,
    finish  = 7,
    vars    = {
        [1] = {
            start   = 6,
            finish  = 7,
            id      = 'x',
            index   = 1,
        },
    },
}

TEST [[local x, y, z]]
{
    left    = 0,
    finish  = 13,
    vars    = {
        [1] = {
            start   = 6,
            finish  = 7,
            id      = 'x',
            index   = 1,
        },
        [2] = {
            start   = 9,
            finish  = 10,
            id      = 'y',
            index   = 2,
        },
        [3] = {
            start   = 12,
            finish  = 13,
            id      = 'z',
            index   = 3,
        },
    },
}

TEST [[local x = 1]]
{
    left    = 0,
    finish  = 11,
    vars    = {
        [1] = {
            start   = 6,
            finish  = 7,
            id      = 'x',
            value   = {
                start   = 10,
                finish  = 11,
                value   = 1,
            }
        },
    },
    values  = {
        [1] = {
            start   = 10,
            finish  = 11,
            value   = 1,
        },
    }
}

TEST [[local x, y = 1, 2, 3]]
{
    left    = 0,
    finish  = 20,
    vars    = {
        [1] = {
            start   = 6,
            finish  = 7,
            id      = 'x',
            value   = {
                start   = 13,
                finish  = 14,
                value   = 1,
            }
        },
        [2] = {
            start   = 9,
            finish  = 10,
            id      = 'y',
            value   = {
                start   = 16,
                finish  = 17,
                value   = 2,
            }
        },
    },
    values  = {
        [1] = {
            start   = 13,
            finish  = 14,
            value   = 1,
        },
        [2] = {
            start   = 16,
            finish  = 17,
            value   = 2,
        },
        [3] = {
            start   = 19,
            finish  = 20,
            value   = 3,
        },
    }
}

TEST [[local x <const>, y < close > = 1, 2]]
{
    vars    = {
        [1] = {
            id   = 'x',
            attr = {
                start     = 8,
                finish    = 15,
                symbolPos = 14,
                name      = {
                    start  = 9,
                    finish = 14,
                    id     = 'const',
                }
            }
        },
        [2] = {
            id = 'y',
            attr = {
                start     = 19,
                finish    = 28,
                symbolPos = 27,
                name      = {
                    start  = 21,
                    finish = 26,
                    id     = 'close',
                }
            }
        },
    },
}
