TEST [[
X.<!y!> = 1

local t = X

print(t.<?y?>)
]]

TEST [[
X.x.<!y!> = 1

local t = X.x

print(t.<?y?>)
]]

TEST [[
X.x.<!y!> = 1

local t = X

print(t.x.<?y?>)
]]

TEST [[
A = {}
A.<!c!> = function() end
A.<?c?>()
]]

TEST [[
local A = {}
A.<!c!> = function() end
A.<?c?>()
]]
