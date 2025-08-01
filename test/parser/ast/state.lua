local class = require 'class'

local function TEST(code)
    return function (expect)
        ---@class LuaParser.Ast
        local ast = New 'LuaParser.Ast' (code)
        local node = ast:parseState()
        assert(node)
        Match(node, expect)
    end
end

TEST [[local x, y = 1, 2, 3]]
{
    kind    = 'localdef',
    start   = 0,
    finish  = 20,
    symbolPos = 11,
    vars    = {
        [1] = {
            id      = 'x',
            value   = {
                value   = 1,
            }
        },
        [2] = {
            id      = 'y',
            value   = {
                value   = 2,
            }
        },
    },
    values  = {
        [1] = {
            value   = 1,
        },
        [2] = {
            value   = 2,
        },
        [3] = {
            value   = 3,
        },
    }
}

TEST [[x = 1]]
{
    kind    = 'assign',
    start   = 0,
    finish  = 5,
    symbolPos = 2,
    exps    = {
        [1] = {
            start   = 0,
            finish  = 1,
            id      = 'x',
            value   = {
                value   = 1,
            }
        },
    },
    values  = {
        [1] = {
            value   = 1,
        },
    }
}

TEST [[x.x, y.y = 1, 2, 3]]
{
    kind = 'assign',
    symbolPos = 9,
    exps = {
        [1] = {
            subtype = 'field',
            last    = {
                id = 'x',
            },
            key     = {
                id = 'x',
            },
            value   = {
                value = 1,
            },
        },
        [2] = {
            subtype = 'field',
            key     = {
                id = 'y',
            },
            value   = {
                value = 2,
            },
        },
    },
    values = {
        [1] = {
            value = 1,
        },
        [2] = {
            value = 2,
        },
        [3] = {
            value = 3,
        },
    },
}

TEST [[x.y()]]
{
    kind = 'call',
}

TEST [[x.y().z = 1]]
{
    kind = 'assign',
    symbolPos = 8,
    exps = {
        [1] = {
            subtype = 'field',
            last    = {
                kind   = 'call',
            },
            key     = {
                id = 'z',
            },
            value   = {
                value = 1,
            },
        },
    },
    values = {
        [1] = {
            value = 1,
        }
    }
}

TEST [[local x, y = call()]]
{
    values = {
        [1] = {
            kind = 'select',
            index = 1,
            value = {
                kind = 'call'
            },
        },
        [2] = {
            kind  = 'select',
            index = 2,
            value = {
                kind = 'call',
            },
        },
    }
}

TEST [[x, y = call()]]
{
    values = {
        [1] = {
            kind  = 'select',
            index = 1,
            value = {
                kind = 'call',
            },
        },
        [2] = {
            kind  = 'select',
            index = 2,
            value = {
                kind = 'call',
            },
        },
    }
}

TEST [[x, y = (call())]]
{
    values = {
        [1] = {
            kind = 'paren',
            exp = {
                kind = 'select',
            }
        },
        [2] = NIL,
    }
}

TEST [[x, y, z = call(), nil]]
{
    values = {
        [1] = {
            kind = 'select'
        },
        [2] = {
            kind = 'nil'
        }
    }
}

TEST [[x, y = ...]]
{
    values = {
        [1] = {
            kind = 'select',
            index = 1,
            value = {
                kind = 'varargs',
            }
        },
        [2] = {
            kind = 'select',
            index = 2,
            value = {
                kind = 'varargs',
            }
        }
    }
}

TEST [[x, y = ..., nil]]
{
    values = {
        [1] = {
            kind = 'select'
        },
        [2] = {
            kind = 'nil',
        }
    }
}

TEST [[x, y = (...)]]
{
    values = {
        [1] = {
            kind = 'paren',
            exp = {
                kind = 'select',
            },
        },
        [2] = NIL,
    }
}

TEST [[:: continue ::]]
{
    kind   = 'label',
    start  = 0,
    finish = 14,
    symbolPos = 12,
    name   = {
        start  = 3,
        finish = 11,
        id     = 'continue',
    }
}

TEST [[goto continue]]
{
    kind   = 'goto',
    start  = 0,
    finish = 13,
    name  = {
        start  = 5,
        finish = 13,
        id     = 'continue',
    }
}

TEST [[
do
end
]]
{
    kind  = 'do',
    left  = 0,
    right = 10003,
    symbolPos = 3,
}

TEST [[
if x then
elseif y then
else
end
]]
{
    kind   = 'if',
    left   = 0,
    right  = 30003,
    childs = {
        [1] = {
            kind    = 'ifchild',
            subtype = 'if',
            condition = {
                id = 'x',
            },
        },
        [2] = {
            kind    = 'ifchild',
            subtype = 'elseif',
            condition = {
                id = 'y',
            },
        },
        [3] = {
            kind    = 'ifchild',
            subtype = 'else',
        },
    }
}

TEST [[break]]
{
    kind   = 'break',
    start  = 0,
    finish = 5,
}

TEST [[return]]
{
    kind   = 'return',
    start  = 0,
    finish = 6,
}

TEST [[return 1, 2, 3]]
{
    kind   = 'return',
    start  = 0,
    finish = 14,
    exps   = {
        [1] = {
            start  = 7,
            finish = 8,
            value  = 1,
        },
        [2] = {
            start  = 10,
            finish = 11,
            value  = 2,
        },
        [3] = {
            start  = 13,
            finish = 14,
            value  = 3,
        }
    }
}

TEST [[
for i = 1, 10, 1 do
end
]]
{
    kind   = 'for',
    subtype= 'loop',
    left   = 0,
    right  = 10003,
    vars    = {
        [1] = {
            id = 'i',
        },
    },
    exps   = {
        [1] = {
            value = 1,
        },
        [2] = {
            value = 10,
        },
        [3] = {
            value = 1,
        }
    },
    symbolPos1 = 6,
    symbolPos2 = 17,
    symbolPos3 = 20,
}

TEST [[
for k, v in next, t, nil do
end
]]
{
    kind   = 'for',
    subtype= 'in',
    left   = 0,
    right  = 10003,
    vars   = {
        [1] = {
            id = 'k',
        },
        [2] = {
            id = 'v',
        },
    },
    exps   = {
        [1] = {
            id = 'next',
        },
        [2] = {
            id = 't',
        },
        [3] = {
            kind = 'nil',
        }
    },
    symbolPos1 = 9,
    symbolPos2 = 25,
    symbolPos3 = 28,
}

TEST [[
while true do
end
]]
{
    kind   = 'while',
    left   = 0,
    right  = 10003,
    condition = {
        value = true,
    },
    symbolPos1 = 11,
    symbolPos2 = 14,
}

TEST [[
repeat
until false
]]
{
    kind   = 'repeat',
    left   = 0,
    right  = 10011,
    symbolPos = 7,
    condition = {
        value = false,
    },
}

TEST [[
function f(x, y)
end
]]
{
    kind   = 'var',
    id     = 'f',
    value  = {
        kind = 'function',
        name = {
            id = 'f',
        },
        params = {
            [1] = {
                id = 'x'
            },
            [2] = {
                id = 'y'
            }
        }
    }
}

TEST [[
function f.n(x, y)
end
]]
{
    kind   = 'field',
    key    = {
        kind = 'fieldid',
        id = 'n',
    },
    last = {
        id = 'f'
    },
    value  = {
        kind   = 'function',
        name   = {
            kind = 'field',
        },
        params = {
            [1] = {
                id = 'x'
            },
            [2] = {
                id = 'y'
            }
        }
    }
}

TEST [[
local f = function (x, y)
end
]]
{
    kind   = 'localdef',
    vars   = {
        [1] = {
            id = 'f',
        }
    },
    values = {
        [1] = {
            kind   = 'function',
            params = {
                [1] = {
                    id = 'x'
                },
                [2] = {
                    id = 'y'
                }
            }
        }
    }
}

TEST [[
local function f(x, y)
end
]]
{
    kind   = 'function',
    name   = {
        kind = 'local',
        id   = 'f',
    },
    params = {
        [1] = {
            id = 'x'
        },
        [2] = {
            id = 'y'
        }
    }
}
