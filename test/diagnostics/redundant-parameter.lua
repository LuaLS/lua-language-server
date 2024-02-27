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
m.x(m, 2, 3, <!4!>)
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
mt.f(mt, 2, 3, <!4!>)
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
local f = load('')
if f then
    f(1, 2, 3)
end
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

m.open(m)
]]

TEST [[
table.insert({}, 1, 2, <!3!>)
]]

TEST [[
---@overload fun(...)
local function f() end

f(1)
]]

TEST [[
function F() end

---@param x boolean
function F(x) end

F(k())
]]

TEST [[
local function f()
    return 1, 2, 3
end

local function k()
end

k(<!f()!>)
]]

TEST [[
---@diagnostic disable: unused-local
local function f()
    return 1, 2, 3
end

---@param x integer
local function k(x)
end

k(f())
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

TEST [[
---@meta
---@diagnostic disable: duplicate-set-field
---@class A
local m = {}

function m.ff() end

function m.ff(x) end

m.ff(1)
]]
