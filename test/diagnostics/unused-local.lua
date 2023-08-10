TEST [[
local <!x!>
]]

TEST [[
local y
local x <close> = y
]]

TEST [[
local function x()
end
x()
]]

TEST [[
return function (x)
    x.a = 1
end
]]

TEST [[
local <!t!> = {}
<!t!>.a = 1
]]
