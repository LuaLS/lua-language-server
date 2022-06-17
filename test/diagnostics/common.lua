local config = require 'config'
local util   = require 'utility'

local disables = config.get(nil, 'Lua.diagnostics.disable')

TEST [[
local <!x!>
]]

TEST [[
local y
local x <close> = y
]]

TEST [[
local function x()
end
x()
]]

TEST [[
return function (x)
    x.a = 1
end
]]

TEST [[
local <!t!> = {}
<!t!>.a = 1
]]

TEST [[
local <!function <!x!>()
end!>
]]


TEST [[
local <!x!> = <!function () end!>
]]

TEST [[
local <!x!>
<!x!> = <!function () end!>
]]

TEST [[
local <!function x()
end!>
local <!function <!y!>()
    x()
end!>
]]

TEST [[
local print, _G
print(<!x!>)
print(<!log!>)
print(<!X!>)
print(<!Log!>)
print(<!y!>)
print(Z)
print(_G)
Z = 1
]]

TEST [[
::<!LABEL!>::
]]

TEST [[
<!    !>
]]

TEST [[

<!    !>
]]

TEST [[
X = 1<!  !>
]]

TEST [[
X = [=[  
    ]=]
]]

TEST [[
local x
print(x)
local <!x!>
print(x)
]]

TEST [[
local x
print(x)
local <!x!>
print(x)
local <!x!>
print(x)
]]

TEST [[
local _
print(_)
local _
print(_)
local _ENV
<!print!>(_ENV) -- 由于重定义了_ENV，因此print变为了未定义全局变量
]]

TEST [[
local x
return x, function (<!x!>)
    return x
end
]]

TEST [[
print(1)
_ENV = nil
]]

TEST [[
local _ENV = { print = print }
print(1)
]]

util.arrayInsert(disables, 'undefined-env-child')
TEST [[
_ENV = nil
<!GLOBAL!> = 1 --> _ENV.GLOBAL = 1
]]

TEST [[
_ENV = nil
local _ = <!print!> --> local _ = _ENV.print
]]

TEST [[
_ENV = {}
GLOBAL = 1 --> _ENV.GLOBAL = 1
]]

TEST [[
_ENV = {}
local _ = print --> local _ = _ENV.print
]]

TEST [[
GLOBAL = 1
_ENV = nil
]]

util.arrayRemove(disables, 'undefined-env-child')
TEST [[
<!print()
('string')!>:sub(1, 1)
]]

TEST [[
print()
('string')
]]

TEST [[
print
{}
{}
]]

TEST [[
local x
return x
    : f(1)
    : f(1)
]]

TEST [[
return {
    <!print
    'string'!>
}
]]

TEST [[
return {
    <!print
    {
        x = 1,
    }!>
}
]]

TEST [[
print()
'string'
]]

TEST [[
print
{
    x = 1,
}
]]

TEST [[
local function x(a, b)
    return a, b
end
x(1, 2, <!3!>)
]]

TEST [[
local function x(a, b, ...)
    return a, b, ...
end
x(1, 2, 3, 4, 5)
]]

TEST [[
---@type fun(a, b, ...)
local x
x(1, 2, 3, 4, 5)
]]

TEST [[
local m = {}
function m:x(a, b)
    return a, b
end
m:x(1, 2, <!3!>)
]]

TEST [[
local m = {}
function m:x(a, b)
    return a, b
end
m.x(1, 2, 3, <!4!>)
]]

TEST [[
local m = {}
function m.x(a, b)
    return a, b
end
m:x(1, <!2!>, <!3!>, <!4!>)
]]

TEST [[
local function x(a, b)
    return a, b
end
x(1)
]]

TEST [[
---@param a integer
---@param b integer
local function x(a, b)
    return a, b
end
<!x(1)!>
]]

TEST [[
---@param a integer
---@param b integer
local function x(a, b)
    return a, b
end
<!x()!>
]]

TEST [[
---@param a integer
---@param b integer
---@param ... integer
local function x(a, b, ...)
    return a, b, ...
end
x(1, 2)
]]

TEST [[
---@diagnostic disable: unused-local

---@param a integer
---@param b integer
local function f(a, b)
end

f(...)
]]

TEST [[
---@diagnostic disable: unused-local

---@param a integer
---@param b integer
local function f(a, b)
end

local function return2Numbers()
    return 1, 2
end

f(return2Numbers())
]]

TEST [[
---@param a integer
---@param b? integer
local function x(a, b)
    return a, b
end
x(1)
]]

TEST [[
---@param b integer?
local function x(a, b)
    return a, b
end
x(1)
]]

TEST [[
---@param b integer|nil
local function x(a, b)
    return a, b
end
x(1)
]]

TEST [[
local m = {}
function m.x()
end
m:x()
]]

TEST [[
InstanceName = 1
Instance = _G[InstanceName]
]]

TEST [[
local _ = (''):sub(1, 2)
]]

TEST [=[
return [[   
    
]]
]=]

util.arrayInsert(disables, 'close-non-object')
TEST [[
local _ <close> = function () end
]]
util.arrayRemove(disables, 'close-non-object')

TEST [[
local _ <close> = <!1!>
]]

TEST [[
local _ <close> = <!''!>
]]

TEST [[
local c <close> = <!(function () return 1 end)()!>
]]

util.arrayInsert(disables, 'unused-local')
TEST [[
local f = <!function () end!>
]]

TEST [[
local f;f = <!function () end!>
]]

TEST [[
local <!function f() end!>
]]

TEST [[
local <!function f()
    f()
end!>
]]


TEST [[
local <!function test()
end!>

local <!function foo ()
end!>
]]

util.arrayRemove(disables, 'unused-local')
TEST [[
local mt, x
function mt:m()
    function x:m()
    end
end
return mt, x
]]

TEST [[
local mt = {}
function mt:f()
end
return mt
]]

TEST [[
local <!mt!> = {}
function <!mt!>:f()
end
]]

TEST [[
local <!x!> = {}
<!x!>.a = 1
]]

TEST [[
local <!x!> = {}
<!x!>['a'] = 1
]]

TEST [[
local function f(<!self!>)
end
f()
]]

TEST [[
local function f(<!...!>)
end
f()
]]

TEST [[
local function f(var)
    print(var)
end
local var
f(var)
]]

TEST [[
local function f(a, b)
    return a, b
end
f(1, 2, <!3!>, <!4!>)
]]

TEST [[
local mt = {}
function mt:f(a, b)
    return a, b
end
mt.f(1, 2, 3, <!4!>)
]]


TEST [[
local mt = {}
function mt.f(a, b)
    return a, b
end
mt:f(1, <!2!>, <!3!>, <!4!>)
]]

TEST [[
local mt = {}
function mt:f(a, b)
    return a, b
end
mt:f(1, 2, <!3!>, <!4!>)
]]

TEST [[
local function f(a, b, ...)
    return a, b, ...
end
f(1, 2, 3, 4)
]]

TEST [[
local _ = next({}, 1, <!2!>)
print(1, 2, 3, 4, 5)
]]

TEST [[
local function f(callback)
    callback(1, 2, 3)
end
f(function () end)
]]

--TEST [[
--local realTostring = tostring
--tostring = function () end
--tostring(<!1!>)
--tostring = realTostring
--tostring(1)
--]]

TEST [[
<!aa!> = 1
tostring = 1
ROOT = 1
_G.bb = 1
]]

TEST [[
local f = load('')
if f then
    f(1, 2, 3)
end
]]

TEST [[
local _ = <!unpack!>
]]

TEST [[
X = table[<!x!>]
]]

TEST [[
return {
    <!x!> = 1,
    y = 2,
    <!x!> = 3,
}
]]

TEST [[
return {
    x = 1,
    y = 2,
}, {
    x = 1,
    y = 2,
}
]]

TEST [[
local m = {}
function m.open()
end

m:open()
]]

TEST [[
local m = {}
function m:open()
end

m.open('ok')
]]

TEST [[
<!if true then
end!>
]]

TEST [[
<!if true then
else
end!>
]]

TEST [[
if true then
else
    return
end
]]

TEST [[
while true do
end
]]

TEST [[
<!for _ = 1, 10 do
end!>
]]

TEST [[
<!for _ in pairs(_VERSION) do
end!>
]]

TEST [[
local _ = 1, <!2!>
]]

TEST [[
_ = 1, <!2!>
]]

TEST [[
function X()
    do
        local k
        print(k)
    end
    local k = 1
    print(k)
end
]]

TEST [[
function X()
    local loc
    print(loc)
end
]]

TEST [[
local <!t!> = {}
<!t!>[1] = 1
]]

TEST [[
T1 = 1
_ENV.T2 = 1
_G.T3 = 1
_ENV._G.T4 = 1
_G._G._G.T5 = 1
rawset(_G, 'T6', 1)
rawset(_ENV, 'T7', 1)
print(T1)
print(T2)
print(T3)
print(T4)
print(T5)
print(T6)
print(T7)
]]

TEST [[
local x
x = <!x or 0 + 1!>
]]

TEST [[
local x, y
x = <!x + y or 0!>
]]

TEST [[
local x, y, z
x = x and y or '' .. z
]]

TEST [[
local x
x = x or -1
]]

TEST [[
local x
x = x or (0 + 1)
]]

TEST [[
local x, y
x = (x + y) or 0
]]

TEST [[
local t = {}
t.a = 1
t.a = 2
return t
]]

TEST [[
table.insert({}, 1, 2, <!3!>)
]]

TEST [[
while true do
    break
    <!print()
    print()!>
end
]]

TEST [[
local x, <!y!>, <!z!> = 1
print(x, y, z)
]]

TEST [[
local x, y, <!z!> = 1, 2
print(x, y, z)
]]

TEST [[
local x, y, z = print()
print(x, y, z)
]]

TEST [[
local x, y, z
print(x, y, z)
]]

TEST [[
local x, y, z
x, <!y!>, <!z!> = 1
print(x, y, z)
]]

TEST [[
X, <!Y!>, <!Z!> = 1
]]

TEST [[
T = {}
T.x, <!T.y!>, <!T.z!> = 1
]]

TEST [[
T = {}
T['x'], <!T['y']!>, <!T['z']!> = 1
]]

--TEST [[
-----@class <!Class!>
-----@class <!Class!>
--]]

TEST [[
---@alias <!A!> integer
---@alias <!A!> integer
]]

TEST [[
---@class A : <!B!>
]]

TEST [[
---@class <!A : B!>
---@class <!B : C!>
---@class <!C : D!>
---@class <!D : A!>
]]

TEST [[
---@class A : B
---@class B : C
---@class C : D
---@class D
]]

TEST [[
---@type <!A!>
]]

TEST [[
---@class A
---@type A|<!B!>|<!C!>
]]

TEST [[
---@class AAA
---@alias B AAA

---@type B
]]

TEST [[
---@alias B <!AAA!>
]]

TEST [[
---@class A
---@class B
---@alias <!A!> B
]]

TEST [[
---@param x <!Class!>
]]

TEST [[
---@class Class
---@param <!y!> Class
local function f(x)
    return x
end
f()
]]

TEST [[
---@class Class
---@param <!y!> Class
function F(x)
    return x
end
F()
]]

TEST [[
---@class Class
---@param <!x!> Class
---@param y Class
---@param <!x!> Class
local function f(x, y)
    return x, y
end

local _
f(_, _)
]]

TEST [[
---@field <!x Class!>
---@class Class
]]

TEST [[
---@class Class

---@field <!x Class!>
]]

TEST [[
---@class Class
---
---@field x Class
]]

TEST [[
---@class Class
---@field x Class
---@field <!x!> Class
]]

TEST [[
---@class Class : any
]]

TEST [[
---@type fun(a: integer)
local f
f(1)
]]

TEST [[
---@class c
c = {}
]]

TEST [[
---@generic T: any
---@param v T
---@param message any
---@return T
function assert(v, message)
    return v, message
end
]]

TEST [[
---@type string
---|
]]

TEST [[
---@type
---| 'xx'
]]

TEST [[
---@class class
local t
]]
---[==[
-- checkUndefinedField 通用
TEST [[
---@class Foo
---@field field1 integer
local mt = {}
function mt:Constructor()
    self.field2 = 1
end
function mt:method1() return 1 end
function mt.method2() return 2 end

---@class Bar: Foo
---@field field4 integer
local mt2 = {}

---@type Foo
local v
print(v.field1 + 1)
print(v.field2 + 1)
print(v.<!field3!> + 1)
print(v:method1())
print(v.method2())
print(v:<!method3!>())

---@type Bar
local v2
print(v2.field1 + 1)
print(v2.field2 + 1)
print(v2.<!field3!> + 1)
print(v2.field4 + 1)
print(v2:method1())
print(v2.method2())
print(v2:<!method3!>())

local v3 = {}
print(v3.abc)

---@class Bar2
local mt3
function mt3:method() return 1 end
print(mt3:method())
]]

-- checkUndefinedField 通过type找到class
TEST [[
---@class Foo
local Foo
function Foo:method1() end

---@type Foo
local v
v:method1()
v:<!method2!>() -- doc.class.name
]]

-- checkUndefinedField 通过type找到class，涉及到 class 继承版
TEST [[
---@class Foo
local Foo
function Foo:method1() end
---@class Bar: Foo
local Bar
function Bar:method3() end

---@type Bar
local v
v:method1()
v:<!method2!>() -- doc.class.name
v:method3()
]]

-- checkUndefinedField 类名和类变量同名，类变量被直接使用
TEST [[
---@class Foo
local Foo
function Foo:method1() end
Foo:<!method2!>() -- doc.class
Foo:<!method2!>() -- doc.class
]]

-- checkUndefinedField 没有@class的不检测
TEST [[
local Foo
function Foo:method1()
    return Foo:method2() -- table
end
]]

-- checkUndefinedField 类名和类变量不同名，类变量被直接使用、使用self
TEST [[
---@class Foo
local mt
function mt:method1()
    mt.<!method2!>() -- doc.class
    self:method1()
    return self.<!method2!>() -- doc.class.name
end
]]

-- checkUndefinedField 当会推导成多个class类型时
TEST [[
---@class Foo
local mt
function mt:method1() end

---@class Bar
local mt2
function mt2:method2() end

---@type Foo
local v
---@type Bar
local v2
<!v2!> = v
v2:<!method1!>()
v2:method2()
]]

TEST [[
---@type table
T1 = {}
print(T1.f1)
---@type tablelib
T2 = {}
print(T2.<!f2!>)
]]
--]==]
TEST [[
---@overload fun(...)
local function f() end

f(1)
]]

TEST [[
for i = <!10, 1!> do
    print(i)
end
]]

TEST [[
for i = <!10, 1, 5!> do
    print(i)
end
]]

TEST [[
for i = 1, 1 do
    print(i)
end
]]

TEST [[
---@param a number
return function (<!a!>)
end
]]

TEST [[
---@meta

---@param a number
return function (a)
end
]]

TEST [[
local m = {}

function <!m:fff!>()
end

function <!m:fff!>()
end

return m
]]

TEST [[
local m = {}

function m:fff()
end

do
    function m:fff()
    end
end

return m
]]

TEST [[
local m = {}

m.x = true
m.x = false

return m
]]

TEST [[
local m = {}

m.x = io.open('')
m.x = nil

return m
]]

TEST [[
---@class A
---@field a boolean

---@return A
local function f() end

local r = f()
r.x = 1

return r.x
]]

TEST [[
---@diagnostic disable-next-line
x = 1
]]

TEST [[
---@diagnostic disable-next-line: lowercase-global
x = 1
]]

TEST [[
---@diagnostic disable-next-line: unused-local
<!x!> = 1
]]

TEST [[
---@diagnostic disable
x = 1
]]

TEST [[
---@diagnostic disable
---@diagnostic enable
<!x!> = 1
]]

TEST [[
---@diagnostic disable
---@diagnostic disable
---@diagnostic enable
x = 1
]]

TEST [[
---@diagnostic disable-next-line: <!xxx!>
]]

TEST [[
local mt = {}

function mt:a(x)
    return self, x
end

function mt:b(y)
    self:a(1):b(2)
    return y
end

return mt
]]

TEST [[
local function each()
    return function ()
    end
end

for x in each() do
    print(x)
end
]]

TEST [[
---@type string
local s

print(s:upper())
]]

TEST [[
local t = ().
return t
]]

TEST [[
return {
    [1] = 1,
    ['1'] = 1,
}
]]

TEST [[
return {
    [print()] = 1,
    [print()] = 1,
}
]]

TEST [[
---@type { x: number, y: number}
---| "'resume'"
]]

TEST [[
return {
    1, <!2!>, 3,
    [<!2!>] = 4,
}
]]

TEST [[
--- @class Emit
--- @field on fun(eventName: string, cb: function)
--- @field on fun(eventName: '"died"', cb: fun(i: integer))
--- @field on fun(eventName: '"won"', cb: fun(s: string))
local emit = {}
]]

TEST [[
--- @class Emit
--- @field on fun(eventName: string, cb: function)
--- @field on fun(eventName: '"died"', cb: fun(i: integer))
--- @field on fun(eventName: '"won"', cb: fun(s: string))
--- @field <!on!> fun(eventName: '"died"', cb: fun(i: integer))
local emit = {}
]]

-- redundant-return
TEST [[
local function f()
    <!return!>
end
f()
]]

TEST [[
local function f()
    return nil
end
f()
]]

TEST [[
local function f()
    local function x()
        <!return!>
    end
    x()
    return true
end
f()
]]

TEST [[
local function f()
    local function x()
        return true
    end
    return x()
end
f()
]]

TEST [[
---@type file*
local f
local _ = f:read '*a'
local _ = f:read('*a')
]]

TEST [[
function F()
    <!coroutine.yield!>()
end
]]

TEST [[
---@async
function F()
    coroutine.yield()
end
]]

TEST [[
---@type async fun()
local f

function F()
    <!f!>()
end
]]

TEST [[
---@type async fun()
local f

---@async
function F()
    f()
end
]]

TEST [[
local function f(cb)
    cb()
end

<!f!>(function () ---@async
    return nil
end)
]]

TEST [[
local function f(cb)
    pcall(cb)
end

<!f!>(function () ---@async
    return nil
end)
]]

TEST [[
---@param c any
local function f(c)
    return c
end

f(function () ---@async
    return nil
end)
]]

TEST [[
---@param ... any
local function f(...)
    return ...
end

f(function () ---@async
    return nil
end)
]]

TEST [[
---@vararg any
local function f(...)
    return ...
end

f(function () ---@async
    return nil
end)
]]

TEST [[
local function f(...)
    return ...
end

f(function () ---@async
    return nil
end)
]]

TEST [[
local function f(...)
    return ...
end

f(1, function () ---@async
    return nil
end)
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

<!f()!>
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

X = f()
]]

config.get(nil, 'Lua.diagnostics.neededFileStatus')['not-yieldable'] = 'Any'
TEST [[
---@param cb fun()
local function f(cb)
    return cb
end

---@async
local function af()
    return nil
end

f(<!af!>)
]]

TEST [[
---@param cb async fun()
local function f(cb)
    return cb
end

---@async
local function af()
    return nil
end

f(af)
]]

TEST [[
local function f(cb)
    cb()
end

local function af()
    <!f!>(function () ---@async
        return nil
    end)
end

return af
]]

TEST [[
local function f(cb)
    cb()
end

---@async
local function af()
    f(function () ---@async
        return nil
    end)
end

return af
]]

TEST [[
local _ = type(function () ---@async
    return nil
end)
]]

TEST [[
---@param ... number
local function f(...)
    return ...
end

return f
]]

TEST [[
---@type fun(...: string)
]]

TEST [[
---@type fun(xxx, yyy, ...): boolean
]]

TEST [[
local <!x!>

return {
    x = 1,
}
]]

TEST [[
---@class A #1
]]

TEST [[
---@class A 1
]]

TEST [[
return ('1'):upper()
]]

TEST [[
local value
value = '1'
value = value:upper()
]]

TEST [[
T = {}
---@deprecated # comment
T.x = 1

print(<!T.x!>)
]]

TEST [[
T = {}

---@deprecated
function T:ff()
end

<!T:ff!>()
]]

TEST [[
---@type string?
local x

S = <!x!>:upper()
]]

TEST [[
---@type string?
local x

if x then
    S = x:upper()
end
]]

TEST [[
---@type string?
local x

if not x then
    x = ''
end

S = x:upper()
]]

TEST [[
---@type fun()?
local x

S = <!x!>()
]]

TEST [[
---@type integer?
local x

T = {}
T[<!x!>] = 1
]]

TEST [[
local x, y
local z = x and y

print(z.y)
]]

TEST [[
local x, y
function x()
    y()
end

function y()
    x()
end

x()
]]

TEST [[
---@meta

---@param x fun()
local function f1(x)
end

---@return fun()
local function f2()
end

f1(f2())
]]

TEST [[
---@meta

---@type fun():integer
local f

---@param x integer
local function foo(x) end

foo(f())
]]
