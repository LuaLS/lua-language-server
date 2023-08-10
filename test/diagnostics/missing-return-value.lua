TEST [[
---@type fun():number
local function f()
    <!return!>
end
]]
