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
