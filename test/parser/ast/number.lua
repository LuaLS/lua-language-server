local class = require 'class'

local function TEST(code)
    return function (expect)
        ---@class LuaParser.Ast
        local ast = class.new 'LuaParser.Ast' (code)
        local node = ast:parseNumber()
        assert(node)
        Match(node, expect)
    end
end

TEST '345'
{
    left    = 0,
    right   = 3,
    value   = 345,
    numBase = 10,
    toString= '345',
}
TEST '345.0'
{
    left    = 0,
    right   = 5,
    value   = 0x1.59p+8,
    numBase = 10,
    toString= '345.0',
}
TEST '0xff'
{
    left    = 0,
    right   = 4,
    value   = 255,
    numBase = 16,
    toString= '255',
}
TEST '314.16e-2'
{
    left    = 0,
    right   = 9,
    value   = 3.1416,
    numBase = 10,
    toString= '3.1416',
}
TEST '0.31416E1'
{
    left    = 0,
    right   = 9,
    value   = 0x1.921ff2e48e8a7p+1,
    numBase = 10,
    toString= '3.1416',
}
TEST '.31416E1'
{
    left    = 0,
    right   = 8,
    value   = 0x1.921ff2e48e8a7p+1,
    numBase = 10,
    toString= '3.1416',
}
TEST '34e1'
{
    left    = 0,
    right   = 4,
    value   = 0x1.54p+8,
    numBase = 10,
    toString= '340.0',
}
TEST '0x0.1E'
{
    left    = 0,
    right   = 6,
    value   = 0x1.ep-4,
    numBase = 16,
    toString= '0.1171875',
}
TEST '0xA23p-4'
{
    left    = 0,
    right   = 8,
    value   = 0x1.446p+7,
    numBase = 16,
    toString= '162.1875'
}
TEST '0X1.921FB54442D18P+1'
{
    left    = 0,
    right   = 20,
    value   = 0x1.921fb54442d18p+1,
    numBase = 16,
    toString= '3.1415926536'
}
TEST '-345'
{
    left    = 0,
    right   = 4,
    value   = -345,
    numBase = 10,
    toString= '-345',
}
TEST '0b110110'
{
    left    = 0,
    right   = 8,
    value   = 54,
    numBase = 2,
    toString= '54',
}
TEST '123ll'
{
    left    = 0,
    right   = 5,
    value   = 123,
    numBase = 10,
    toString= '123LL',
}
TEST '123ull'
{
    left    = 0,
    right   = 6,
    value   = 123,
    numBase = 10,
    toString= '123ULL',
}
TEST '123llu'
{
    left    = 0,
    right   = 6,
    value   = 123,
    numBase = 10,
    toString= '123ULL',
}
TEST '123i'
{
    left    = 0,
    right   = 4,
    value   = 0,
    valuei  = 123,
    numBase = 10,
    toString= '0+123i',
}
TEST '123.45i'
{
    left    = 0,
    right   = 7,
    value   = 0,
    valuei  = 123.45,
    numBase = 10,
    toString= '0+123.45i',
}
