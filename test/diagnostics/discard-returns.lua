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
