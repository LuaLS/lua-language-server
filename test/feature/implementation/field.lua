TEST_IMPL [[
local mt
mt.<!x!> = 1
print(mt.<?x?>)
]]

TEST_IMPL [[
local mt = {}
function mt.<!draw!>() end
print(mt.<?draw?>)
]]

TEST_IMPL [[
local mt = {
    <!draw!> = <!function () end!>,
}
print(mt.<?draw?>)
]]

TEST_IMPL [[
local mt = {
    <!draw!> = <!function () end!>,
}
mt.<?draw?>()
]]

TEST_IMPL [[
mt.<!x!> = 1
mt.<!x!> = 2
print(mt.<?x?>)
]]
