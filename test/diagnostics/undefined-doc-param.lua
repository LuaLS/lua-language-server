TEST [[
---@param <!x!> Class
]]

TEST [[
---@class Class
---@param <!y!> Class
local function f(x)
    return x
end
f()
]]

TEST [[
---@class Class
---@param <!y!> Class
function F(x)
    return x
end
F()
]]
