TEST_DIAGNOSTIC [[
local x = 1, <?2?>
print(x)
]] { 'redundant-value' }

TEST_DIAGNOSTIC [[
local x = 1
print(x)
]] {}

TEST_DIAGNOSTIC [[
local x = f()
print(x)
]] {}

TEST_DIAGNOSTIC [[
local x, y = 1, 2
print(x, y)
]] {}
