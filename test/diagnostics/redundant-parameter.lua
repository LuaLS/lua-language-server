TEST [[
local function x(a, b)
    return a, b
end
x(1, 2, <!3!>)
]]

TEST [[
local function x(a, b, ...)
    return a, b, ...
end
x(1, 2, 3, 4, 5)
]]

TEST [[
---@type fun(a, b, ...)
local x
x(1, 2, 3, 4, 5)
]]

TEST [[
local m = {}
function m:x(a, b)
    return a, b
end
m:x(1, 2, <!3!>)
]]

TEST [[
local m = {}
function m:x(a, b)
    return a, b
end
m.x(m, 2, 3, <!4!>)
]]

TEST [[
local m = {}
function m.x(a, b)
    return a, b
end
m:x(1, <!2!>, <!3!>, <!4!>)
]]
