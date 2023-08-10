TEST [[
---@type fun():number
local function f()
    return 1, <!true!>
end
]]
