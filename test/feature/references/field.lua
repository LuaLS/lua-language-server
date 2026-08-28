TEST_REF [[
local mt = {}
mt.<!x!> = 1
print(mt.<!x!>)
mt.<?<!x!>?> = 2
]]

TEST_REF [[
local mt = {}
mt.<!a!> = {}
mt.<!a!>.b = 1
print(mt.<?<!a!>?>.b)
]]

TEST_REF [[
local t = {
    <!k!> = 1,
}
print(t.<!k!>)
print(t.<?<!k!>?>)
]]
