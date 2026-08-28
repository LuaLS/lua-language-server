TEST_IMPL [[
---@class Shape
---@field <?draw?> fun(self: Shape)

---@class Circle : Shape
local Circle = {}
function Circle:<!draw!>() end
]]

TEST_IMPL [[
---@class A
---@field <?m?> fun(self: A)

---@class B : A
local B = {}
function B:<!m!>() end

---@class C : B
local C = {}
function C:<!m!>() end
]]

TEST_IMPL [[
---@class Shape
---@field <?draw?> fun(self: Shape)

---@class Circle : Shape
local Circle = {
    <!draw!> = function () end,
}
]]

TEST_IMPL [[
---@class Shape
---@field draw fun(self: Shape)

---@class <!Circle!> : <?Shape?>
local Circle = {}
]]

TEST_IMPL [[
---@class Shape
---@field <?draw?> fun(self: Shape)

---@class Circle : Shape
local Circle = {}
]]
