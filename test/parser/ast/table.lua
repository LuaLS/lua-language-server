local class = require 'class'

local function TEST(code)
    return function (expect)
        ---@class LuaParser.Ast
        local ast = New 'LuaParser.Ast' (code)
        local node = ast:parseTable()
        assert(node)
        Match(node, expect)
    end
end

TEST '{}'
{
    start  = 0,
    finish = 2,
}

TEST '{...}'
{
    start  = 0,
    finish = 5,
    fields = {
        [1] = {
            subtype = 'exp',
            start = 1,
            finish = 4,
            key = {
                dummy = true,
                value = 1,
            },
            value = {
                start  = 1,
                finish = 4,
            },
        }
    }
}
TEST '{1, 2, 3}'
{
    start  = 0,
    finish = 9,
    fields = {
        [1]    = {
            subtype = 'exp',
            start  = 1,
            finish = 2,
            key    = {
                dummy = true,
                value = 1,
            },
            value  = {
                value  = 1,
            },
        },
        [2]    = {
            subtype = 'exp',
            start  = 4,
            finish = 5,
            key    = {
                dummy = true,
                value = 2,
            },
            value  = {
                value  = 2,
            },
        },
        [3]    = {
            subtype = 'exp',
            start  = 7,
            finish = 8,
            key    = {
                dummy = true,
                value = 3,
            },
            value  = {
                value  = 3,
            },
        },
    }
}

TEST '{x = 1, y = 2}'
{
    start  = 0,
    finish = 14,
    fields = {
        [1] = {
            subtype = 'field',
            start   = 1,
            finish  = 6,
            key     = {
                id = 'x',
            },
            value   = {
                value = 1,
            },
        },
        [2] = {
            subtype = 'field',
            start   = 8,
            finish  = 13,
            key     = {
                id = 'y',
            },
            value   = {
                value = 2,
            },
        },
    }
}

TEST '{["x"] = 1, ["y"] = 2}'
{
    start  = 0,
    finish = 22,
    fields = {
        [1] = {
            subtype    = 'index',
            symbolPos  = 1,
            symbolPos2 = 5,
            key        = {
                __class__ = 'LuaParser.Node.String',
                value     = 'x',
            },
            value      = {
                value = 1,
            }
        },
        [2] = {
            subtype    = 'index',
            symbolPos  = 12,
            symbolPos2 = 16,
            key        = {
                __class__ = 'LuaParser.Node.String',
                value     = 'y',
            },
            value      = {
                value = 2,
            }
        },
    }
}

TEST '{[x] = 1, [y] = 2}'
{
    start  = 0,
    finish = 18,
    fields = {
        [1] = {
            subtype = 'index',
            key     = {
                __class__ = 'LuaParser.Node.Var',
                id        = 'x',
            }
        },
        [2] = {
            subtype = 'index',
            key     = {
                __class__ = 'LuaParser.Node.Var',
                id        = 'y',
            }
        },
    }
}

TEST '{x = 1, y = 2, 3}'
{
    start  = 0,
    finish = 17,
    fields = {
        [1] = {
            subtype = 'field'
        },
        [2] = {
            subtype = 'field'
        },
        [3] = {
            subtype = 'exp',
            key     = {
                dummy = true,
                value = 1,
            }
        },
    }
}

TEST '{{}}'
{
    start  = 0,
    finish = 4,
    fields = {
        [1] = {
            subtype = 'exp',
            key     = {
                dummy = true,
                value = 1,
            },
            value   = {
                __class__ = 'LuaParser.Node.Table',
                start  = 1,
                finish = 3,
            }
        }
    }
}

TEST '{ a = { b = { c = {} } } }'
{
    fields = {
        [1] = {
            subtype = 'field',
            key = {
                id = 'a',
            },
            value = {
                fields = {
                    [1] = {
                        subtype = 'field',
                        key = {
                            id = 'b',
                        },
                        value = {
                            fields = {
                                [1] = {
                                    subtype = 'field',
                                    key = {
                                        id = 'c',
                                    },
                                    value = {
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

TEST '{{}, {}, {{}, {}}}'
{
    fields = {
        [1] = {
            subtype = 'exp',
        },
        [2] = {
            subtype = 'exp',
        },
        [3] = {
            subtype = 'exp',
            value = {
                fields = {
                    [1] = {
                        subtype = 'exp',
                    },
                    [2] = {
                        subtype = 'exp',
                    },
                }
            }
        }
    }
}

TEST '{1, 2, 3,}'
{
    fields = {
        [1] = {
            subtype = 'exp',
            key = {
                dummy = true,
                value = 1,
            },
            value = {
                value = 1,
            }
        },
        [2] = {
            subtype = 'exp',
            key = {
                dummy = true,
                value = 2,
            },
            value = {
                value = 2,
            }
        },
        [3] = {
            subtype = 'exp',
            key = {
                dummy = true,
                value = 3,
            },
            value = {
                value = 3,
            }
        },
    }
}

TEST [=[
{
[[]]
}]=]
{
    fields = {
        [1] = {
            subtype = 'exp',
            key = {
                dummy = true,
                value = 1,
            },
            value = {
                __class__ = 'LuaParser.Node.String',
                value = '',
            }
        }
    }
}

TEST [[
{
    [xxx]
}
]]
{
    fields = {
        [1] = {
            subtype = 'index',
            key = {
                __class__ = 'LuaParser.Node.Var',
                id = 'xxx',
            },
        }
    }
}
