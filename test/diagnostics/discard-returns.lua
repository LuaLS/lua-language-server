TEST [[
---@nodiscard
local function f()
    return 1
end

<!f()!>
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

X = f()
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

for i = 1, 2 do
    <!f()!>
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

for i = 1, 2 do
    local v = f()
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

while true do
    <!f()!>
    break
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

while true do
    local v = f()
    break
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

repeat
    <!f()!>
    break
until true
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

repeat
    local v = f()
    break
until true
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

for index, value in ipairs({}) do
    <!f()!>
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

for index, value in ipairs({}) do
    local v = f()
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

if 1 == 1 then
    <!f()!>
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

if 1 == 1 then
    local v = f()
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

if 1 == 1 then
    local v = f()
else
    <!f()!>
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

if 1 == 1 then
    local v = f()
else
    local v = f()
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

if 1 == 1 then
    local v = f()
elseif 1 == 2 then
    <!f()!>
else
    local v = f()
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

if 1 == 1 then
    local v = f()
elseif 1 == 2 then
    local v = f()
else
    local v = f()
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

local function bar(callback)
end

bar(function ()
    <!f()!>
end)
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

local function bar(callback)
end

bar(function ()
    local v = f()
end)
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

do
    <!f()!>
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

do
    local v = f()
end
]]

TEST [[
---@nodiscard
local function f()
    return 2
end

for i = 1, f() do
end
]]

TEST [[
---@nodiscard
local function list_iter(t)
    local i = 0
    local n = #t
    return function ()
        i = i + 1
        if i <= n then return t[i] end
    end
end

local t = {10, 20, 30}
for element in list_iter(t) do
end
]]

TEST [[
---@nodiscard
local function f()
    return 1
end

if f() then
end
]]
