-- Test for readonly for-loop variables in Lua 5.5

TEST [[
---@language Lua 5.5
for i = 1, 10 do
    <!i!> = 5  -- Error: Cannot assign to for-loop variable
end
]]

TEST [[
---@language Lua 5.5
for k, v in pairs(t) do
    <!k!> = "new"  -- Error: Cannot assign to for-loop variable
    <!v!> = 123    -- Error: Cannot assign to for-loop variable
end
]]

TEST [[
---@language Lua 5.5
for i = 1, 10 do
    for j = 1, 5 do
        <!i!> = j  -- Error: Cannot assign to outer for-loop variable
        <!j!> = i  -- Error: Cannot assign to inner for-loop variable
    end
end
]]

-- Should not trigger for Lua 5.4
TEST [[
---@language Lua 5.4
for i = 1, 10 do
    i = 5  -- No error in Lua 5.4
end
]]

-- Should not trigger for regular locals
TEST [[
---@language Lua 5.5
local x = 10
for i = 1, 10 do
    x = i  -- No error: x is not a for-loop variable
end
]]