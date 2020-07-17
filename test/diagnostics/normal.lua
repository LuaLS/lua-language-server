local config = require 'config'

TEST [[
local <!x!>
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
x = <!function () end!>
]]


TEST [[
print(<!x!>)
print(<!log!>)
print(<!X!>)
print(<!Log!>)
print(_VERSION)
print(<!y!>)
print(Z)
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
print(1)
_ENV = nil
]]

config.config.diagnostics.disable['undefined-env-child'] = true
TEST [[
_ENV = nil
<!GLOBAL!> = 1 --> _ENV.GLOBAL = 1
]]

TEST [[
_ENV = nil
local _ = <!GLOBAL!> --> local _ = _ENV.GLOBAL
]]

TEST [[
_ENV = {}
GLOBAL = 1 --> _ENV.GLOBAL = 1
]]

TEST [[
_ENV = {}
local _ = GLOBAL --> local _ = _ENV.GLOBAL
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

TEST [[
local mt, x
function mt:m()
    function x:m()
    end
end
]]

TEST [[
local mt = {}
function mt:f()
end
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

require 'config' .config.runtime.version = 'Lua 5.3'
TEST [[
<!warn!>(1)
]]

TEST [[
X = table[<!x!>]
]]

TEST [[
return {
    <!x = 1!>,
    y = 2,
    <!x!> = 3,
}
]]

TEST [[
return {
    <!x = 1!>,
    y = 2,
    <!['x']!> = 3,
}
]]

TEST [[
return {
    <!['x'] = 1!>,
    y = 2,
    <!['x']!> = 3,
}
]]

TEST [[
return {
    <!['x'] = 1!>,
    y = 2,
    <!x!> = 3,
}
]]

TEST [[
local m = {}
function m.open()
end

m:open()
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
local f <close> = io.open()
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
---@field <!x!> Class
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

--TEST [[
--local t = {}
--function t:<!a!>()
--end
--function t:<!a!>()
--end
--]]

TEST [[
local t = {}
t.a = 1
t.a = 2
]]

--TEST [[
--for k, v in pairs {1, 2, 3, 4 ,5} do
--    print(k, v)
--    <!k!> = 1
--    print(v)
--end
--]]

TEST [[
for i = 1, 10 do
    <!i!> = 2
    print(i)
end
]]

TEST [[
---@type table<number, boolean|string[]>
local t
print(t)
]]
