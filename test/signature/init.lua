local core  = require 'core.signature'
local files = require 'files'
local catch = require 'catch'

rawset(_G, 'TEST', true)

---@diagnostic disable: await-in-sync
function TEST(script)
    return function (expect)
        local newScript, catched1 = catch(script, '?')
        local newExpect, catched2 = catch(expect or '', '!')
        files.removeAll()
        files.setText('', newScript)
        local hovers = core('', catched1['?'][1][1])
        if hovers then
            assert(expect)
            local hover = hovers[#hovers]

            local arg = hover.params[hover.index].label

            assert(newExpect == hover.label)
            assert(catched2['!'][1][1] == arg[1])
            assert(catched2['!'][1][2] == arg[2])
        else
            assert(expect == nil)
        end
    end
end

TEST [[
local function x(a, b)
end

x(<??>
]]
'function x(<!a: any!>, b: any)'

TEST [[
local function x(a, b)
end

x(<??>)
]]
'function x(<!a: any!>, b: any)'

TEST [[
local function x(a, b)
end

x(xxx<??>)
]]
'function x(<!a: any!>, b: any)'

TEST [[
local function x(a, b)
end

x(xxx, <??>)
]]
'function x(a: any, <!b: any!>)'

TEST [[
function mt:f(a)
end

mt:f(<??>
]]
'method mt:f(<!a: any!>)'

TEST [[
local function x(a, b)
    return 1
end

x(<??>
]]
'function x(<!a: any!>, b: any)'

TEST [[
local function x(a, ...)
    return 1
end

x(1, 2, 3, <??>
]]
'function x(a: any, <!...: any!>)'

TEST [[
(''):sub(<??>
]]
'method string:sub(<!i: integer!>, j?: integer)'

TEST [[
(''):sub(1)<??>
]]
(nil)

TEST [[
local function f(a, b, c)
end

f(1, 'string<??>')
]]
'function f(a: any, <!b: any!>, c: any)'

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
'function zzzz(<!x: number!>, y: number)'

TEST [[
('abc'):format(f(<??>))
]]
(nil)

TEST [[
function Foo(param01, param02)

end

Foo(<??>)
]]
'function Foo(<!param01: any!>, param02: any)'

TEST [[
function f1(a, b)
end

function f2(c, d)
end

f2(f1(),<??>)
]]
'function f2(c: any, <!d: any!>)'

TEST [[
local function f(a, b, c)
end

f({},<??>)
]]
'function f(a: any, <!b: any!>, c: any)'

TEST [[
for _ in pairs(<??>) do
end
]]
'function pairs(<!t: <T>!>)'

TEST [[
function m:f()
end

m.f(<??>)
]]
'function m.f(<!self: any!>)'

TEST [[
---@alias nnn table<number, string>

---@param x nnn
local function f(x, y, z) end

f(<??>)
]]
'function f(<!x: table<number, string>!>, y: any, z: any)'

TEST [[
local function x(a, b)
end

x(  aaaa  <??>, 2)
]]
"function x(<!a: any!>, b: any)"

TEST [[
local function x(a, b)
end

x(<??>   aaaa  , 2)
]]
'function x(<!a: any!>, b: any)'

TEST [[
local function x(a, b)
end

x(aaaa  ,<??>    2)
]]
'function x(a: any, <!b: any!>)'

TEST [[
local function x(a, b)
end

x(aaaa  ,    2     <??>)
]]
'function x(a: any, <!b: any!>)'

TEST [[
local fooC

---test callback
---@param callback fun(x:number, s:string):nil @callback
---@param par number @par
function fooC(callback, par) end

fooC(function (x, s)
    
end,<??>)
]]
'function fooC(callback: fun(x: number, s: string):nil, <!par: number!>)'
