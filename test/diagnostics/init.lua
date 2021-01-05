local core   = require 'core.diagnostics'
local files  = require 'files'
local config = require 'config'
local util   = require 'utility'

rawset(_G, 'TEST', true)

local function catch_target(script, ...)
    local list = {}
    local function catch(buf)
        local cur = 1
        local cut = 0
        while true do
            local start, finish  = buf:find('<!.-!>', cur)
            if not start then
                break
            end
            list[#list+1] = { start - cut, finish - 4 - cut }
            cur = finish + 1
            cut = cut + 4
        end
    end
    catch(script)
    if ... then
        for _, buf in ipairs {...} do
            catch(buf)
        end
    end
    local new_script = script:gsub('<!(.-)!>', '%1')
    return new_script, list
end

local function founded(targets, results)
    if #targets ~= #results then
        return false
    end
    for _, target in ipairs(targets) do
        for _, result in ipairs(results) do
            if target[1] == result[1] and target[2] == result[2] then
                goto NEXT
            end
        end
        do return false end
        ::NEXT::
    end
    return true
end

function TEST(script, ...)
    files.removeAll()
    local new_script, target = catch_target(script, ...)
    files.setText('', new_script)
    files.open('')
    local datas = {}
    core('', function (results)
        for _, res in ipairs(results) do
            datas[#datas+1] = res
        end
    end)
    local results = {}
    for i, data in ipairs(datas) do
        results[i] = { data.start, data.finish }
    end

    if results[1] then
        if not founded(target, results) then
            error(('%s\n%s'):format(util.dump(target), util.dump(results)))
        end
    else
        assert(#target == 0)
    end
end

TEST [[
local <!x!>
]]

TEST [[
local x <close> = print
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

TEST([[
<!local function x()
end!>
]],
[[
local function <!x!>()
end
]]
)

TEST [[
local <!x!> = <!function () end!>
]]

TEST [[
local <!x!>
<!x!> = <!function () end!>
]]

TEST([[
<!local function x()
end!>
<!local function y()
    x()
end!>
]],
[[
local function x()
end
local function <!y!>()
    x()
end
]]
)

TEST [[
print(<!x!>)
print(<!log!>)
print(<!X!>)
print(<!Log!>)
print(_VERSION)
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

config.config.diagnostics.disable['undefined-env-child'] = true
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

config.config.diagnostics.disable['undefined-env-child'] = nil
TEST [[
print()
<!('string')!>:sub(1, 1)
]]

TEST [[
print()
('string')
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
(''):sub(1, 2)
]]

TEST [=[
return [[   
   
]]
]=]

config.config.diagnostics.disable['close-non-object'] = true
TEST [[
local _ <close> = function () end
]]

config.config.diagnostics.disable['close-non-object'] = nil
TEST [[
local _ <close> = <!1!>
]]

config.config.diagnostics.disable['unused-local'] = true
TEST [[
local f = <!function () end!>
]]

TEST [[
local f;f = <!function () end!>
]]

TEST [[
<!local function f() end!>
]]

--TEST [[
--F = <!function () end!>
--]]
--
--TEST [[
--<!function F() end!>
--]]

config.config.diagnostics.disable['unused-local'] = nil
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
next({}, 1, <!2!>)
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
f(1, 2, 3)
]]

TEST [[
<!unpack!>(1)
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
local function x()
    do
        local k
        print(k)
        x()
    end
    local k = 1
    print(k)
end
]]

TEST [[
local function x()
    local loc
    x()
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

TEST [[
---@class <!Class!>
---@class <!Class!>
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
---@class <!A!>
---@class B
---@alias <!A B!>
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
f()
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
f()
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
    self.method1()
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
v2 = v
v2:method1()
v2:method2() -- 这个感觉实际应该报错更合适
]]

TEST [[
---@type table
T1 = {}
print(T1.f1)
---@type table*
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
