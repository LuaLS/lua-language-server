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
