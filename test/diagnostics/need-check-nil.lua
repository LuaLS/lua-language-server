TEST [[
---@type string?
local x

local s = <!x!>:upper()
]]

TEST [[
---@type string?
local x

S = <!x!>:upper()
]]

TEST [[
---@type string?
local x

if x then
    S = x:upper()
end
]]

TEST [[
---@type string?
local x

if not x then
    x = ''
end

S = x:upper()
]]

TEST [[
---@type fun()?
local x

S = <!x!>()
]]

TEST [[
---@type integer?
local x

T = {}
T[<!x!>] = 1
]]

TEST [[
local x, y
local z = x and y

print(z.y)
]]

TEST [[
local x, y
function x()
    y()
end

function y()
    x()
end

x()
]]
