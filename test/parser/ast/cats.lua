local class = require 'class'

local function TEST(code)
    return function (expect)
        ---@class LuaParser.Ast
        local ast = class.new 'LuaParser.Ast' (code)
        local cat = ast:parseCat()
        Match(cat, expect)
    end
end

TEST [[
---@class A
]]
{
    subtype = 'class',
    start   = 0,
    finish  = 11,
    symbolPos = 3,
    value   = {
        start   = 10,
        finish  = 11,
        classID = {
            start  = 10,
            finish = 11,
            id     = 'A',
        },
    }
}

TEST [[
---@class(exact, what1, what2) A
]]
{
    subtype = 'class',
    start   = 0,
    finish  = 32,
    symbolPos = 3,
    attrPos1  = 9,
    attrPos2  = 29,
    attrs   = {
        [1] = {
            start  = 10,
            finish = 15,
            id     = 'exact',
        },
        [2] = {
            start  = 17,
            finish = 22,
            id     = 'what1',
        },
        [3] = {
            start  = 24,
            finish = 29,
            id     = 'what2',
        },
    },
    value   = {
        start   = 31,
        finish  = 32,
        classID = {
            start  = 31,
            finish = 32,
            id     = 'A',
        },
    }
}

TEST [[
---@class A: B
]]
{
    subtype = 'class',
    start   = 0,
    finish  = 14,
    symbolPos = 3,
    value   = {
        start   = 10,
        finish  = 14,
        classID = {
            start  = 10,
            finish = 11,
            id     = 'A',
        },
        symbolPos = 11,
        extends = {
            id     = 'B',
            start  = 13,
            finish = 14,
        }
    }
}

TEST [[
---@type string
]]
{
    subtype = 'type',
    start   = 0,
    finish  = 15,
    value   = {
        type   = 'CatID',
        id     = 'string',
        start  = 9,
        finish = 15,
    }
}

TEST [[
---@type (string)
]]
{
    subtype = 'type',
    start   = 0,
    finish  = 17,
    value   = {
        type   = 'CatParen',
        symbolPos = 16,
        start  = 9,
        finish = 17,
        value   = {
            type   = 'CatID',
            id     = 'string',
            start  = 10,
            finish = 16,
        }
    }
}

TEST [[
---@type string[]
]]
{
    subtype = 'type',
    start   = 0,
    finish  = 17,
    value   = {
        type   = 'CatArray',
        start  = 9,
        finish = 17,
        symbolPos1 = 15,
        symbolPos2 = 16,
        node   = {
            type   = 'CatID',
            id     = 'string',
            start  = 9,
            finish = 15,
        }
    }
}

TEST [[
---@type A<boolean, string>
]]
{
    subtype = 'type',
    start   = 0,
    finish  = 27,
    value   = {
        type   = 'CatCall',
        start  = 9,
        finish = 27,
        symbolPos1 = 10,
        symbolPos2 = 26,
        node   = {
            id = 'A',
        },
        args   = {
            [1] = {
                id = 'boolean',
            },
            [2] = {
                id = 'string',
            }
        },
    }
}

TEST [[
---@type A | B | C
]]
{
    subtype = 'type',
    start   = 0,
    finish  = 18,
    value   = {
        type   = 'CatUnion',
        start  = 9,
        finish = 18,
        poses  = {11, 15},
        exps   = {
            [1] = {
                id = 'A',
            },
            [2] = {
                id = 'B',
            },
            [3] = {
                id = 'C',
            }
        }
    }
}

TEST [[
---@type A & B | C & D & E | F
]]
{
    subtype = 'type',
    value   = {
        type   = 'CatUnion',
        exps   = {
            [1] = {
                type = 'CatCross',
                exps = {
                    [1] = {
                        id = 'A',
                    },
                    [2] = {
                        id = 'B',
                    }
                }
            },
            [2] = {
                type = 'CatCross',
                exps = {
                    [1] = {
                        id = 'C',
                    },
                    [2] = {
                        id = 'D',
                    },
                    [3] = {
                        id = 'E',
                    },
                }
            },
            [3] = {
                type = 'CatID',
                id   = 'F',
            }
        }
    }
}

TEST [[
---@type fun()
]]
{
    value = {
        type   = 'CatFunction',
        start  = 9,
        finish = 14,
    }
}

TEST [[
---@type async fun()
]]
{
    value = {
        type   = 'CatFunction',
        start  = 9,
        finish = 20,
        async  = true,
        funPos = 15,
    }
}

TEST [[
---@type fun(x, y, ...)
]]
{
    value = {
        type   = 'CatFunction',
        finish = 23,
        symbolPos1 = 12,
        symbolPos2 = 22,
        params     = {
            [1] = {
                name = {
                    id = 'x'
                }
            },
            [2] = {
                name = {
                    id = 'y'
                }
            },
            [3] = {
                name = {
                    id = '...'
                }
            }
        },
    }
}

TEST [[
---@type fun(x: number, y: number)
]]
{
    value = {
        params = {
            [1] = {
                name = { id = 'x' },
                value = { id = 'number' },
            },
            [2] = {
                name = { id = 'y' },
                value = { id = 'number' },
            }
        }
    }
}

TEST [[
---@type fun(): number, boolean, ...
]]
{
    value = {
        returns = {
            [1] = {
                value = {
                    id = 'number'
                }
            },
            [2] = {
                value = {
                    id = 'boolean',
                }
            },
            [3] = {
                name = {
                    id = '...'
                }
            }
        }
    }
}

TEST [[
---@type fun(): r1: number, r2: boolean, ...: string
]]
{
    value = {
        returns = {
            [1] = {
                name = {
                    id = 'r1'
                },
                value = {
                    id = 'number'
                }
            },
            [2] = {
                name = {
                    id = 'r2'
                },
                value = {
                    id = 'boolean',
                }
            },
            [3] = {
                name = {
                    id = '...'
                },
                value = {
                    id ='string'
                }
            }
        }
    }
}

TEST [[
---@type fun(): (r1: number, r2: boolean, ...: string)
]]
{
    value = {
        returns = {
            [1] = {
                name = {
                    id = 'r1'
                },
                value = {
                    id = 'number'
                }
            },
            [2] = {
                name = {
                    id = 'r2'
                },
                value = {
                    id = 'boolean',
                }
            },
            [3] = {
                name = {
                    id = '...'
                },
                value = {
                    id ='string'
                }
            }
        }
    }
}

TEST [[
---@type fun()
---: number
]]
{
    value = {
        returns = {
            [1] = {
                value = {
                    id = 'number'
                },
            }
        }
    },
}

TEST [[
---@type { x: number, y, [integer]: boolean, ...: number }
]]
{
    value = {
        fields = {
            [1] = {
                subtype = 'field',
                key     = {
                    id = 'x',
                },
                value   = {
                    id = 'number',
                }
            },
            [2] = {
                subtype = 'field',
                key     = {
                    id = 'y',
                },
                value   = NIL,
            },
            [3] = {
                subtype = 'index',
                key     = {
                    id = 'integer',
                },
                value   = {
                    id = 'boolean',
                }
            },
            [4] = {
                subtype = 'field',
                key     = {
                    id = '...',
                },
                value   = {
                    id = 'number',
                }
            }
        }
    },
}

TEST [[
---@type true | false | 1 | -1 | 'abc' | "abc"
]]
{
    value = {
        exps = {
            [1] = {
                value = true
            },
            [2] = {
                value = false
            },
            [3] = {
                value = 1
            },
            [4] = {
                value = -1
            },
            [5] = {
                value = 'abc'
            },
            [6] = {
                value = "abc"
            },
        }
    }
}

TEST [[
---@unknown
]]
{
    subtype = 'unknown',
}
