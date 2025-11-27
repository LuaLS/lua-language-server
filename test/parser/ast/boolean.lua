local class = require 'class'

local function TEST(code)
    return function (expect)
        ---@class LuaParser.Ast
        local ast = class.new 'LuaParser.Ast' (code)
        local node = ast:parseBoolean()
        assert(node)
        Match(node, expect)
    end
end

TEST [[true]]
{
    left    = 0,
    finish  = 4,
    value   = true,
}
TEST [[false]]
{
    left    = 0,
    right   = 5,
    value   = false,
}
