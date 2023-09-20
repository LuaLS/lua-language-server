TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = <!{}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = <!{
    x = 1,
}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = <!{
    x = 1,
    y = 2,
}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = {
    x = 1,
    y = 2,
    z = 3,
}
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = {
    x = 1,
    z = 3,
}
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@param a A
local function f(a) end

f <!{}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@param a A
local function f(a) end

f <!{
    x = 1,
}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@param a A
local function f(a) end

f <!{
    x = 1,
    y = 2,
}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@param a A
local function f(a) end

f {
    x = 1,
    y = 2,
    z = 3,
}
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@param a A
local function f(a) end

f {
    x = 1,
    z = 3,
}
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
local t = {}
]]

TEST [[
---@diagnostic disable: unused-local

---@class A
---@field x number

---@class A
local t = {}
]]

TEST [[
---@diagnostic disable: unused-local

---@class Foo
---@field a number
---@field b number
---@field c number

---@type Foo|Foo[]
local a = {
    {
        a = 1,
        b = 2,
        c = 3,
    }
}
]]

TEST [[
---@diagnostic disable: unused-local

---@class Foo
---@field a number
---@field b number
---@field c number

---@class Bar
---@field ba number
---@field bb number
---@field bc number

---@type Foo|Bar
local b = {
    a = 1,
    b = 2,
    c = 3,
}
]]

TEST [[
---@class A
---@field x integer

---@type A
return <!{}!>
]]

TEST [[
---@class A
---@field x number

---@class B
---@field y number

---@type A|B
local t = <!{
    z = 1,
}!>
]]

TEST [[
---@class A
---@field x number

---@class B
---@field y number

---@type A|B
local t = {
    y = 1,
}
]]
