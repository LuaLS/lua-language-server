local class = require 'class'

---@param code string
---@param optional? LuaParser.CompileOptions
---@return fun(table)
local function TEST(code, optional)
    return function (expect)
        local ast = class.new 'LuaParser.Ast' (code, nil, optional)
        local main = ast:parseMain()
        assert(main)
        Match(main, expect)
    end
end

TEST ''
{
    type   = 'Main',
    start  = 0,
    finish = 0,
}

TEST ';;;'
{
    start  = 0,
    finish = 3,
}

TEST ';;;x = 1'
{
    locals = {
        [1] = {
            id = '...',
            dummy = true,
        },
        [2] = {
            id = '_ENV',
            dummy = true,
            envRefs  = {
                [1] = {
                    start = 3
                }
            }
        }
    },
    childs = {
        [1] = {
            type = 'Assign',
            exps = {
                [1] = {
                    id = 'x',
                    env = {
                        id    = '_ENV',
                        start = 0,
                    }
                }
            }
        }
    }
}

TEST ([[
local x = 1 // 2
]], {
    nonestandardSymbols = { '//' }
})
{
    childs = {
        [1] = {
            values = {
                [1] = {
                    type = 'Integer',
                }
            }
        }
    }
}

TEST ([[
local x = 1 // 2
]])
{
    childs = {
        [1] = {
            values = {
                [1] = {
                    type = 'Binary',
                    op   = '//'
                }
            }
        }
    }
}

TEST ([[
local x = {
    1, // BAD
    2, // GOOD
    3, // GOOD
}
]], {
    nonestandardSymbols = { '//' }
})
{
    childs = {
        [1] = {
            values = {
                [1] = {
                    type = 'Table',
                    fields = {
                        [1] = {
                            subtype = 'exp',
                            value  = {
                                value = 1,
                            }
                        },
                        [2] = {
                            subtype = 'exp',
                            value  = {
                                value = 2,
                            }
                        },
                        [3] = {
                            subtype = 'exp',
                            value  = {
                                value = 3,
                            }
                        }
                    }
                }
            }
        }
    }
}

TEST [[
local x
return {
    x = 1,
}
]]
{
    childs = {
        [2] = {
            exps = {
                [1] = {
                    type = 'Table',
                    fields = {
                        [1] = {
                            subtype = 'field',
                            key = {
                                id = 'x',
                                loc = NIL,
                            }
                        }
                    }
                }
            }
        }
    }
}

TEST [[
local x
a = {
    x
}
]]
{
    childs = {
        [2] = {
            values = {
                [1] = {
                    type = 'Table',
                    fields = {
                        [1] = {
                            subtype = 'exp',
                            value  = {
                                id = 'x',
                                loc = {
                                    left = 6
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

TEST [[
x = 1
local _ENV
x = 1
]]
{
    childs = {
        [1] = {
            exps = {
                [1] = {
                    loc = NIL,
                    env = {
                        left = 0,
                    }
                }
            }
        },
        [3] = {
            exps = {
                [1] = {
                    loc = NIL,
                    env = {
                        left = 10006,
                    }
                }
            }
        }
    }
}

TEST [[
local function f()
    print(f)
end
]]
{
    childs = {
        [1] = {
            childs = {
                [1] = {
                    type = 'Call',
                    args = {
                        [1] = {
                            id = 'f',
                            loc = {
                                left = 15,
                            }
                        },
                    }
                }
            }
        }
    }
}

TEST [[
local function a()
    return
end]]
{
    childs = {
        [1] = {
            type = 'Function',
            childs = {
                [1] = {
                    type = 'Return',
                    exps = {
                        [1] = NIL
                    }
                }
            }
        }
    }
}

TEST [[
local function f()
    return f
end
]]
{
    locals = {
        [3] = {
            id = 'f',
            gets = {
                [1] = {
                    left = 10011,
                }
            }
        }
    },
    childs = {
        [1] = {
            type = 'Function',
            childs = {
                [1] = {
                    type = 'Return',
                    exps = {
                        [1] = {
                            type = 'Var',
                            id   = 'f',
                            loc  = {
                                left = 15,
                            }
                        }
                    }
                }
            }
        }
    }
}
