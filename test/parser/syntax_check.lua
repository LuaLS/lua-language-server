local parser = require 'parser'
local catch  = require 'test.catch'
local util   = require 'utility'

---@param script string
---@return fun(expect: table)
local function TEST(script)
    return function (expect)
        local version = expect and expect.version
        local optional = expect and expect.optional
        local newScript, list = catch(script, '!')
        local ast = parser.compile(newScript, version, optional)
        assert(ast)
        local errs = ast.errors
        local first = errs[1]
        local target = list['!'][1]
        if not expect.type then
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
        assert(first.code == expect.type)
        assert(first.left == target[1])
        assert(first.right == target[2])
        assert(util.equal(first.extra, expect.extra))
    end
end


TEST[[
local<!!>
]]
{
    type = 'MISS_NAME',
}

TEST[[
local <!？？？!>
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
    extra = {
        symbol = "'",
    }
}

TEST[[
s = "a<!!>
]]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = '"',
    }
}

TEST[======[
s = [[a<!!>]======]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = ']]',
    }
}

TEST[======[
s = [===[a<!!>]======]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = ']===]',
    }
}

TEST[======[
s = [===[a]=]<!!>]======]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = ']===]',
    }
}

TEST[[
s = '\x<!!>zzzzz'
]]
{
    type = 'MISS_ESC_X',
}

TEST[[
s = '\u<!!>'
]]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = '{'
    }
}

TEST[[
s = '\u{<!!>}'
]]
{
    type = 'UTF8_SMALL',
}

TEST[[
s = '\u{<!ffffff!>}'
]]
{
    type = 'UTF8_MAX',
    version = 'Lua 5.3',
    extra = {
        min = '000000',
        max = '10FFFF',
        needVer = 'Lua 5.4'
    }
}

TEST[[
s = '\u{<!111111111!>}'
]]
{
    type = 'UTF8_MAX',
    extra = {
        min = '00000000',
        max = '7FFFFFFF',
    }
}

TEST[[
s = '\u{aaa<!!>'
]]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = '}',
    }
}

TEST[[
s = '\u{<!abcz!>}'
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
s = '\<!555!>'
]]
{
    type = 'ERR_ESC_DEC',
    extra = {
        min = '000',
        max = '255',
    }
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
    extra = {
        symbol = '}',
    }
}

TEST[[
t = {1<!!>
]]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = '}',
    }
}

TEST[[
t = {1,<!!>
]]
{
    type = 'MISS_SYMBOL',
    extra = {
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
    extra = {
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
    extra = {
        symbol = ')',
    },
}

TEST[[
f(<!,!>1)
]]
{
    type = 'UNEXPECT_SYMBOL',
}

TEST[[
f(1,<!!>)
]]
{
    type = 'MISS_EXP',
}

TEST[[
f(1<!!> 1)
]]
{
    type = 'MISS_SYMBOL',
    extra = {
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
    extra = {
        symbol = ')',
    }
}

TEST[[
x.<!!>()
]]
{
    type = 'MISS_NAME',
}

TEST[[
x:<!!>()
]]
{
    type = 'MISS_NAME',
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
    extra = {
        symbol = ']',
    }
}

TEST[[
x:m<!!>
]]
{
    type = 'MISS_SYMBOL',
    extra = {
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
    extra = {
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
    extra = {
        symbol = ')',
    }
}

TEST[[
function f<!!> end
]]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = '(',
    }
}

TEST[[
f = function (<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    extra = {
        symbol = ')',
    }
}

TEST[[
f = function<!!> end
]]
{
    type = 'MISS_SYMBOL',
    extra = {
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
    extra = {
        symbol = 'end',
        related = {
            start  = 0,
            finish = 8,
        },
    }
}

TEST[[
<!function!> f()
]]
{
    multi = 2,
    type = 'MISS_END',
    extra = {
        start  = 12,
        finish = 12,
    }
}

TEST[[
function f:<!!>() end
]]
{
    type = 'MISS_NAME',
}

TEST[[
function f:x<!!>.y() end
]]
{
    type = 'MISS_SYMBOL',
    extra = {
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
function f(<!,!>a) end
]]
{
    type = 'UNEXPECT_SYMBOL',
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
    extra = {
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
    extra = {
        symbol = 'do',
    }
}

TEST[[
for k, v in next do<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    extra = {
        symbol = 'end',
        related = {
            start  = 0,
            finish = 3,
        }
    }
}

TEST[[
<!for!> k, v in next do
]]
{
    multi = 2,
    type = 'MISS_END',
    extra = {
        start  = 19,
        finish = 19,
    }
}

TEST[[
for i =<!!>, 2 do
end
]]
{
    multi = 1,
    type = 'MISS_EXP',
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
    multi = 1,
    type = 'MISS_EXP'
}

TEST[[
for i =<!!> do
end
]]
{
    type = 'MISS_EXP'
}

TEST[[
for i = 1, 2,<!!> do
end
]]
{
    type = 'MISS_EXP',
}

TEST[[
for i = 1, 2<!!> 3 do
end
]]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = ',',
    }
}

TEST[[
for i = 1, 2<!!>
end
]]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = 'do',
    }
}

TEST[[
for i = 1, 2 do<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    extra = {
        symbol = 'end',
        related = {
            start  = 0,
            finish = 3,
        }
    }
}

TEST[[
<!for!> i = 1, 2 do
]]
{
    multi = 2,
    type = 'MISS_END',
    extra = {
        start = 15,
        finish = 15,
    }
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
    extra = {
        symbol = 'do',
    }
}

TEST[[
while true do<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    extra = {
        symbol = 'end',
        related = {
            start  = 0,
            finish = 5,
        }
    }
}

TEST[[
<!while!> true do
]]
{
    multi = 2,
    type = 'MISS_END',
    extra = {
        start = 13,
        finish = 13,
    }
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
    extra = {
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
    extra = {
        symbol = 'then',
    }
}

TEST[[
if true then<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    extra = {
        symbol = 'end',
        related = {
            start  = 0,
            finish = 2,
        }
    }
}

TEST[[
<!if!> true then
]]
{
    multi = 2,
    type = 'MISS_END',
    extra = {
        start = 12,
        finish = 12,
    }
}

TEST[[
if true then
else<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    extra = {
        symbol = 'end',
        related = {
            start  = 0,
            finish = 2,
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
    extra = {
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
if true then
else
<!elseif!> true then
end
]]
{
    type = 'BLOCK_AFTER_ELSE',
}

TEST[[
<!//!>xxxx
]]
{
    type = 'ERR_COMMENT_PREFIX',
}

TEST[[
<!/*!>
adadasd
*/
]]
{
    type = 'ERR_C_LONG_COMMENT',
}

TEST[[
return a <!=!> b
]]
{
    type = 'ERR_EQ_AS_ASSIGN',
}

TEST[[
return a <!!=!> b
]]
{
    type = 'ERR_NONSTANDARD_SYMBOL',
    extra = {
        symbol = '~=',
    },
}

TEST[[
if a <!do!> end
]]
{
    type = 'ERR_THEN_AS_DO'
}

TEST[[
while true <!then!> end
]]
{
    type = 'ERR_DO_AS_THEN',
}

TEST[[
return {
    _VERSION = '',
}
]]
{}

TEST[[
return {
    _VERSION == '',
}
]]
{}

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
    extra = {
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
    extra = {
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
    extra = {
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
    extra = {
        symbol = ']]',
    }
}

TEST[[
--[=[xxx]==]
<!!>]]
{
    type = 'MISS_SYMBOL',
    extra = {
        symbol = ']=]',
    },
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
}

TEST[[
local test = function ( a , b , c , ... )<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    extra = {
        symbol = 'end',
        related = {
            start  = 13,
            finish = 21,
        }
    }
}

TEST[[
local test = <!function!> ( a , b , c , ... )
]]
{
    multi = 2,
    type = 'MISS_END',
    extra = {
        start = 41,
        finish = 41,
    }
}

TEST[[
a = 3 /<!!> / 2
]]
{
    type = 'MISS_EXP',
}

TEST[[
b = 1 <!&&!> 1
]]
{
    type = 'ERR_NONSTANDARD_SYMBOL',
    extra = {
        symbol = 'and',
    }
}

TEST[[
b = 1 <<!!>> 0
]]
{
    type = 'MISS_EXP',
}

TEST[[
b = 1 <<!!> < 0
]]
{
    type = 'MISS_EXP',
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
    extra = {
        symbol = 'in',
    },
    multi = 1,
}

TEST[[
for k,v in pairs(t:any<!!>) do end
]]
{
    type = 'MISS_SYMBOL',
    extra = {
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
    extra = {
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
    extra = {
        symbol = '(',
    }
}

TEST[[
if a then<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    extra = {
        symbol = 'end',
        related = {
            start  = 0,
            finish = 2,
        }
    }
}

TEST[[
<!if!> a then
]]
{
    multi = 2,
    type = 'MISS_END',
    extra = {
        start = 9,
        finish = 9,
    }
}

TEST[[
if a then else<!!>
]]
{
    multi = 1,
    type = 'MISS_SYMBOL',
    extra = {
        symbol = 'end',
        related = {
            start  = 0,
            finish = 2,
        }
    }
}

TEST[[
<!if!> a then else
]]
{
    multi = 2,
    type = 'MISS_END',
    extra = {
        start = 14,
        finish = 14,
    }
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
    extra = {
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
local function a<!.b!>()
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
}

TEST[[
<!::!>xx::
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = 'Lua 5.1',
}

TEST [[
<!goto!> X
]]
{
    multi = 1,
    type = 'UNSUPPORT_SYMBOL',
    version = 'Lua 5.1',
}

TEST[[
local goto = 1
]]
{
    version = 'Lua 5.1',
}

TEST[[
local x = '<!\u{1000}!>'
]]
{
    type = 'ERR_ESC',
    version ='Lua 5.1',
}

TEST[[
local x = '<!\xff!>'
]]
{
    type = 'ERR_ESC',
    version = 'Lua 5.1',
}

TEST[[
local x = 1 <!//!> 2
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = 'Lua 5.2',
}

TEST[[
local x = 1 <!>>!> 2
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = 'Lua 5.2',
}

TEST[[
local x = '<!\u{1000}!>'
]]
{
    type = 'ERR_ESC',
    version = 'Lua 5.2',
}

TEST[[
while true do
    break
    x = 1
end
]]
{
    version = 'Lua 5.1',
}

TEST[[
local x <!<close>!> = 1
]]
{
    type = 'UNSUPPORT_SYMBOL',
    version = 'Lua 5.3'
}

TEST[[
local x <close> = 1
]]
{}

TEST[[
s = '\u{1FFFFF}'
]]
{}

TEST[[
s = '\u{<!111111111!>}'
]]
{
    type = 'UTF8_MAX',
    extra = {
        min = '00000000',
        max = '7FFFFFFF',
    }
}

TEST[[
x = 42<!LL!>
]]
{
    type = 'UNSUPPORT_SYMBOL',
}

TEST[[
x = <!0b11011!>
]]
{
    type = 'UNSUPPORT_SYMBOL',
}

TEST[[
x = 12.5<!i!>
]]
{
    type = 'UNSUPPORT_SYMBOL',
}

TEST[[
x = 1.23<!LL!>
]]
{
    type = 'MALFORMED_NUMBER',
}

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
{
    optional = {
        jit = true,
    }
}

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
    optional = {
        jit = true,
    }
}

TEST [[
local function f(<!true!>)
end
]]
{
    type = 'KEYWORD'
}

TEST[[
function f()
    return <!...!>
end
]]
{
    type = 'UNEXPECT_DOTS',
}

TEST[[
function f(...)
    return function ()
        return <!...!>
    end
end
]]
{
    type = 'UNEXPECT_DOTS',
}

TEST[[
function f(...)
    return ...
end
]]
{}

TEST[[
for i = 1, 10 do
    break
end
]]
{}

TEST[[
for k, v in pairs(t) do
    break
end
]]
{}

TEST[[
while true do
    break
end
]]
{}

TEST[[
repeat
    break
until true
]]
{}

TEST[[
<!break!>
]]
{
    type = 'BREAK_OUTSIDE',
}

TEST[[
function f (x)
    if 1 then <!break!> end
end
]]
{
    type = 'BREAK_OUTSIDE',
}

TEST[[
while 1 do
end
<!break!>
]]
{
    type = 'BREAK_OUTSIDE',
}

TEST[[
while 1 do
    local function f()
        <!break!>
    end
end
]]
{
    type = 'BREAK_OUTSIDE',
}

TEST[[
:: label :: <!return!>
goto label
]]
{
    type = 'ACTION_AFTER_RETURN',
}

TEST[[
::label::
goto label
]]
{}

TEST[[
goto label
::label::
]]
{}

TEST[[
do
    goto label
end
::label::
]]
{}

TEST[[
::label::
do
    goto label
end
]]
{}

TEST[[
goto <!label!>
]]
{
    type = 'NO_VISIBLE_LABEL',
}

TEST[[
::other_label::
do do do goto <!label!> end end end
]]
{
    type = 'NO_VISIBLE_LABEL',
}

TEST[[
goto <!label!>
do
    ::label::
end
]]
{
    type = 'NO_VISIBLE_LABEL',
}

TEST[[
goto <!label!>
local x = 1
::label::
]]
{
    type = 'JUMP_LOCAL_SCOPE',
    extra = {
        loc = 'x',
        start = 17,
        finish = 18,
    },
}

TEST[[
local x
goto label
::label::
print(x)
]]
{}

TEST[[
local x
::label::
print(x)
local x
goto label
]]
{}

TEST[[
::label::
::other_label::
::<!label!>::
]]
{
    type = 'REDEFINED_LABEL',
    extra = {
        start  = 2,
        finish = 7,
    }
}

TEST[[
::label::
::other_label::
if true then
    ::<!label!>::
end
]]
{
    type = 'REDEFINED_LABEL',
    extra = {
        start  = 2,
        finish = 7,
    }
}

TEST[[
if true then
    ::label::
end
::label::
]]
{}

TEST[[
::label::
::other_label::
if true then
    ::label::
end
]]
{
    version = 'Lua 5.3',
}

TEST[[
if true then
    ::label::
end
::label::
]]
{
    version = 'Lua 5.3',
}

TEST[[
local x <const> = 1
<!x!> = 2
]]
{
    type = 'SET_CONST',
}

TEST[[
local x <const> = 1
function <!x!>() end
]]
{
    type = 'SET_CONST',
}

TEST[[
local x <close> = 1
<!x!> = 2
]]
{
    type = 'SET_CONST',
}

TEST[[
local x <<!what!>> = 1
]]
{
    type = 'UNKNOWN_ATTRIBUTE',
}

TEST [[
return function () local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200, <!l201!>, l202 end
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200, <!l201!>, l202
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
return function (l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200, <!l201!>, l202) end
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
return function (l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199)
    do
        local x
    end
    local x
    do
        local <!x!>
    end
end
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
return function (l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199)
    local function F() end
    local <!x!>
end
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197

for <!i!> = 1, 10 do end -- use 3 + 1 local variables
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196

for i = 1, 10 do end
]]
{}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196

for <!x!> in _ do end -- use 4 + X local variables
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195

for x in _ do end
]]
{}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197

for <!x!> in _ do end -- use 3 + X local variables
]]
{
    version = 'Lua 5.1',
    type = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196

for x in _ do end
]]
{
    version = 'Lua 5.1',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200

_ENV = nil
]]
{}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200

local <!_ENV!> = nil
]]
{
    type = 'LOCAL_LIMIT',
}

TEST [[
local x <const<!>=!> 1
]]
{
    multi = 1,
    type = 'MISS_SPACE_BETWEEN',
}

TEST [[
function mt<!['']!>() end
]]
{
    type = 'INDEX_IN_FUNC_NAME'
}

TEST [[
function mt<![]!>() end
]]
{
    multi = 2,
    type  = 'INDEX_IN_FUNC_NAME'
}

TEST [[
goto<!!> = 1
]]
{
    multi = 1,
    version = 'Lua 5.4',
    type  = 'MISS_NAME'
}

TEST [[
goto = 1
]]
{
    version = 'Lua 5.1',
}

TEST [[
return {
    function () end
}
]]
{}

TEST [[
<!return 1!>
print(1)
]]
{
    type = 'ACTION_AFTER_RETURN',
}

TEST [[
<!return 1!>
return 1
]]
{
    type = 'ACTION_AFTER_RETURN',
}

TEST [[
f
<!()!>
]]
{
    version = 'Lua 5.1',
    type = 'AMBIGUOUS_SYNTAX',
}

TEST [[
f:xx
<!()!>
]]
{
    version = 'Lua 5.1',
    type = 'AMBIGUOUS_SYNTAX',
}

TEST [[
f
<!()!>
.x = 1
]]
{
    version = 'Lua 5.1',
    type = 'AMBIGUOUS_SYNTAX',
}

TEST [===[
print [[
<![[!>
]]
]===]
{
    version = 'Lua 5.1',
    type = 'NESTING_LONG_MARK',
}

TEST [===[
print [[
<![[!>
]]
]===]
{
    version = 'Lua 5.1',
    type = 'NESTING_LONG_MARK',
}

TEST [===[
print [=[
[=[
]=]
]===]
{
    version = 'Lua 5.1',
}

TEST [===[
print [=[
[=[
]=]
]===]
{
    version = 'Lua 5.1',
}

TEST [===[
print [[]]
print [[]]
]===]
{
    version = 'Lua 5.1',
}

TEST [===[
print [[
[[
]]
]===]
{}

TEST [===[
print [[
[[
]]
]===]
{}

TEST [[
f
''
]]
{}

TEST [[
f
{}
]]
{}

TEST '\v\f'
{}

TEST [=[
print(<![[]]!>:gsub())
]=]
{
    type = 'NEED_PAREN',
}

TEST [=[
print(<!''!>:gsub())
]=]
{
    type = 'NEED_PAREN',
}

TEST [=[
print(<!""!>:gsub())
]=]
{
    type = 'NEED_PAREN',
}

TEST [=[
print(<!{}!>:gsub())
]=]
{
    type = 'NEED_PAREN',
}

TEST [[
local t = ''
(function () end)()
]]
{}

TEST [[
local t = ""
(function () end)()
]]
{}

TEST [[
local t = {}
(function () end)()
]]
{}

TEST [=[
local t = [[]]
(function () end)()
]=]
{}

TEST [[
goto LABEL
::LABEL::
]]
{
    version = 'Lua 5.1',
    optional = {
        jit = true,
    }
}

TEST [[
local goto = 1
]]
{
    version = 'Lua 5.1',
    optional = {
        jit = true,
    }
}

TEST [[
local goto]]
{
    version = 'Lua 5.1',
    optional = {
        jit = true,
    }
}

TEST [[
f(1, goto, 2)
]]
{
    version = 'Lua 5.1',
    optional = {
        jit = true,
    }
}

TEST [[
local function f(x, goto, y) end
]]
{
    version = 'Lua 5.1',
    optional = {
        jit = true,
    }
}
