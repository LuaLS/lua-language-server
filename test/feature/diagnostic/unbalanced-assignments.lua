TEST_DIAGNOSTIC [[
local x, <?y?> = 1
print(x, y)
]] { 'unbalanced-assignments' }

TEST_DIAGNOSTIC [[
local x, y = 1, 2
print(x, y)
]] {}

TEST_DIAGNOSTIC [[
local x, y = f()
print(x, y)
]] {}

TEST_DIAGNOSTIC [[
local x, <?y?>, <?z?> = 1
print(x, y, z)
]] { 'unbalanced-assignments', 'unbalanced-assignments' }

TEST_DIAGNOSTIC [[
local a, b
a, <?b?> = 1
print(a, b)
]] { 'unbalanced-assignments' }

TEST_DIAGNOSTIC [[
local t = {}
t.a, <?t.b?> = 1
print(t.a, t.b)
]] { 'unbalanced-assignments' }
