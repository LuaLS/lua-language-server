local function TEST(code)
    return function (expect)
        local ast = New 'LuaParser.Ast' (code)
        local node = ast:parseMain()
        assert(node)
        Match(node, expect)
    end
end

TEST [[
---@class A
---@field a string
---@field b 1
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
                kind = 'catclass',
                classID = {
                    kind = 'catid',
                    id   = 'A',
                },
            }
        },
        [2] = {
            kind  = 'cat',
            value = {
                kind = 'catfield',
                key  = {
                    kind = 'catfieldname',
                    id   = 'a',
                },
                value = {
                    kind = 'catid',
                    id   = 'string',
                }
            }
        },
        [3] = {
            kind  = 'cat',
            value = {
                kind = 'catfield',
                key  = {
                    kind = 'catfieldname',
                    id   = 'b',
                },
                value = {
                    kind  = 'catinteger',
                    value = 1,
                }
            }
        }
    }
}

TEST [[
---@alias A 1
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
                kind = 'catalias',
                aliasID = {
                    kind = 'catid',
                    id   = 'A',
                },
                extends = {
                    kind  = 'catinteger',
                    value = 1,
                }
            }
        }
    }
}

TEST [[
---@type A
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
                kind = 'cattype',
                exp  = {
                    kind = 'catid',
                    id   = 'A',
                }
            }
        }
    }
}

TEST [[
---@type {
--- x: number,
--- y: number,
--- [number]: boolean,
---}
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
                kind = 'cattype',
                exp  = {
                    kind = 'cattable',
                    fields = {
                        [1] = {
                            subtype = 'field',
                            key = { id = 'x' },
                            value = { id = 'number' },
                        },
                        [2] = {
                            subtype = 'field',
                            key = { id = 'y' },
                            value = { id = 'number' },
                        },
                        [3] = {
                            subtype = 'index',
                            key = { id = 'number' },
                            value = { id = 'boolean' },
                        },
                    }
                }
            }
        }
    }
}

TEST [[
---@type [1, 2, 3]
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
                kind = 'cattype',
                exp  = {
                    kind = 'cattuple',
                    exps = {
                        [1] = { kind = 'catinteger', value = 1 },
                        [2] = { kind = 'catinteger', value = 2 },
                        [3] = { kind = 'catinteger', value = 3 },
                    }
                }
            }
        }
    }
}

TEST [[
---@type string[3][4]
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
                kind = 'cattype',
                exp  = {
                    kind = 'catarray',
                    size = {
                        kind = 'catinteger',
                        value = 4,
                    },
                    node = {
                        kind = 'catarray',
                        size = {
                            kind = 'catinteger',
                            value = 3,
                        },
                        node = {
                            kind = 'catid',
                            id = 'string',
                        }
                    }
                }
            }
        }
    }
}

TEST [[
---@type A<number, boolean>
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
                kind = 'cattype',
                exp  = {
                    kind = 'catcall',
                    node = { kind = 'catid', id = 'A' },
                    args = {
                        [1] = { kind = 'catid', id = 'number' },
                        [2] = { kind = 'catid', id = 'boolean' },
                    }
                }
            }
        },
    }
}

TEST [[
---@type async fun<T1: table, T2>(a: T1, ...: T2)
---: T2[]
---, desc: string
---, ...: T1
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
                kind = 'cattype',
                exp  = {
                    kind  = 'catfunction',
                    async = true,
                    generics = {
                        [1] = {
                            kind = 'catgeneric',
                            id   = { kind = 'catid', id = 'T1' },
                            extends = { kind = 'catid', id = 'table' },
                        },
                        [2] = {
                            kind = 'catgeneric',
                            id   = { kind = 'catid', id = 'T2' },
                        },
                    },
                    params = {
                        [1] = {
                            kind = 'catfuncparam',
                            index = 1,
                            name = {
                                kind = 'catfuncparamname',
                                id   = 'a',
                            },
                            value = { kind = 'catid', id = 'T1', generic = {} },
                        },
                        [2] = {
                            kind = 'catfuncparam',
                            index = 2,
                            name = {
                                kind = 'catfuncparamname',
                                id   = '...',
                            },
                            value = { kind = 'catid', id = 'T2', generic = {} },
                        },
                    },
                    returns = {
                        [1] = {
                            kind = 'catfuncreturn',
                            index = 1,
                            value = { kind = 'catarray' }
                        },
                        [2] = {
                            kind = 'catfuncreturn',
                            index = 2,
                            name = { kind = 'catfuncreturnname', id = 'desc' },
                            value = { kind = 'catid', id = 'string' },
                        },
                        [3] = {
                            kind = 'catfuncreturn',
                            index = 3,
                            name = { kind = 'catfuncreturnname', id = '...' },
                            value = { kind = 'catid', id = 'T1', generic = {} },
                        }
                    }
                }
            }
        },
    }
}

TEST [[
---@alias A<T> `T`
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
                kind = 'catalias',
                aliasID = {
                    kind = 'catid',
                    id   = 'A',
                },
                extends = {
                    kind = 'catid',
                    id   = '`T`',
                    genericTemplate = { T = {} },
                }
            }
        }
    }
}
