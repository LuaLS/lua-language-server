local parser = require 'parser'

local EXISTS = {}

local function eq(a, b)
    if a == EXISTS and b ~= nil then
        return true
    end
    local tp1, tp2 = type(a), type(b)
    if tp1 ~= tp2 then
        return false
    end
    if tp1 == 'table' then
        local mark = {}
        for k in pairs(a) do
            if not eq(a[k], b[k]) then
                return false
            end
            mark[k] = true
        end
        for k in pairs(b) do
            if not mark[k] then
                return false
            end
        end
        return true
    end
    return a == b
end

local function getLine(offset, lns)
    for i = 0, #lns do
        if  offset >= lns[i]
        and offset < lns[i+1] then
            return i
        end
    end
end

local function getPosition(offset, lns)
    for i = 0, #lns do
        if  offset >= lns[i]
        and offset < lns[i+1] then
            return 10000 * i + offset - lns[i]
        end
    end
end

---@param script string
---@param sep string
local function catchTarget(script, sep)
    local pattern = ('()<%%%s.-%%%s>()'):format(sep, sep)
    local lns = {}
    lns[0] = 0
    for pos in script:gmatch '()\n' do
        lns[#lns+1] = pos
    end
    lns[#lns+1] = math.maxinteger
    local codes = {}
    local pos   = 1
    ---@type [integer, integer][]
    local list = {}
    local cuted = 0
    local lastLine = 0
    for a, b in script:gmatch(pattern) do
        codes[#codes+1] = script:sub(pos, a - 1)
        codes[#codes+1] = script:sub(a + 2, b - 3)
        pos = b
        local line1 = getLine(a + 1, lns)
        if line1 ~= lastLine then
            cuted = 0
            lastLine = line1
        end
        cuted = cuted + 2
        local left = getPosition(a + 1, lns) - cuted
        local line2 = getLine(b - 3, lns)
        if line2 ~= lastLine then
            cuted = 0
            lastLine = line2
        end
        local right = getPosition(b - 3, lns) - cuted
        cuted = cuted + 2
        list[#list+1] = { left, right }
    end
    codes[#codes+1] = script:sub(pos)
    return table.concat(codes), list
end

local Version

local function TEST(script)
    return function (expect)
        local newScript, list = catchTarget(script, '!')
        local ast = parser.compile(newScript, 'Lua', Version)
        assert(ast)
        local errs = ast.errs
        local first = errs[1]
        local target = list[1]
        if not expect then
            assert(#errs == 0)
            return
        end
        if expect.multi then
            assert(#errs > 1)
            first = errs[expect.multi]
        else
            assert(#errs == 1)
        end
        assert(first)
        assert(first.type == expect.type)
        assert(first.start == target[1])
        assert(first.finish == target[2])
        assert(eq(expect.version, first.version))
        assert(eq(expect.info, first.info))
    end
end

Version = 'Lua 5.3'

TEST[[
local<!!>
]]
{
    type = 'MISS_NAME',
}

TEST[[
<!？？？!>
]]
{
    type = 'UNICODE_NAME',
}

TEST[[
n = 1<!a!>
]]
{
    type = 'MALFORMED_NUMBER',
}

TEST[[
s = 'a<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = "'",
    }
}

TEST[[
s = "a<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '"',
    }
}

TEST[======[
s = [[a<!!>]======]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ']]',
    }
}

TEST[======[
s = [===[a<!!>]======]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ']===]',
    }
}

TEST[======[
s = [===[a]=]<!!>]======]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ']===]',
    }
}

TEST[[
s = '\x<!zz!>zzz'
]]
{
    type = 'MISS_ESC_X',
}

TEST[[
s = '\u<!!>'
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '{'
    }
}

TEST[[
s = '\u<!{}!>'
]]
{
    type = 'UTF8_SMALL',
}

TEST[[
s = '\u<!{111111111}!>'
]]
{
    type = 'UTF8_MAX',
    info = {
        min = '000000',
        max = '10FFFF',
    }
}

TEST[[
s = '\u<!{ffffff}!>'
]]
{
    type = 'UTF8_MAX',
    version = {'Lua 5.4', 'Lua 5.5'},
    info = {
        min = '000000',
        max = '10FFFF',
    }
}

TEST[[
s = '\u{aaa<!!>'
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '}',
    }
}

TEST[[
s = '\u{abc<!z!>}'
]]
{
    type = 'MUST_X16',
}

TEST[[
s = '<!\c!>'
]]
{
    type = 'ERR_ESC',
}

TEST[[
s = '<!\ !>'
]]
{
    type = 'ERR_ESC',
}

TEST[[
s = '<!\555!>'
]]
{
    type = 'ERR_ESC',
}

TEST[[
n = 0x<!!>
]]
{
    type = 'MUST_X16',
}

TEST[[
n = 0x<!!>zzzz
]]
{
    type = 'MUST_X16',
    multi = 1,
}


TEST[[
n = 0x.<!!>zzzz
]]
{
    type = 'MUST_X16',
    multi = 1,
}

TEST[[
t = {<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '}',
    }
}

TEST[[
t = {1<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '}',
    }
}

TEST[[
t = {1,<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '}',
    }
}

TEST[[
t = {name =<!!>}
]]
{
    type = 'MISS_EXP',
}

TEST[[
t = {['name'] =<!!>}
]]
{
    type = 'MISS_EXP',
}

TEST[[
t = {['name']<!!>}
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '=',
    }
}

TEST[[
t = {[<!!>]=1}
]]
{
    type = 'MISS_EXP',
}

TEST[[
t = {<!!>,}
]]
{
    type = 'MISS_EXP',
}

TEST[[
t = {1<! !>2}
]]
{
    type = 'MISS_SEP_IN_TABLE',
}

TEST[[
f(<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ')',
    },
}

TEST[[
f(<!,!>1)
]]
{
    type = 'UNEXPECT_SYMBOL',
    info = {
        symbol = ',',
    }
}

TEST[[
f(1,<!!>)
]]
{
    type = 'MISS_EXP',
}

TEST[[
f(1<! !>1)
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ',',
    },
}

TEST[[
(<!!>).x()
]]
{
    type = 'MISS_EXP',
}

TEST[[
print(x<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ')',
    }
}

TEST[[
x.<!!>()
]]
{
    type = 'MISS_FIELD',
}

TEST[[
x:<!!>()
]]
{
    type = 'MISS_METHOD',
}

TEST[[
x[<!!>] = 1
]]
{
    type = 'MISS_EXP',
}

TEST[[
y = x[1<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ']',
    }
}

TEST[[
x:m<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '(',
    }
}

TEST[[
x = 1 and<!!>
]]
{
    type = 'MISS_EXP',
}

TEST[[
x = #<!!>
]]
{
    type = 'MISS_EXP',
}

TEST[[
local x = 1,<!!>
]]
{
    type = 'MISS_EXP',
}

TEST[[
local x,<!!> = 1, 2
]]
{
    type = 'MISS_NAME',
}

TEST[[
::<!!>
]]
{
    type = 'MISS_NAME',
}

TEST[[
::LABEL<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '::',
    }
}

TEST[[
goto<!!>
]]
{
    type = 'MISS_NAME',
}

TEST[[
return 1,<!!>
]]
{
    type = 'MISS_EXP',
}

TEST[[
local function<!!>() end
]]
{
    type = 'MISS_NAME',
}

TEST[[
function<!!>() end
]]
{
    type = 'MISS_NAME',
}

TEST[[
function f(<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = ')',
    }
}

TEST[[
function f<!!> end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '(',
    }
}

TEST[[
f = function (<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = ')',
    }
}

TEST[[
f = function<!!> end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '(',
    }
}

TEST[[
f = function <!f!>() end
]]
{
    type = 'UNEXPECT_EFUNC_NAME',
}

TEST[[
function f()<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'end',
        related = {
            {
                start  = 0,
                finish = 8,
            }
        },
    }
}

TEST[[
<!function!> f()
]]
{
    multi = 2,
    type = 'MISS_END',
}

TEST[[
function f:<!!>() end
]]
{
    type = 'MISS_METHOD',
}

TEST[[
function f:x<!!>.y() end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '(',
    }
}

TEST[[
function f(a,<!!>) end
]]
{
    type = 'MISS_NAME',
}

TEST[[
function f(<!!>,a) end
]]
{
    type = 'MISS_NAME',
}

TEST[[
function f(..., <!a!>) end
]]
{
    type = 'ARGS_AFTER_DOTS',
}

TEST[[
local x =<!!> ]]
{
    type = 'MISS_EXP',
}

TEST[[
x =<!!> ]]
{
    type = 'MISS_EXP',
}

TEST[[
for<!!> in next do
end
]]
{
    type = 'MISS_NAME',
}

TEST[[
for k, v<!!> do
end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'in',
    }
}

TEST[[
for k, v in<!!> do
end
]]
{
    type = 'MISS_EXP',
}

TEST[[
for k, v in next<!!>
end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'do',
    }
}

TEST[[
for k, v in next do<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'end',
        related = {
            {
                start  = 0,
                finish = 3,
            },
        }
    }
}

TEST[[
<!for!> k, v in next do
]]
{
    multi = 2,
    type = 'MISS_END',
}

TEST[[
for i =<!,!> 2 do
end
]]
{
    multi = 1,
    type = 'UNEXPECT_SYMBOL',
    info = {
        symbol = ',',
    }
}

TEST[[
for<!!> = 1, 2 do
end
]]
{
    type = 'MISS_NAME',
}

TEST[[
for i = 1<!!> do
end
]]
{
    type = 'MISS_LOOP_MAX',
}

TEST[[
for i = 1,<!!> do
end
]]
{
    --multi = 2,
    type = 'MISS_EXP'
}

TEST[[
for i =<!!> do
end
]]
{
    type = 'MISS_LOOP_MIN'
}

TEST[[
for i = 1,<!!> do
end
]]
{
    --multi = 1,
    type = 'MISS_EXP',
}

TEST[[
for i = 1, 2,<!!> do
end
]]
{
    type = 'MISS_EXP',
}

TEST[[
for i = 1, 2<! !>3 do
end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ',',
    }
}

TEST[[
for i = 1, 2<!!>
end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'do',
    }
}

TEST[[
for i = 1, 2 do<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'end',
        related = {
            {
                start  = 0,
                finish = 3,
            },
        }
    }
}

TEST[[
<!for!> i = 1, 2 do
]]
{
    multi = 2,
    type = 'MISS_END',
}

TEST[[
while<!!> do
end
]]
{
    type = 'MISS_EXP',
}

TEST[[
while true<!!>
end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'do',
    }
}

TEST[[
while true do<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'end',
        related = {
            {
                start  = 0,
                finish = 5,
            },
        }
    }
}

TEST[[
<!while!> true do
]]
{
    multi = 2,
    type = 'MISS_END',
}

TEST[[
repeat
until<!!>
]]
{
    type = 'MISS_EXP',
}

TEST[[
repeat<!!>
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'until',
    }
}

TEST[[
if<!!> then
end
]]
{
    type = 'MISS_EXP',
}

TEST[[
if true<!!>
end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'then',
    }
}

TEST[[
if true then<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'end',
        related = {
            {
                start  = 0,
                finish = 2,
            },
        }
    }
}

TEST[[
<!if!> true then
]]
{
    multi = 2,
    type = 'MISS_END',
}

TEST[[
if true then
else<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'end',
        related = {
            {
                start  = 0,
                finish = 2,
            },
        }
    }
}

TEST[[
if true then
elseif<!!>
end
]]
{
    type = 'MISS_EXP',
}

TEST[[
if true then
elseif true<!!>
end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'then',
    }
}

TEST[[
<!1 == 2!>
]]
{
    type = 'EXP_IN_ACTION',
}

TEST[[
<!a!>
]]
{
    type = 'EXP_IN_ACTION',
}

TEST[[
<!a.b!>
]]
{
    type = 'EXP_IN_ACTION',
}

TEST[[
<!a.b[1]!>
]]
{
    type = 'EXP_IN_ACTION',
}

TEST[[
<!!>else
end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'if',
    }
}

TEST[[
<!!>elseif true then
end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'if',
    }
}

TEST[[
if true then
else
<!elseif true then
!>end
]]
{
    type = 'BLOCK_AFTER_ELSE',
}

TEST[[
<!//!>xxxx
]]
{
    type = 'ERR_COMMENT_PREFIX',
    fix  = EXISTS,
}

TEST[[
<!/*
adadasd
*/!>
]]
{
    type = 'ERR_C_LONG_COMMENT',
    fix  = EXISTS,
}

TEST[[
a <!==!> b
]]
{
    type = 'ERR_ASSIGN_AS_EQ',
    fix  = EXISTS,
}

TEST[[
_VERSION <!==!> 1
]]
{
    type = 'ERR_ASSIGN_AS_EQ',
    fix  = EXISTS,
}

TEST[[
return a <!=!> b
]]
{
    type = 'ERR_EQ_AS_ASSIGN',
    fix  = EXISTS,
}

TEST[[
return a <!!=!> b
]]
{
    type = 'ERR_NONSTANDARD_SYMBOL',
    fix  = EXISTS,
    info = {
        symbol = '~=',
    },
}

TEST[[
if a <!do!> end
]]
{
    type = 'ERR_THEN_AS_DO',
    fix  = EXISTS,
}

TEST[[
while true <!then!> end
]]
{
    type = 'ERR_DO_AS_THEN',
    fix  = EXISTS,
}

TEST[[
return {
    _VERSION = '',
}
]]
(nil)

TEST[[
return {
    _VERSION == '',
}
]]
(nil)

-- 以下测试来自 https://github.com/andremm/lua-parser/blob/master/test.lua
TEST[[
f = 9e<!!>
]]
{
    type = 'MISS_EXPONENT',
}

TEST[[
f = 5.e<!!>
]]
{
    type = 'MISS_EXPONENT',
}

TEST[[
f = .9e-<!!>
]]
{
    type = 'MISS_EXPONENT',
}

TEST[[
f = 5.9e+<!!>
]]
{
    type = 'MISS_EXPONENT',
}

TEST[[
hex = 0x<!!>G
]]
{
    type = 'MUST_X16',
    multi = 1,
}

TEST[=============[
--[==[
testing long string3 begin
]==]

ls3 = [===[
testing
unfinised
long string
]==]

--[==[
[[ testing long string3 end ]]
]==]
<!!>]=============]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ']===]',
    }
}

TEST[[
-- short string test begin

ss6 = "testing unfinished string<!!>

-- short string test end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '"'
    }
}

TEST[[
-- short string test begin

ss7 = 'testing \\<!!>
unfinished \\
string'

-- short string test end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = "'",
    },
    multi = 1,
}

TEST[[
--[[ testing
unfinished
comment
<!!>]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ']]',
    }
}

TEST[[
--[=[xxx]==]
<!!>]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = ']=]',
    },
    fix  = EXISTS,
}

TEST[[
a = function (a,b,<!!>) end
]]
{
    type = 'MISS_NAME',
}

TEST[[
a = function (...,<!a!>) end
]]
{
    type = 'ARGS_AFTER_DOTS',
}

TEST[[
local a = function (<!1!>) end
]]
{
    type = 'UNKNOWN_SYMBOL',
    info = {
        symbol = '1',
    },
}

TEST[[
local test = function ( a , b , c , ... )<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'end',
        related = {
            {
                start  = 13,
                finish = 21,
            },
        }
    }
}

TEST[[
local test = <!function!> ( a , b , c , ... )
]]
{
    multi = 2,
    type = 'MISS_END',
}

TEST[[
a = 3 / <!/!> 2
]]
{
    type = 'UNKNOWN_SYMBOL',
    info = {
        symbol = '/'
    }
}

TEST[[
b = 1 <!&&!> 1
]]
{
    type = 'ERR_NONSTANDARD_SYMBOL',
    info = {
        symbol = 'and',
    }
}

TEST[[
b = 1 <<!>!> 0
]]
{
    type = 'UNKNOWN_SYMBOL',
    info = {
        symbol = '>',
    }
}

TEST[[
b = 1 < <!<!> 0
]]
{
    type = 'UNKNOWN_SYMBOL',
    info = {
        symbol = '<',
    }
}

TEST[[
concat2 = 2^3.<!.1!>
]]
{
    type = 'MALFORMED_NUMBER',
}

TEST[[
for k<!!>;v in pairs(t) do end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'in',
    },
    multi = 1,
}

TEST[[
for k,v in pairs(t:any<!!>) do end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '(',
    },
}

TEST[[
for i=1,10,<!!> do end
]]
{
    type = 'MISS_EXP',
}

TEST[[
for i=1,n:number<!!> do end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '(',
    },
}

TEST[[
function func(a,b,c,<!!>) end
]]
{
    type = 'MISS_NAME',
}

TEST[[
function func(...,<!a!>) end
]]
{
    type = 'ARGS_AFTER_DOTS'
}

TEST[[
function a.b:c<!!>:d () end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '(',
    }
}

TEST[[
if a then<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'end',
        related = {
            {
                start  = 0,
                finish = 2,
            },
        }
    }
}

TEST[[
<!if!> a then
]]
{
    multi = 2,
    type = 'MISS_END',
}

TEST[[
if a then else<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    info = {
        symbol = 'end',
        related = {
            {
                start  = 0,
                finish = 2,
            },
        }
    }
}

TEST[[
<!if!> a then else
]]
{
    multi = 2,
    type = 'MISS_END',
}

TEST[[
if a then
    return a
elseif b then
    return b
elseif<!!>
    
end
]]
{
    type = 'MISS_EXP',
}

TEST[[
if a:any<!!> then else end
]]
{
    type = 'MISS_SYMBOL',
    info = {
        symbol = '(',
    }
}

TEST[[
:: blah ::
:: <!not!> ::
]]
{
    type = 'KEYWORD',
}

TEST[[
local function <!a.b!>()
end
]]
{
    type = 'UNEXPECT_LFUNC_NAME'
}

TEST [[
f() <!=!> 1
]]
{
    multi = 1,
    type = 'UNKNOWN_SYMBOL',
    info = {
        symbol = '=',
    }
}

Version = 'Lua 5.1'
TEST[[
<!::xx::!>
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = {'Lua 5.2', 'Lua 5.3', 'Lua 5.4', 'Lua 5.5', 'LuaJIT'},
    info = {
        version = 'Lua 5.1',
    }
}

TEST[[
local goto = 1
]]
(nil)

TEST[[
local x = '<!\u{1000}!>'
]]
{
    type = 'ERR_ESC',
    version = {'Lua 5.3', 'Lua 5.4', 'Lua 5.5', 'LuaJIT'},
    info = {
        version ='Lua 5.1',
    }
}

TEST[[
local x = '<!\xff!>'
]]
{
    type = 'ERR_ESC',
    version = {'Lua 5.2', 'Lua 5.3', 'Lua 5.4', 'Lua 5.5', 'LuaJIT'},
    info = {
        version = 'Lua 5.1',
    }
}

Version = 'Lua 5.2'
TEST[[
local x = 1 <!//!> 2
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = {'Lua 5.3', 'Lua 5.4', 'Lua 5.5'},
    info = {
        version = 'Lua 5.2',
    }
}

TEST[[
local x = 1 <!<<!> 2
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = {'Lua 5.3', 'Lua 5.4', 'Lua 5.5'},
    info = {
        version = 'Lua 5.2',
    }
}

TEST[[
local x = '<!\u{1000}!>'
]]
{
    type = 'ERR_ESC',
    version = {'Lua 5.3', 'Lua 5.4', 'Lua 5.5', 'LuaJIT'},
    info = {
        version = 'Lua 5.2',
    }
}

TEST[[
while true do
    break
    x = 1
end
]]
(nil)

Version = 'Lua 5.3'

TEST[[
local x <!<close>!> = 1
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = {'Lua 5.4', 'Lua 5.5'},
    info = {
        version = 'Lua 5.3',
    }
}


Version = 'Lua 5.4'

TEST[[
local x <<!close!>> = 1
]]
(nil)

TEST[[
local x <close>, y <!<close>!> = 1
]]
{
    type = 'MULTI_CLOSE',
}

TEST[[
local x <const>, y <close>, z <!<close>!> = 1
]]
{
    type = 'MULTI_CLOSE',
}

TEST[[
s = '<!\u{1FFFFF}!>'
]]
(nil)


TEST[[
s = '\u<!{111111111}!>'
]]
{
    type = 'UTF8_MAX',
    info = {
        min = '00000000',
        max = '7FFFFFFF',
    }
}

TEST[[
x = 42<!LL!>
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = 'LuaJIT',
    info = EXISTS,
}

TEST[[
x = <!0b11011!>
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = 'LuaJIT',
    info = EXISTS,
}

TEST[[
x = 12.5<!i!>
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = 'LuaJIT',
    info = EXISTS,
}

TEST[[
x = 1.23<!LL!>
]]
{
    type = 'MALFORMED_NUMBER',
}

Version = 'LuaJIT'

TEST[[
x = 42LL
x = 42ULl
x = 0x2aLL
x = 0x2All
x = 12.5i
x = 1I
x = 18446744073709551615ULL
x = 0b11011
]]
(nil)

TEST[[
x = 1.23<!LL!>
]]
{
    type = 'MALFORMED_NUMBER',
}

TEST[[
x = 0b1<!2!>
]]
{
    type = 'MALFORMED_NUMBER',
}

Version = 'Lua 5.5'

TEST[[
local x <close>, y <close> = 1
]]
(nil)
