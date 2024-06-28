local class = require 'class'

local function TEST(code)
    return function (expect)
        ---@class LuaParser.Ast
        local ast = class.new 'LuaParser.Ast' (code)
        local node = ast:parseComment()
        assert(node)
        Match(node, expect)
    end
end

TEST [[--AAA]]
{
    left    = 0,
    right   = 5,
    subtype = 'short',
    value   = 'AAA',
}

TEST [[//AAA]]
{
    left    = 0,
    right   = 5,
    subtype = 'short',
    value   = 'AAA',
}

TEST [===[--[[
1234
]]]===]
{
    left    = 0,
    right   = 20002,
    subtype = 'long',
    value   = '\n1234\n',
}

TEST [===[/*
1234
*/]===]
{
    left    = 0,
    right   = 20002,
    subtype = 'long',
    value   = '\n1234\n',
}
