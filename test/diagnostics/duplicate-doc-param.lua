TEST [[
---@class Class
---@param <!x!> Class
---@param y Class
---@param <!x!> Class
local function f(x, y)
    return x, y
end

local _
f(_, _)
]]
