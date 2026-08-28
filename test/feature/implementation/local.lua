TEST_IMPL [[
local <!x!> = 1
print(<?x?>)
]]

TEST_IMPL [[
local <!x!> = 1
<!x!> = 2
<!x!> = 3
print(<?x?>)
]]

TEST_IMPL [[
<!x!> = 1
do
    <!x!> = 2
end
print(<?x?>)
]]

TEST_IMPL [[
local function f(a)
    <!a!> = 1
    return <?a?>
end
]]

TEST_IMPL [[
local x
print(<?x?>)
]]

TEST_IMPL [[
local <!mt!> = {}
function mt:f()
    <?self?>:f()
end
]]
