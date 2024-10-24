local config = require 'config'

TEST [[
---@class A
local a = {}
a.<~x~> = 1

---@return A
local function f() end

local b = f()
return b.<!x!>
]]

TEST [[
---@class A
local a = {}
a.<~x~> = 1

---@return table
---@return A
local function f() end

local a, b = f()
return a.x, b.<!x!>
]]

TEST [[
local <~mt~> = {}
function <!mt!>:x()
    self:x()
end
]]

TEST [[
local mt = {}
function mt:<~x~>()
    self:<!x!>()
end
]]

--TEST [[
-----@class Dog
--local mt = {}
--function mt:<~eat~>()
--end
--
-----@class Master
--local mt2 = {}
--function mt2:init()
--    ---@type Dog
--    local foo = self:doSomething()
--    ---@type Dog
--    self.dog = getDog()
--end
--function mt2:feed()
--    self.dog:<!eat!>()
--end
--function mt2:doSomething()
--end
--]]

-- TODO: How to search references of function?
--[=[
TEST [[
local function f()
    return <~<!function~> ()
    end!>
end

local <!f2!> = f()
]]

TEST [[
local function f()
    return nil, <~<!function~> ()
    end!>
end

local _, <!f2!> = f()
]]
]=]

TEST [[
---@class A
local t

---@class B: A
local <~v~>
]]

TEST [[
---@class Dog
local Dog = {}
function Dog:<~eat~>()
end

---@generic T
---@param type1 T
---@return T
function foobar(type1)
    return {}
end

local v1 = foobar(Dog)
v1:<!eat!>()
]]

TEST [[
---@class Dog
local Dog = {}
function Dog:<~eat~>()
end

---@class Master
local Master = {}

---@generic T
---@param type1 string
---@param type2 T
---@return T
function Master:foobar(type1, type2)
    return {}
end

local v1 = Master:foobar("", Dog)
v1.<!eat!>()
]]

TEST [[
---@class A
A = {}

function A:<~TestA~>()
end

---@param param A
function TestB(param)
    param:<!TestA!>()
end
]]

TEST [[
---@class A
---@field <~x~> number

---@type A
local t = {
    <!x!> = 1
}
]]
