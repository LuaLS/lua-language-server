TEST_HOVER [[
---@type integer
local x
print(x<??>)
]] ('```lua\ninteger\n```')

TEST_HOVER [[
---@type string|integer
local x
print(x<??>)
]] (function (value)
    assert(value)
    assert(value:find('```lua\nstring\n```', 1, true))
    assert(value:find('```lua\ninteger\n```', 1, true))
    assert(value:find('\n\n---\n\n', 1, true))
end)
