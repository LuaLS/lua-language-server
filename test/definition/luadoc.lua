local config = require "config.config"
config.set(nil, 'Lua.type.castNumberToInteger', false)
TEST [[
---@class <!A!>
---@class B : <?A?>
]]

TEST [[
---@class <!A!>
---@type B|<?A?>
]]

TEST [[
---@class Class
local <?<!t!>?>
---@type Class
local x
]]

TEST [[
---@class Class
local t
---@type Class
local <?<!x!>?>
]]

TEST [[
---@class A
local mt = {}
function mt:<!cast!>()
end

---@type A
local obj
obj:<?cast?>()
]]

TEST [[
---@class A
---@field x number

---@class B: A
---@field <!x!> boolean

---@type B
local t

t.<?x?>
]]

TEST [[
---@class A
---@field <!x!> number

---@class B: A

---@type B
local t

t.<?x?>
]]

TEST [[
---@class A
local A

function A:x() end

---@class B: A
local B

<!function B:x() end!>

---@type B
local t

local <!<?v?>!> = t.x
]]

TEST [[
---@class A
local A

<!function A:x() end!>

---@class B: A
local B

---@type B
local t

local <!<?v?>!> = t.x
]]

TEST [[
---@type A
local obj
obj:<?func?>()

---@class A
local mt
function mt:<!func!>()
end
]]

TEST [[
---@type A
local obj
obj:<?func?>()

---@class A
local mt = {}
function mt:<!func!>()
end
]]

TEST [[
---@alias <!B!> A
---@type <?B?>
]]

TEST [[
---@class <!Class!>
---@param a <?Class?>
]]

TEST [[
---@type <!fun():void!>
local <?<!f!>?>
]]

TEST [[
---@param f <!fun():void!>
function t(<?<!f!>?>) end
]]

TEST [[
---@vararg <!fun():void!>
function f(<?...?>) end
]]

TEST [[
---@param ... <!fun():void!>
function f(<?...?>) end
]]

TEST [[
---@alias A <!fun()!>

---@type A
local <!<?x?>!>
]]

TEST [[
---@class A: <!{}!>

---@type A
local <!<?x?>!>
]]

TEST [[
---@overload <!fun(y: boolean)!>
---@param x number
---@param y boolean
---@param z string
function <!f!>(x, y, z) end

print(<?f?>)
]]

TEST [[
local function f()
    local x
    return x
end

---@class Class
local mt

---@type Class
local <?<!x!>?> = f()
]]

TEST [[
---@class Class
---@field <!name!> string
---@field id integer
local mt = {}
mt.<?name?>
]]

TEST [[
---@alias <!A!> string

---@type <?A?>
]]

TEST [[
---@class X
---@field <!a!> string

---@class Y:X

---@type Y
local y
y.<?a?>
]]

TEST [[
---@class <!A!>
local mt

function mt:f()
end

---@see <?A?>
]]

TEST [[
---@class A
local mt

function <!mt:f!>()
end

---@see <?A.f?>
]]

TEST [[
AAA = {}
<!AAA.BBB!> = 1

---@see <?AAA.BBB?>
]]

TEST [[
---@class AAAA
---@field a AAAA
AAAA = {};

function AAAA:<!SSDF!>()
    
end

AAAA.a.<?SSDF?>
]]

TEST [[
---@return <!fun()!>
local function f() end

local <?<!r!>?> = f()
]]

TEST [[
---@generic T
---@param p T
---@return T
local function f(p) end

local k = <!function () end!>
local <?<!r!>?> = f(k)
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:<!bar1!>() end

---@generic T
---@param arg1 T
---@return T
function Generic(arg1) print(arg1) end

local v1 = Generic(Foo)
print(v1.<?bar1?>)
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:bar1() end

---@generic T
---@param arg1 T
---@return T
function Generic(arg1) print(arg1) end

local v1 = Generic("Foo")
print(v1.<?bar1?>)
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:bar1() end

---@generic T
---@param arg1 `T`
---@return T
function Generic(arg1) print(arg1) end

local v1 = Generic(Foo)
print(v1.<?bar1?>)
]]


TEST [[
---@class n.Foo
local Foo = {}
function Foo:bar1() end

---@generic T
---@param arg1 n.`T`
---@return T
function Generic(arg1) print(arg1) end

local v1 = Generic(Foo)
print(v1.<?bar1?>)
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:<!bar1!>() end

---@generic T
---@param arg1 `T`
---@return T
function Generic(arg1) print(arg1) end

local v1 = Generic("Foo")
print(v1.<?bar1?>)
]]


TEST [[
---@class n.Foo
local Foo = {}
function Foo:<!bar1!>() end

---@generic T
---@param arg1 n.`T`
---@return T
function Generic(arg1) print(arg1) end

local v1 = Generic("Foo")
print(v1.<?bar1?>)
]]

TEST [[
---@class A
local t

t.<!x!> = 1

---@type A[]
local b

local c = b[1]
c.<?x?>
]]

TEST [[
---@class A
local t

t.<!x!> = 1

---@type { [number]: A }
local b

local c = b[1]
c.<?x?>
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:<!bar1!>() end

---@type { [number]: Foo }
local v1
print(v1[1].<?bar1?>)
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:<!bar1!>() end

---@class Foo2
local Foo2 = {}
function Foo2:bar1() end

---@type { [number]: Foo }
local v1
print(v1[1].<?bar1?>)
]]

--TODO 得扩展 simple 的信息才能识别这种情况了
--TEST [[
-----@class Foo
--local Foo = {}
--function Foo:bar1() end
--
-----@class Foo2
--local Foo2 = {}
--function Foo2:<!bar1!>() end
--
-----@type Foo2<number, Foo>
--local v1
--print(v1.<?bar1?>)
--]]

TEST [[
---@type fun():<!fun()!>
local f

local <?<!f2!>?> = f()
]]

TEST [[
---@generic T
---@type fun(x: T):T
local f

local <?<!v2!>?> = f(<!function () end!>)
]]

TEST [[
---@generic T
---@param x T
---@return fun():T
local function f(x) end

local v1 = f(<!function () end!>)
local <?<!v2!>?> = v1()
]]

TEST [[
---@generic T
---@type fun(x: T):fun():T
local f

local v1 = f(<!function () end!>)
local <?<!v2!>?> = v1()
]]

TEST [[
---@generic V
---@return fun(x: V):V
local function f(x) end

local v1 = f()
local <?<!v2!>?> = v1(<!function () end!>)
]]

TEST [[
---@generic V
---@param x V[]
---@return V
local function f(x) end

---@class A
local a
a.<!x!> = 1

---@type A[]
local b

local c = f(b)
c.<?x?>
]]

TEST [[
---@generic V
---@param x { [number]: V }
---@return V
local function f(x) end

---@class A
local a
a.<!x!> = 1

---@type { [number]: A }
local b

local c = f(b)
c.<?x?>
]]

TEST [[
---@generic V
---@param x { [number]: V }
---@return V
local function f(x) end

---@class A
local a
a.<!x!> = 1

---@type { [integer]: A }
local b

local c = f(b)
c.<?x?>
]]

TEST [[
---@generic V
---@param x { [integer]: V }
---@return V
local function f(x) end

---@class A
local a
a.x = 1

---@type { [number]: A }
local b

local c = f(b)
c.<?x?>
]]

TEST [[
---@generic V
---@param x { [number]: V }
---@return V
local function f(x) end

---@class A
local a
a.<!x!> = 1

---@type A[]
local b

local c = f(b)
c.<?x?>
]]

TEST [[
---@generic K
---@param x { [K]: number }
---@return K
local function f(x) end

---@class A
local a
a.<!x!> = 1

---@type { [A]: number }
local b

local c = f(b)
c.<?x?>
]]

TEST [[
---@generic K
---@param x { [K]: A }
---@return K
local function f(x) end

---@class A
local a
a.x = 1

---@type A[]
local b

local c = f(b)
c.<?x?>
]]

TEST [[
---@generic K
---@param x { [K]: number }
---@return K
local function f(x) end

---@class A
local a
a.<!x!> = 1

---@type { [A]: integer }
local b

local c = f(b)
c.<?x?>
]]

TEST [[
---@generic K
---@param x { [K]: integer }
---@return K
local function f(x) end

---@class A
local a
a.x = 1

---@type { [A]: number }
local b

local c = f(b)
c.<?x?>
]]

TEST [[
---@generic V
---@return fun(t: V[]):V
local function f() end

---@type A[]
local b

local f2 = f()

local <?<!c!>?> = f2(b)
]]

TEST [[
---@generic T, V
---@param t T
---@return fun(t: V[]):V
---@return T
local function f(t) end

---@class A
local a
a.<!x!> = 1

---@type A[]
local b

local f2, c = f(b)

local d = f2(c)
d.<?x?>
]]

TEST [[
---@generic V, T
---@param t T
---@return fun(t: V): V
---@return T
local function iterator(t) end

for <!v!> in iterator(<!function () end!>) do
    print(<?v?>)
end
]]

TEST [[
---@alias C <!fun()!>

---@type C[]
local v1

---@generic V, T
---@param t T
---@return fun(t: V[]): V
---@return T
local function iterator(t) end

for <!v!> in iterator(v1) do
    print(<?v?>)
end
]]

TEST [[
---@class TT<V>: { <!x!>: V }

---@type TT<A>
local t

---@class A: <!{}!>

print(t.<?x?>)
]]

TEST [[
---@alias TT<V> { <!x!>: V }

---@type TT<A>
local t

---@class A: <!{}!>

print(t.<?x?>)
]]

TEST [[
---@class TT<V>: { [number]: V }

---@type TT<<!{}!>>
local v1

---@generic V, T
---@param t T
---@return fun(t: { [number]: V }): V
---@return T
local function iterator(t) end

for <!v!> in iterator(v1) do
    print(<?v?>)
end
]]

TEST [[
---@class TT<K, V>: { [K]: V }

---@type TT<number, <!{}!>>
local v1

---@generic V, T
---@param t T
---@return fun(t: { [number]: V }): V
---@return T
local function iterator(t) end

for <!v!> in iterator(v1) do
    print(<?v?>)
end
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:<!bar1!>() end

---@type { [number]: Foo }
local v1

---@generic T: table, V
---@param t T
---@return fun(table: { [number]: V }, i?: integer):integer, V
---@return T
---@return integer i
local function ipairs(t) end

for i, v in ipairs(v1) do
    print(v.<?bar1?>)
end
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:<!bar1!>() end

---@type table<number, Foo>
local v1

---@generic T: table, V
---@param t T
---@return fun(table: { [number]: V }, i?: integer):integer, V
---@return T
---@return integer i
local function ipairs(t) end

for i, v in ipairs(v1) do
    print(v.<?bar1?>)
end
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:<!bar1!>() end

---@type table<Foo, Foo>
local v1

---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

for k, v in pairs(v1) do
    print(k.bar1)
    print(v.<?bar1?>)
end
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:<!bar1!>() end

---@type table<Foo, Foo>
local v1

---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

for k, v in pairs(v1) do
    print(k.<?bar1?>)
    print(v.bar1)
end
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:<!bar1!>() end

---@generic T: table, V
---@param t T
---@return fun(table: table<number, V>, i?: integer):integer, V
---@return T
---@return integer i
local function ipairs(t) end

---@type table<number, table<number, Foo>>
local v1
for i, v in ipairs(v1) do
    local v2 = v[1]
    print(v2.<?bar1?>)
end
]]

TEST [[
---@class Foo
local Foo = {}
function Foo:<!bar1!>() end

---@type table<number, table<number, Foo>>
local v1
print(v1[1][1].<?bar1?>)
]]

TEST [[
---@class X

---@class Y
---@field <!a!> string

---@class Z:X, Y

---@type Z
local z
z.<?a?>
]]

TEST [[
---@type { <!x!>: number, y: number }
local t

print(t.<?x?>)
]]

TEST [[
---@class A
---@field [1]? <!{}!>
local t

local <!<?v?>!> = t[1]
]]

TEST [[
---@type { [1]?: <!{}!> }
local t

local <!<?v?>!> = t[1]
]]

TEST [[
---@class A
---@field [<!'xx'!>]? <!{}!>
local t

print(t.<?xx?>)
]]

TEST [[
---@type { [<!'xx'!>]?: boolean }
local t

print(t.<?xx?>)
]]

TEST [[
---@class A
local <!t!>

t.f = function (self)
end

<?t?>
]]

TEST [[
---@class A
local t = {
    <!x!> = nil,
}

---@type A
local f
f.<?x?>
]]

TEST [[
---@class A
G = {
    <!x!> = nil,
}

---@type A
local f
f.<?x?>
]]

TEST [[
---@class <!XXX!><K, V>: {}

---@type <?XXX?><>
]]

TEST [[
---@class <!YYY!>

---@type XXX<<?YYY?>>
]]

TEST [[
local <!x!>

---@cast <?x?> integer
]]

TEST [[
local function f()
    local <!x!>

    ---@cast <?x?> integer
end
]]

TEST [[
---@class A
---@field <!x!> number

---@param a A
local function f(a) end

f {
    <!<?x?>!> = 1,
}
]]

TEST [[
---@class A
local a
a.__index = a

---@class B: A
local b
b.<!<?__index?>!> = b
]]

TEST [[
---@class myClass
local myClass = { nested = {} }

function myClass.nested.<!fn!>() end

---@type myClass
local class

class.nested.<?fn?>()
]]

TEST [[
---@class myClass
local myClass = { has = { nested = {} } }

function myClass.has.nested.<!fn!>() end

---@type myClass
local class

class.has.nested.<?fn?>()
]]

TEST [[
---@type table<string, integer>
local x = {
    <!a!> = 1,
    b = 2,
    c = 3
}

print(x.<?a?>)
]]

config.set(nil, 'Lua.type.castNumberToInteger', true)

TEST [[
---@class <!A!>

---@class <!<?A?>!>
]]

TEST [[
---@alias <!A!> number

---@alias <!<?A?>!> number
]]
