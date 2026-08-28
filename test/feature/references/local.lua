TEST_REF [[
local <!x!> = 1
print(<!x!>)
print(<?<!x!>?>)
]]

TEST_REF [[
<!x!> = 1
<!x!> = 2
print(<?<!x!>?>)
]]

TEST_REF([[
x = 1
<?<!x!>?>
]], false)

TEST_REF [[
local <!mt!> = {}
function <!mt!>:f()
    <?<!self!>?>:f()
end
]]

TEST_REF [[
local function f(<!a!>)
    return <?<!a!>?>
end
]]
