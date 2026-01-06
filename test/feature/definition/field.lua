TEST_DEF [[
X.<!y!> = 1

print(X.<?y?>)
]]

TEST_DEF [[
local x = {}
x.<!y!> = 1

print(x.<?y?>)
]]

TEST_DEF [[
X.<!y!> = 1

local t = X

print(t.<?y?>)
]]

TEST_DEF [[
X.x.<!y!> = 1

local t = X.x

print(t.<?y?>)
]]

TEST_DEF [[
X.x.<!y!> = 1

local t = X

print(t.x.<?y?>)
]]
