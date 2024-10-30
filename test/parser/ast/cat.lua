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
                kind = 'catid',
                id   = 'A',
            }
        }
    }
}

TEST [[
---@type {
--- x: number,
--- y: number,
--- [number]: boolean,
--- ...: string,
---}
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
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
                    [4] = {
                        subtype = 'field',
                        key = { id = '...' },
                        value = { id = 'string' },
                    },
                }
            }
        }
    }
}
