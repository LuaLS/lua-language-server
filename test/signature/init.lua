local core  = require 'core.signature'
local files = require 'files'
local catch = require 'catch'

rawset(_G, 'TEST', true)

---@diagnostic disable: await-in-sync
function TEST(script)
    return function (expect)
        local newScript, catched1 = catch(script, '?')
        files.setText(TESTURI, newScript)
        local hovers = core(TESTURI, catched1['?'][1][1])
        if hovers then
            assert(#hovers == #expect)
            for i, hover in ipairs(hovers) do
                local newExpect, catched2 = catch(expect[i], '!')
                local arg = hover.params[hover.index]

                assert(newExpect == hover.label)
                if arg then
                    assert(catched2['!'][1] ~= nil)
                    assert(catched2['!'][1][1] == arg.label[1])
                    assert(catched2['!'][1][2] == arg.label[2])
                else
                    assert(#catched2['!'] == 0)
                end
            end
        else
            assert(expect == nil)
        end
        files.remove(TESTURI)
    end
end

TEST [[
local function x(a, b)
end

x(<??>
]]
{'function x(<!a: any!>, b: any)'}

TEST [[
local function x(a, b)
end

x(<??>)
]]
{'function x(<!a: any!>, b: any)'}

TEST [[
local function x(a, b)
end

x(xxx<??>)
]]
{'function x(<!a: any!>, b: any)'}

TEST [[
local function x(a, b)
end

x(xxx, <??>)
]]
{'function x(a: any, <!b: any!>)'}

TEST [[
function mt:f(a)
end

mt:f(<??>
]]
{'(method) mt:f(<!a: any!>)'}

TEST [[
local function x(a, b)
    return 1
end

x(<??>
]]
{'function x(<!a: any!>, b: any)'}

TEST [[
local function x(a, ...)
    return 1
end

x(1, 2, 3, <??>
]]
{'function x(a: any, <!...any!>)'}

TEST [[
(''):sub(<??>
]]
{'(method) string:sub(<!i: integer!>, j?: integer)'}

TEST [[
(''):sub(1)<??>
]]
(nil)

TEST [[
local function f(a, b, c)
end

f(1, 'string<??>')
]]
{'function f(a: any, <!b: any!>, c: any)'}

TEST [[
pcall(function () <??> end)
]]
(nil)

TEST [[
table.unpack {<??>}
]]
(nil)

TEST [[
---@type fun(x: number, y: number):boolean
local zzzz
zzzz(<??>)
]]
{'function zzzz(<!x: number!>, y: number)'}

TEST [[
('abc'):format(f(<??>))
]]
(nil)

TEST [[
function Foo(param01, param02)

end

Foo(<??>)
]]
{'function Foo(<!param01: any!>, param02: any)'}

TEST [[
function f1(a, b)
end

function f2(c, d)
end

f2(f1(),<??>)
]]
{'function f2(c: any, <!d: any!>)'}

TEST [[
local function f(a, b, c)
end

f({},<??>)
]]
{'function f(a: any, <!b: any!>, c: any)'}

TEST [[
for _ in pairs(<??>) do
end
]]
{'function pairs(<!t: <T:table>!>)'}

TEST [[
function m:f()
end

m.f(<??>)
]]
{'function m.f(<!self: any!>)'}

TEST [[
---@alias nnn table<number, string>

---@param x nnn
local function f(x, y, z) end

f(<??>)
]]
{'function f(<!x: table<number, string>!>, y: any, z: any)'}

TEST [[
local function x(a, b)
end

x(  aaaa  <??>, 2)
]]
{"function x(<!a: any!>, b: any)"}

TEST [[
local function x(a, b)
end

x(<??>   aaaa  , 2)
]]
{'function x(<!a: any!>, b: any)'}

TEST [[
local function x(a, b)
end

x(aaaa  ,<??>    2)
]]
{'function x(a: any, <!b: any!>)'}

TEST [[
local function x(a, b)
end

x(aaaa  ,    2     <??>)
]]
{'function x(a: any, <!b: any!>)'}

TEST [[
local fooC

---test callback
---@param callback fun(x:number, s:string):nil @callback
---@param par number @par
function fooC(callback, par) end

fooC(function (x, s)
    
end,<??>)
]]
{'function fooC(callback: fun(x: number, s: string):nil, <!par: number!>)'}

TEST [[
(function (a, b)
end)(<??>)
]]
{'function (<!a: any!>, b: any)'}

TEST [[
---@overload fun()
---@overload fun(a:number)
---@param a number
---@param b number
function X(a, b) end

X(<??>)
]]
{
'function X()',
'function X(<!a: number!>)',
'function X(<!a: number!>, b: number)',
}

TEST [[\
---@overload fun()
---@overload fun(a:number)
---@param a number
---@param b number
function X(a, b) end

X(<?1?>)
]]
{
'function X(<!a: number!>)',
'function X(<!a: number!>, b: number)',
}

TEST [[
---@overload fun()
---@overload fun(a:number)
---@param a number
---@param b number
function X(a, b) end

X(1, <??>)
]]
{
'function X(a: number, <!b: number!>)',
}

TEST [[
---@overload fun()
---@overload fun(a:number)
---@param a number
---@param b number
function X(a, b) end

X(1, <?2?>)
]]
{
'function X(a: number, <!b: number!>)',
}

TEST [[
---@alias A { x:number, y:number, z:number }

---comment
---@param a A
---@param b string
function X(a, b)
    
end

X({}, <??>)
]]
{
'function X(a: { x: number, y: number, z: number }, <!b: string!>)'
}

TEST [[
---@overload fun(x: number)
---@overload fun(x: number, y: number)
local function f(...)
end

f(<??>)
]]
{
'function f(<!x: number!>)',
'function f(<!x: number!>, y: number)',
}

TEST [[
---@class A
---@overload fun(x: number)

---@type A
local t

t(<??>)
]]
{
'function (<!x: number!>)',
}

TEST [[
---@class 😅

---@param a 😅
---@param b integer
local function f(a, b)
end

f(1, 2<??>)
]]
{
'function f(a: 😅, <!b: integer!>)',
}

TEST [[
---@class A
---@field event fun(self: self, ev: "onChat", c: string)
---@field event fun(self: self, ev: "onTimer", t: integer)

---@type A
local t

t:event("onChat", <??>)
]]
{
'(method) (ev: "onChat", <!c: string!>)',
}

TEST [[
---@class A
---@field event fun(self: self, ev: "onChat", c: string)
---@field event fun(self: self, ev: "onTimer", t: integer)

---@type A
local t

t:event("onTimer", <??>)
]]
{
'(method) (ev: "onTimer", <!t: integer!>)',
}
