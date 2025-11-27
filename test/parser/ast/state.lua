local class = require 'class'

local function TEST(code)
    return function (expect)
        ---@class LuaParser.Ast
        local ast = class.new 'LuaParser.Ast' (code)
        local node = ast:parseState()
        assert(node)
        Match(node, expect)
    end
end

TEST [[local x, y = 1, 2, 3]]
{
    type    = 'LocalDef',
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
    type    = 'Assign',
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
    type = 'Assign',
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
    type = 'Call',
}

TEST [[x.y().z = 1]]
{
    type = 'Assign',
    symbolPos = 8,
    exps = {
        [1] = {
            subtype = 'field',
            last    = {
                type   = 'Call',
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
            type = 'Call',
        },
        [2] = {
            type  = 'Select',
            index = 2,
            value = {
                type = 'Call',
            },
        },
    }
}

TEST [[x, y = call()]]
{
    values = {
        [1] = {
            type = 'Call',
        },
        [2] = {
            type  = 'Select',
            index = 2,
            value = {
                type = 'Call',
            },
        },
    }
}

TEST [[x, y = (call())]]
{
    values = {
        [1] = {
            type = 'Paren'
        },
        [2] = NIL,
    }
}

TEST [[x, y, z = call(), nil]]
{
    values = {
        [1] = {
            type = 'Call'
        },
        [2] = {
            type = 'Nil'
        }
    }
}

TEST [[x, y = ...]]
{
    values = {
        [1] = {
            type = 'Varargs'
        },
        [2] = {
            type = 'Select',
            index = 2,
            value = {
                type = 'Varargs',
            }
        }
    }
}

TEST [[x, y = ..., nil]]
{
    values = {
        [1] = {
            type = 'Varargs'
        },
        [2] = {
            type = 'Nil',
        }
    }
}

TEST [[x, y = (...)]]
{
    values = {
        [1] = {
            type = 'Paren',
            exp = {
                type = 'Varargs',
            },
        },
        [2] = NIL,
    }
}

TEST [[:: continue ::]]
{
    type   = 'Label',
    start  = 0,
    finish = 14,
    name   = {
        start  = 3,
        finish = 11,
        id     = 'continue',
    }
}

TEST [[goto continue]]
{
    type   = 'Goto',
    start  = 0,
    finish = 13,
    name   = {
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
    type  = 'Do',
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
    type   = 'If',
    left   = 0,
    right  = 30003,
    childs = {
        [1] = {
            type    = 'IfChild',
            subtype = 'if',
            condition = {
                id = 'x',
            },
        },
        [2] = {
            type    = 'IfChild',
            subtype = 'elseif',
            condition = {
                id = 'y',
            },
        },
        [3] = {
            type    = 'IfChild',
            subtype = 'else',
        },
    }
}

TEST [[break]]
{
    type   = 'Break',
    start  = 0,
    finish = 5,
}

TEST [[return]]
{
    type   = 'Return',
    start  = 0,
    finish = 6,
}

TEST [[return 1, 2, 3]]
{
    type   = 'Return',
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
    type   = 'For',
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
    type   = 'For',
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
            type = 'Nil',
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
    type   = 'While',
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
    type   = 'Repeat',
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
    type   = 'Function',
    name   = {
        type = 'Var',
        id   = 'f'
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

TEST [[
function f.n(x, y)
end
]]
{
    type   = 'Function',
    name   = {
        type = 'Field',
        last = {
            id = 'f'
        },
        key  = {
            id = 'n',
        },
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

TEST [[
local f = function (x, y)
end
]]
{
    type   = 'LocalDef',
    vars   = {
        [1] = {
            id = 'f',
        }
    },
    values = {
        [1] = {
            type   = 'Function',
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
    type   = 'Function',
    name   = {
        type = 'Local',
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
