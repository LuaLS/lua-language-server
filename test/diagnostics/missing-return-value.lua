TEST [[
---@type fun():number
local function f()
    <!return!>
end
]]

TEST [[
---@return number
function F()
    <!return!>
end
]]

TEST [[
---@return number, number
function F()
    <!return!> 1
end
]]

TEST [[
---@return number, number?
function F()
    return 1
end
]]

TEST [[
---@return ...
function F()
    return
end
]]
