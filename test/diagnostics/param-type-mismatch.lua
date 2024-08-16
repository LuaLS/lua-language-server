local config = require "config.config"
TEST [[
---@param x number
local function f(x) end

f(<!true!>)
]]

TEST [[
---@class A

---@param n A
local function f(n)
end

---@class B
local a = {}

---@type A?
a.x = XX

f(a.x)
]]
TEST [[
---@alias A string|boolean

---@param x string|boolean
local function f(x) end

---@type A
local x

f(x)
]]

TEST [[
---@alias A string|boolean

---@param x A
local function f(x) end

---@type string|boolean
local x

f(x)
]]

TEST [[
---@param b boolean
local function f(b)
end

---@type boolean
local t

if t then
    f(t)
end
]]

TEST [[
---@enum A
local t = {
    x = 1,
    y = 2,
}

---@param x A
local function f(x)
end

f(<!t!>)
f(t.x)
f(1)
f(<!3!>)
]]

TEST [[
---@enum A
local t = {
    x = { h = 1 },
    y = { h = 2 },
}

---@param x A
local function f(x)
end

f(t.x)
f(t.y)
f(<!{ h = 1 }!>)
]]

TEST [[
---@enum(key) A
local t = {
    x = 1,
    ['y'] = 2,
}

---@param x A
local function f(x)
end

f('x')
f('y')
f(<!'z'!>)
]]

TEST [[
---@generic T: string | boolean | table
---@param x T
---@return T
local function f(x)
    return x
end

f(<!1!>)
]]

TEST [[
---@param opts {a:number, b:number}
local function foo(opts)

end

---@param opts {a:number, b:number}
local function bar(opts)
    foo(opts)
end
]]

TEST [[
---@param opts {a:number, b:number}
local function foo(opts)

end

---@param opts {c:number, d:number}
local function bar(opts)
    foo(<!opts!>)  -- this should raise linting error
end
]]

TEST [[
---@param opts {[number]: boolean}
local function foo(opts)

end

---@param opts {[1]: boolean}
local function bar(opts)
    foo(opts)
end
]]

TEST [[
---@generic T
---@param v1 T
---@param v2 T|table
local function func(v1, v2)
end

func('hello', 'world')
]]

TEST [[
---@generic T1, T2, T3, T4, T5
---@param f fun(): T1?, T2?, T3?, T4?, T5?
---@return T1?, T2?, T3?, T4?, T5?
local function foo(f)
    return f()
end

local a, b = foo(function()
    return 1
end)
]]

TEST [[
---@generic T1, T2, T3, T4, T5
---@param f fun(): T1|nil, T2|nil, T3|nil, T4|nil, T5|nil
---@return T1?, T2?, T3?, T4?, T5?
local function foo(f)
    return f()
end

local a, b = foo(function()
    return 1
end)
]]

TEST [[
---@param v integer
---@return boolean
local function is_string(v)
    return type(v) == 'string'
end

print(is_string(3))
]]

TEST [[
---@param p integer|string
local function get_val(p)
    local is_number = type(p) == 'number'
    return is_number and p or p
end

get_val('hi')
]]

TEST [[
---@class Class
local Class = {}

---@param source string
function Class.staticCreator(source)

end

Class.staticCreator(<!true!>)
Class<!:!>staticCreator() -- Expecting a waring
]]

TEST [[
---@class A

---@class B : A

---@class C : B

---@class D : B

---@param x A
local function func(x) end

---@type C|D
local var
func(var)
]]

TEST [[
---@class MyClass
---@overload fun(x : string) : MyClass
local MyClass = {}

local w = MyClass(<!1!>)
]]

TEST [[
---@enum(key) A
local t1 = {
    x = 1,
}

---@enum(key) A
local t2 = {
    y = 1,
}

---@param v A
local function f(v) end

f 'x'
f 'y'
]]

TEST [[
---@class A
---@field x string
---@field y number

local a = {x = "", y = 0}

---@param a A
function f(a) end

f(a)
]]

config.set(nil, 'Lua.type.checkTableShape', true)

TEST [[
---@class A
---@field x string
---@field y number

local a = {x = ""}

---@param a A
function f(a) end

f(<!a!>)
]]

TEST [[
---@class A
---@field x string
---@field y number

local a = {x = "", y = ""}

---@param a A
function f(a) end

f(<!a!>)
]]

TEST [[
---@class A
---@field x string
---@field y? B

---@class B
---@field x string

local a = {x = "b", y = {x = "c"}}

---@param a A
function f(a) end

f(a)
]]

TEST [[
---@class A
---@field x string
---@field y B

---@class B
---@field x string

local a = {x = "b", y = {}}

---@param a A
function f(a) end

f(<!a!>)
]]

TEST [[
---@class A
---@field x string

---@type A
local a = {}

---@param a A
function f(a) end

f(a)
]]

config.set(nil, 'Lua.type.checkTableShape', false)
