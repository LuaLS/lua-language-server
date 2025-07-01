-- Test for readonly for-loop variables in Lua 5.5
-- Note: These now produce parser errors instead of diagnostics

TEST [[
---@language Lua 5.5
for i = 1, 10 do
    i = 5  -- This is now a parser error, so no diagnostic
end
]]

TEST [[
---@language Lua 5.5
for k, v in pairs(t) do
    k = "new"  -- This is now a parser error, so no diagnostic
    v = 123    -- This is now a parser error, so no diagnostic
end
]]

TEST [[
---@language Lua 5.5
for i = 1, 10 do
    for j = 1, 5 do
        i = j  -- This is now a parser error, so no diagnostic
        j = i  -- This is now a parser error, so no diagnostic
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