local class = require 'class'

---@param code string
---@param optional? LuaParser.CompileOptions
---@return fun(table)
local function TEST(code, optional)
    return function (expect)
        local ast = New 'LuaParser.Ast' (code, 'test.optchain', optional)
        local main = ast:parseMain()
        assert(main)
        Match(main, expect)
    end
end

local OPT = { nonestandardSymbols = { '?.', '?:', '?[', '?(' } }

-- ?. 安全字段访问
TEST ([[
local x = a?.b
]], OPT)
{
    childs = {
        [1] = {
            kind   = 'localdef',
            values = {
                [1] = {
                    kind    = 'field',
                    subtype = 'field',
                    safe    = true,
                    key     = { id = 'b' },
                    last    = { id = 'a' },
                },
            }
        }
    }
}

-- ?. 链式访问
TEST ([[
local x = a?.b?.c
]], OPT)
{
    childs = {
        [1] = {
            kind = 'localdef',
            values = {
                [1] = {
                    kind    = 'field',
                    subtype = 'field',
                    safe    = true,
                    key     = { id = 'c' },
                    last    = {
                        kind    = 'field',
                        subtype = 'field',
                        safe    = true,
                        key     = { id = 'b' },
                        last    = { id = 'a' },
                    },
                },
            }
        }
    }
}

-- ?[ 无点号安全索引
TEST ([[
local x = a?[1]
]], OPT)
{
    childs = {
        [1] = {
            kind = 'localdef',
            values = {
                [1] = {
                    kind    = 'field',
                    subtype = 'index',
                    safe    = true,
                    last    = { id = 'a' },
                },
            }
        }
    }
}

-- ?( 无点号安全调用
TEST ([[
local x = a?()
]], OPT)
{
    childs = {
        [1] = {
            kind = 'localdef',
            values = {
                [1] = {
                    kind = 'select',
                    sindex = 1,
                    value = {
                        kind = 'call',
                        safe = true,
                        node = { id = 'a' },
                    },
                },
            }
        }
    }
}

-- ?: 无点号安全方法
TEST ([[
local x = a?:b()
]], OPT)
{
    childs = {
        [1] = {
            kind = 'localdef',
            values = {
                [1] = {
                    kind = 'select',
                    sindex = 1,
                    value = {
                        kind = 'call',
                        safe = true,
                        node = {
                            kind    = 'field',
                            subtype = 'method',
                            safe    = true,
                            key     = { id = 'b' },
                            last    = { id = 'a' },
                        },
                    },
                },
            }
        }
    }
}

-- 未启用 ?. 时应该报错
do
    local parser = require 'parser'
    local ast = parser.compile('local x = a?.b', 'test.optchain')
    local errs = ast.errors
    assert(#errs == 1)
    assert(errs[1].errorCode == 'ERR_NONSTANDARD_SYMBOL')
    assert(errs[1].extra and errs[1].extra.symbol == '?.')
end

-- 非法语法：a? 结尾报错
do
    local parser = require 'parser'
    local ast = parser.compile('local x = a?', 'test.optchain', OPT)
    assert(#ast.errors > 0)
end
