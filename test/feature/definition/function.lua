
TEST_DEF [[
function <!x!> () end
<?x?>()
]]

TEST_DEF [[
local function <!x!> () end
<?x?>()
]]

TEST_DEF [[
local x
local function <!x!> ()
    <?x?>()
end
]]

TEST_DEF [[
local <!x!>
<!function x()
end!>
<?x?>()
]]

TEST_DEF [[
local <!f!> = <!function () end!>
<?f?>()
]]
