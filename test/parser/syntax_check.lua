local parser = require 'parser'
local catch  = require 'test.catch'
local util   = require 'utility'

---@class Test.SyntaxExpect
---@field code? string
---@field multi? integer
---@field version? LuaParser.LuaVersion
---@field optional? LuaParser.CompileOptions
---@field extra? table

---@param script string
---@return fun(expect: Test.SyntaxExpect|nil)
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
        if not expect or not expect.code then
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
        assert(first.code == expect.code)
        assert(first.left == target[1])
        assert(first.right == target[2])
        assert(util.equal(first.extra, expect.extra))
    end
end


TEST[[
local<!!>
]]
{
    code = 'MISS_NAME',
}

TEST[[
local <!？？？!>
]]
{
    code = 'UNICODE_NAME',
}

TEST[[
n = 1<!a!>
]]
{
    code = 'MALFORMED_NUMBER',
}

TEST[[
s = 'a<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = "'",
    }
}

TEST[[
s = "a<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '"',
    }
}

TEST[======[
s = [[a<!!>]======]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ']]',
    }
}

TEST[======[
s = [===[a<!!>]======]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ']===]',
    }
}

TEST[======[
s = [===[a]=]<!!>]======]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ']===]',
    }
}

TEST[[
s = '\x<!!>zzzzz'
]]
{
    code = 'MISS_ESC_X',
}

TEST[[
s = '\u<!!>'
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '{'
    }
}

TEST[[
s = '\u{<!!>}'
]]
{
    code = 'UTF8_SMALL',
}

TEST[[
s = '\u{<!ffffff!>}'
]]
{
    code = 'UTF8_MAX',
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
    code = 'UTF8_MAX',
    extra = {
        min = '00000000',
        max = '7FFFFFFF',
    }
}

TEST[[
s = '\u{aaa<!!>'
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '}',
    }
}

TEST[[
s = '\u{<!abcz!>}'
]]
{
    code = 'MUST_X16',
}

TEST[[
s = '<!\c!>'
]]
{
    code = 'ERR_ESC',
}

TEST[[
s = '<!\ !>'
]]
{
    code = 'ERR_ESC',
}

TEST[[
s = '\<!555!>'
]]
{
    code = 'ERR_ESC_DEC',
    extra = {
        min = '000',
        max = '255',
    }
}

TEST[[
n = 0x<!!>
]]
{
    code = 'MUST_X16',
}

TEST[[
n = 0x<!!>zzzz
]]
{
    code = 'MUST_X16',
    multi = 1,
}


TEST[[
n = 0x.<!!>zzzz
]]
{
    code = 'MUST_X16',
    multi = 1,
}

TEST[[
t = {<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '}',
    }
}

TEST[[
t = {1<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '}',
    }
}

TEST[[
t = {1,<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '}',
    }
}

TEST[[
t = {name =<!!>}
]]
{
    code = 'MISS_EXP',
}

TEST[[
t = {['name'] =<!!>}
]]
{
    code = 'MISS_EXP',
}

TEST[[
t = {['name']<!!>}
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '=',
    }
}

TEST[[
t = {[<!!>]=1}
]]
{
    code = 'MISS_EXP',
}

TEST[[
t = {<!!>,}
]]
{
    code = 'MISS_EXP',
}

TEST[[
t = {1<! !>2}
]]
{
    code = 'MISS_SEP_IN_TABLE',
}

TEST[[
f(<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ')',
    },
}

TEST[[
f(<!,!>1)
]]
{
    code = 'UNEXPECT_SYMBOL',
}

TEST[[
f(1,<!!>)
]]
{
    code = 'MISS_EXP',
}

TEST[[
f(1<!!> 1)
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ',',
    },
}

TEST[[
(<!!>).x()
]]
{
    code = 'MISS_EXP',
}

TEST[[
print(x<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ')',
    }
}

TEST[[
x.<!!>()
]]
{
    code = 'MISS_NAME',
}

TEST[[
x:<!!>()
]]
{
    code = 'MISS_NAME',
}

TEST[[
x[<!!>] = 1
]]
{
    code = 'MISS_EXP',
}

TEST[[
y = x[1<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ']',
    }
}

TEST[[
x:m<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '(',
    }
}

TEST[[
x = 1 and<!!>
]]
{
    code = 'MISS_EXP',
}

TEST[[
x = #<!!>
]]
{
    code = 'MISS_EXP',
}

TEST[[
local x = 1,<!!>
]]
{
    code = 'MISS_EXP',
}

TEST[[
local x,<!!> = 1, 2
]]
{
    code = 'MISS_NAME',
}

TEST[[
::<!!>
]]
{
    code = 'MISS_NAME',
}

TEST[[
::LABEL<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '::',
    }
}

TEST[[
goto<!!>
]]
{
    code = 'MISS_NAME',
}

TEST[[
return 1,<!!>
]]
{
    code = 'MISS_EXP',
}

TEST[[
local function<!!>() end
]]
{
    code = 'MISS_NAME',
}

TEST[[
function<!!>() end
]]
{
    code = 'MISS_NAME',
}

TEST[[
function f(<!!>
]]
{
    multi = 1,
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ')',
    }
}

TEST[[
function f<!!> end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '(',
    }
}

TEST[[
f = function (<!!>
]]
{
    multi = 1,
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ')',
    }
}

TEST[[
f = function<!!> end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '(',
    }
}

TEST[[
f = function <!f!>() end
]]
{
    code = 'UNEXPECT_EFUNC_NAME',
}

TEST[[
function f()<!!>
]]
{
    multi = 1,
    code = 'MISS_SYMBOL',
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
    code = 'MISS_END',
    extra = {
        start  = 12,
        finish = 12,
    }
}

TEST[[
function f:<!!>() end
]]
{
    code = 'MISS_NAME',
}

TEST[[
function f:x<!!>.y() end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '(',
    }
}

TEST[[
function f(a,<!!>) end
]]
{
    code = 'MISS_NAME',
}

TEST[[
function f(<!,!>a) end
]]
{
    code = 'UNEXPECT_SYMBOL',
}

TEST[[
function f(..., <!a!>) end
]]
{
    code = 'ARGS_AFTER_DOTS',
}

TEST[[
local x =<!!> ]]
{
    code = 'MISS_EXP',
}

TEST[[
x =<!!> ]]
{
    code = 'MISS_EXP',
}

TEST[[
for<!!> in next do
end
]]
{
    code = 'MISS_NAME',
}

TEST[[
for k, v<!!> do
end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = 'in',
    }
}

TEST[[
for k, v in<!!> do
end
]]
{
    code = 'MISS_EXP',
}

TEST[[
for k, v in next<!!>
end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = 'do',
    }
}

TEST[[
for k, v in next do<!!>
]]
{
    multi = 1,
    code = 'MISS_SYMBOL',
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
    code = 'MISS_END',
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
    code = 'MISS_EXP',
}

TEST[[
for<!!> = 1, 2 do
end
]]
{
    code = 'MISS_NAME',
}

TEST[[
for i = 1<!!> do
end
]]
{
    code = 'MISS_LOOP_MAX',
}

TEST[[
for i = 1,<!!> do
end
]]
{
    multi = 1,
    code = 'MISS_EXP'
}

TEST[[
for i =<!!> do
end
]]
{
    code = 'MISS_EXP'
}

TEST[[
for i = 1, 2,<!!> do
end
]]
{
    code = 'MISS_EXP',
}

TEST[[
for i = 1, 2<!!> 3 do
end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ',',
    }
}

TEST[[
for i = 1, 2<!!>
end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = 'do',
    }
}

TEST[[
for i = 1, 2 do<!!>
]]
{
    multi = 1,
    code = 'MISS_SYMBOL',
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
    code = 'MISS_END',
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
    code = 'MISS_EXP',
}

TEST[[
while true<!!>
end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = 'do',
    }
}

TEST[[
while true do<!!>
]]
{
    multi = 1,
    code = 'MISS_SYMBOL',
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
    code = 'MISS_END',
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
    code = 'MISS_EXP',
}

TEST[[
repeat<!!>
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = 'until',
    }
}

TEST[[
if<!!> then
end
]]
{
    code = 'MISS_EXP',
}

TEST[[
if true<!!>
end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = 'then',
    }
}

TEST[[
if true then<!!>
]]
{
    multi = 1,
    code = 'MISS_SYMBOL',
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
    code = 'MISS_END',
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
    code = 'MISS_SYMBOL',
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
    code = 'MISS_EXP',
}

TEST[[
if true then
elseif true<!!>
end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = 'then',
    }
}

TEST[[
<!1 == 2!>
]]
{
    code = 'EXP_IN_ACTION',
}

TEST[[
<!a!>
]]
{
    code = 'EXP_IN_ACTION',
}

TEST[[
<!a.b!>
]]
{
    code = 'EXP_IN_ACTION',
}

TEST[[
<!a.b[1]!>
]]
{
    code = 'EXP_IN_ACTION',
}

TEST[[
if true then
else
<!elseif!> true then
end
]]
{
    code = 'BLOCK_AFTER_ELSE',
}

TEST[[
<!//!>xxxx
]]
{
    code = 'ERR_COMMENT_PREFIX',
}

TEST[[
<!/*!>
adadasd
*/
]]
{
    code = 'ERR_C_LONG_COMMENT',
}

TEST[[
return a <!=!> b
]]
{
    code = 'ERR_EQ_AS_ASSIGN',
}

TEST[[
return a <!!=!> b
]]
{
    code = 'ERR_NONSTANDARD_SYMBOL',
    extra = {
        symbol = '~=',
    },
}

TEST[[
if a <!do!> end
]]
{
    code = 'ERR_THEN_AS_DO'
}

TEST[[
while true <!then!> end
]]
{
    code = 'ERR_DO_AS_THEN',
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
    code = 'MISS_EXPONENT',
}

TEST[[
f = 5.e<!!>
]]
{
    code = 'MISS_EXPONENT',
}

TEST[[
f = .9e-<!!>
]]
{
    code = 'MISS_EXPONENT',
}

TEST[[
f = 5.9e+<!!>
]]
{
    code = 'MISS_EXPONENT',
}

TEST[[
hex = 0x<!!>G
]]
{
    code = 'MUST_X16',
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
    code = 'MISS_SYMBOL',
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
    code = 'MISS_SYMBOL',
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
    code = 'MISS_SYMBOL',
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
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ']]',
    }
}

TEST[[
--[=[xxx]==]
<!!>]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = ']=]',
    },
}

TEST[[
a = function (a,b,<!!>) end
]]
{
    code = 'MISS_NAME',
}

TEST[[
a = function (...,<!a!>) end
]]
{
    code = 'ARGS_AFTER_DOTS',
}

TEST[[
local a = function (<!1!>) end
]]
{
    code = 'UNKNOWN_SYMBOL',
}

TEST[[
local test = function ( a , b , c , ... )<!!>
]]
{
    multi = 1,
    code = 'MISS_SYMBOL',
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
    code = 'MISS_END',
    extra = {
        start = 41,
        finish = 41,
    }
}

TEST[[
a = 3 / <!/!> 2
]]
{
    code = 'UNKNOWN_SYMBOL',
}

TEST[[
b = 1 <!&&!> 1
]]
{
    code = 'ERR_NONSTANDARD_SYMBOL',
    extra = {
        symbol = 'and',
    }
}

TEST[[
b = 1 <<!>!> 0
]]
{
    code = 'UNKNOWN_SYMBOL',
}

TEST[[
b = 1 < <!%<!> 0
]]
{
    code = 'UNKNOWN_SYMBOL',
}

TEST[[
concat2 = 2^3.<!.1!>
]]
{
    code = 'MALFORMED_NUMBER',
}

TEST[[
for k<!!>;v in pairs(t) do end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = 'in',
    },
    multi = 1,
}

TEST[[
for k,v in pairs(t:any<!!>) do end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '(',
    },
}

TEST[[
for i=1,10,<!!> do end
]]
{
    code = 'MISS_EXP',
}

TEST[[
for i=1,n:number<!!> do end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '(',
    },
}

TEST[[
function func(a,b,c,<!!>) end
]]
{
    code = 'MISS_NAME',
}

TEST[[
function func(...,<!a!>) end
]]
{
    code = 'ARGS_AFTER_DOTS'
}

TEST[[
function a.b:c<!!>:d () end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '(',
    }
}

TEST[[
if a then<!!>
]]
{
    multi = 1,
    code = 'MISS_SYMBOL',
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
    code = 'MISS_END',
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
    code = 'MISS_SYMBOL',
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
    code = 'MISS_END',
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
    code = 'MISS_EXP',
}

TEST[[
if a:any<!!> then else end
]]
{
    code = 'MISS_SYMBOL',
    extra = {
        symbol = '(',
    }
}

TEST[[
:: blah ::
:: <!not!> ::
]]
{
    code = 'KEYWORD',
}

TEST[[
local function a<!.b!>()
end
]]
{
    code = 'UNEXPECT_LFUNC_NAME'
}

TEST [[
f() <!=!> 1
]]
{
    multi = 1,
    code = 'UNKNOWN_SYMBOL',
}

TEST[[
<!::xx::!>
]]
{
    code = 'UNSUPPORT_SYMBOL',
    version = 'Lua 5.1'
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
    code = 'ERR_ESC',
    version = 'Lua 5.1',
}

TEST[[
local x = '<!\xff!>'
]]
{
    code = 'ERR_ESC',
    version = 'Lua 5.1',
}

TEST[[
local x = 1 <!//!> 2
]]
{
    code = 'UNSUPPORT_SYMBOL',
    version = 'Lua 5.2',
}

TEST[[
local x = 1 <!>>!> 2
]]
{
    code = 'UNSUPPORT_SYMBOL',
    version = 'Lua 5.2',
}

TEST[[
local x = '<!\u{1000}!>'
]]
{
    code = 'ERR_ESC',
    version = 'Lua 5.2',
}

TEST[[
while true do
    break
    x = 1
end
]]
{
    code = nil,
    version = 'Lua 5.2',
}

TEST[[
local x <!<close>!> = 1
]]
{
    code = 'UNSUPPORT_SYMBOL',
    version = 'Lua 5.2',
}

TEST[[
local x <<!close!>> = 1
]]
(nil)

TEST[[
s = '<!\u{1FFFFF}!>'
]]
(nil)


TEST[[
s = '\u{<!111111111!>}'
]]
{
    code = 'UTF8_MAX',
    extra = {
        min = '00000000',
        max = '7FFFFFFF',
    }
}

TEST[[
x = 42<!LL!>
]]
{
    code = 'UNSUPPORT_SYMBOL',
}

TEST[[
x = <!0b11011!>
]]
{
    code = 'UNSUPPORT_SYMBOL',
}

TEST[[
x = 12.5<!i!>
]]
{
    code = 'UNSUPPORT_SYMBOL',
}

TEST[[
x = 1.23<!LL!>
]]
{
    code = 'MALFORMED_NUMBER',
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
    code = nil,
    optional = {
        jit = true,
    }
}

TEST[[
x = 1.23<!LL!>
]]
{
    code = 'MALFORMED_NUMBER',
    optional = {
        jit = true,
    }
}

TEST[[
x = 0b1<!2!>
]]
{
    code = 'MALFORMED_NUMBER',
    optional = {
        jit = true,
    }
}

TEST [[
local <!true!> = 1
]]
{
    code = 'RESERVED_WORD'
}

TEST [[
local function f(<!true!>)
end
]]
{
    code = 'RESERVED_WORD'
}

TEST[[
function f()
    return <!...!>
end
]]
{
    code = 'UNEXPECT_DOTS',
}

TEST[[
function f(...)
    return function ()
        return <!...!>
    end
end
]]
{
    code = 'UNEXPECT_DOTS',
}

TEST[[
function f(...)
    return ...
end
]]
(nil)

TEST[[
for i = 1, 10 do
    break
end
]]
(nil)

TEST[[
for k, v in pairs(t) do
    break
end
]]
(nil)

TEST[[
while true do
    break
end
]]
(nil)

TEST[[
repeat
    break
until true
]]
(nil)

TEST[[
<!break!>
]]
{
    code = 'BREAK_OUTSIDE',
}

TEST[[
function f (x)
    if 1 then <!break!> end
end
]]
{
    code = 'BREAK_OUTSIDE',
}

TEST[[
while 1 do
end
<!break!>
]]
{
    code = 'BREAK_OUTSIDE',
}

TEST[[
while 1 do
    local function f()
        <!break!>
    end
end
]]
{
    code = 'BREAK_OUTSIDE',
}

TEST[[
:: label :: <!return!>
goto label
]]
{
    code = 'ACTION_AFTER_RETURN',
}

TEST[[
::label::
goto label
]]
(nil)

TEST[[
goto label
::label::
]]
(nil)

TEST[[
do
    goto label
end
::label::
]]
(nil)

TEST[[
::label::
do
    goto label
end
]]
(nil)

TEST[[
<!goto label!>
local x = 1
x = 2
::label::
]]
{
    code = 'JUMP_LOCAL_SCOPE',
    extra = {
        loc = 'x',
        start = 17,
        finish = 18,
    }
}

TEST[[
local x = 1
goto label
x = 2
::label::
print(x)
]]
(nil)

TEST[[
local x = 1
::label::
print(x)
local x
goto label
]]
(nil)

TEST[[
goto <!label!>
]]
{
    code = 'NO_VISIBLE_LABEL',
}

TEST[[
::other_label::
do do do goto <!label!> end end end
]]
{
    code = 'NO_VISIBLE_LABEL',
}

TEST[[
goto <!label!>
do
    ::label::
end
]]
{
    code = 'NO_VISIBLE_LABEL',
}

TEST[[
<!goto label!>
local x = 1
::label::
x = 2
]]
{
    code = 'JUMP_LOCAL_SCOPE',
    extra = {
        loc = 'x',
        start = 17,
        finish = 18,
    },
}

TEST[[
<!goto label!>
local x = 1
::label::
return x
]]
{
    code = 'JUMP_LOCAL_SCOPE',
    extra = {
        loc = 'x',
        start = 17,
        finish = 18,
    },
}

TEST[[
::label::
::other_label::
::<!label!>::
]]
{
    code = 'REDEFINED_LABEL',
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
    code = 'REDEFINED_LABEL',
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
(nil)

TEST[[
::label::
::other_label::
if true then
    ::label::
end
]]
{
    version = 'Lua 5.3'
}

TEST[[
if true then
    ::label::
end
::label::
]]
(nil)

TEST[[
local x <const> = 1
<!x!> = 2
]]
{
    code = 'SET_CONST',
}

TEST[[
local x <const> = 1
function <!x!>() end
]]
{
    code = 'SET_CONST',
}

TEST[[
local x <close> = 1
<!x!> = 2
]]
{
    code = 'SET_CONST',
}

TEST[[
local x <<!what!>> = 1
]]
{
    code = 'UNKNOWN_ATTRIBUTE',
}

TEST [[
return function () local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200, <!l201!>, l202 end
]]
{
    code = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200, <!l201!>, l202
]]
{
    code = 'LOCAL_LIMIT',
}

TEST [[
return function (l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200, <!l201!>, l202) end
]]
{
    code = 'LOCAL_LIMIT',
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
    code = 'LOCAL_LIMIT',
}

TEST [[
return function (l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199)
    local function F() end
    local <!x!>
end
]]
{
    code = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197

for <!i!> = 1, 10 do end -- use 4 local variables
]]
{
    code = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196

for i = 1, 10 do end
]]
(nil)

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196

for <!x!> in _ do end
]]
{
    code = 'LOCAL_LIMIT',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195

for x in _ do end
]]
(nil)


TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197

for <!x!> in _ do end
]]
{
    code = 'LOCAL_LIMIT',
    version = 'Lua 5.1',
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
{
    version = 'Lua 5.1',
}

TEST [[
local l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16, l17, l18, l19, l20, l21, l22, l23, l24, l25, l26, l27, l28, l29, l30, l31, l32, l33, l34, l35, l36, l37, l38, l39, l40, l41, l42, l43, l44, l45, l46, l47, l48, l49, l50, l51, l52, l53, l54, l55, l56, l57, l58, l59, l60, l61, l62, l63, l64, l65, l66, l67, l68, l69, l70, l71, l72, l73, l74, l75, l76, l77, l78, l79, l80, l81, l82, l83, l84, l85, l86, l87, l88, l89, l90, l91, l92, l93, l94, l95, l96, l97, l98, l99, l100, l101, l102, l103, l104, l105, l106, l107, l108, l109, l110, l111, l112, l113, l114, l115, l116, l117, l118, l119, l120, l121, l122, l123, l124, l125, l126, l127, l128, l129, l130, l131, l132, l133, l134, l135, l136, l137, l138, l139, l140, l141, l142, l143, l144, l145, l146, l147, l148, l149, l150, l151, l152, l153, l154, l155, l156, l157, l158, l159, l160, l161, l162, l163, l164, l165, l166, l167, l168, l169, l170, l171, l172, l173, l174, l175, l176, l177, l178, l179, l180, l181, l182, l183, l184, l185, l186, l187, l188, l189, l190, l191, l192, l193, l194, l195, l196, l197, l198, l199, l200

local <!_ENV!> = nil
]]
{
    code = 'LOCAL_LIMIT',
    version = 'Lua 5.1',
}

TEST [[
local x <const<!>=!> 1
]]
{
    multi = 1,
    code = 'MISS_SPACE_BETWEEN',
}

TEST [[
function mt<!['']!>() end
]]
{
    code = 'INDEX_IN_FUNC_NAME'
}

TEST [[
function mt<![]!>() end
]]
{
    multi = 2,
    code  = 'INDEX_IN_FUNC_NAME'
}

TEST [[
goto<!!> = 1
]]
{
    multi = 1,
    code  = 'MISS_NAME'
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
{
    version = 'Lua 5.1',
}

TEST [[
<!return 1!>
print(1)
]]
{
    code = 'ACTION_AFTER_RETURN',
    version = 'Lua 5.1',
}

TEST [[
<!return 1!>
return 1
]]
{
    code = 'ACTION_AFTER_RETURN',
    version = 'Lua 5.1',
}

TEST [[
f
<!()!>
]]
{
    code = 'AMBIGUOUS_SYNTAX',
    version = 'Lua 5.1',
}

TEST [[
f:xx
<!()!>
]]
{
    code = 'AMBIGUOUS_SYNTAX',
    version = 'Lua 5.1',
}

TEST [[
f
<!()!>
.x = 1
]]
{
    code = 'AMBIGUOUS_SYNTAX',
    version = 'Lua 5.1',
}

TEST [===[
print [[
<![[!>
]]
]===]
{
    code = 'NESTING_LONG_MARK',
    version = 'Lua 5.1',
}

TEST [===[
print [[
<![[!>
]]
]===]
{
    code = 'NESTING_LONG_MARK',
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
(nil)

TEST [===[
print [[
[[
]]
]===]
(nil)

TEST [[
f
''
]]
(nil)

TEST [[
f
{}
]]
(nil)

TEST '\v\f'
(nil)

TEST [=[
print(<![[]]!>:gsub())
]=]
{
    code = 'NEED_PAREN',
}

TEST [=[
print(<!''!>:gsub())
]=]
{
    code = 'NEED_PAREN',
}

TEST [=[
print(<!""!>:gsub())
]=]
{
    code = 'NEED_PAREN',
}

TEST [=[
print(<!{}!>:gsub())
]=]
{
    code = 'NEED_PAREN',
}

TEST [[
local t = ''
(function () end)()
]]
(nil)

TEST [[
local t = ""
(function () end)()
]]
(nil)

TEST [[
local t = {}
(function () end)()
]]
(nil)

TEST [=[
local t = [[]]
(function () end)()
]=]
(nil)

TEST [[
goto LABEL
::LABEL::
]]
{
    code = nil,
    version = 'Lua 5.1',
    optional = {
        jit = true,
    }
}

TEST [[
local goto = 1
]]
{
    code = nil,
    version = 'Lua 5.1',
    optional = {
        jit = true,
    }
}

TEST [[
local goto]]
{
    code = nil,
    version = 'Lua 5.1',
    optional = {
        jit = true,
    }
}

TEST [[
f(1, goto, 2)
]]
{
    code = nil,
    version = 'Lua 5.1',
    optional = {
        jit = true,
    }
}

TEST [[
local function f(x, goto, y) end
]]
{
    code = nil,
    version = 'Lua 5.1',
    optional = {
        jit = true,
    }
}
