TEST [[
local x = 5
<!x()!>

---@overload fun(): string
local x = 5
x()

---@class x
---@operator call(): string
local x = {}
x()
]]

TEST [[
---@type nil
local x
<!x()!>

---@overload fun(): string
local x
x()

---@class x
---@operator call(): string
local x
x()
]]

TEST [[
---@type unknown
local x
x()
]]

TEST [[
local function f()
end
f()
]]

TEST [[
<!(0)()!>
]]

TEST [[
<!("")()!>
]]

TEST [[
(function() end)()
]]

TEST [[
local _ = 1 + 2
local _ = <!"1" + "2"!>
]]

TEST [[
local _ = "a" .. "b"
---@class Vec2

---@type Vec2, Vec2
local a, b = {}, {}
local _ = <!a .. b!>
]]

TEST [[
---@type unknown
local a
local b = a + 2
]]

TEST [[
---@param name string
---@return string
local function greet(name)
    return "Hello " .. <!name "!"!>
end
]]
