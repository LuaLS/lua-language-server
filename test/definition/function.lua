
TEST [[
function <!x!> () end
<?x?>()
]]

TEST [[
local function <!x!> () end
<?x?>()
]]

TEST [[
local x
local function <!x!> ()
    <?x?>()
end
]]

TEST [[
local <!x!>
function <!x!>()
end
<?x?>()
]]

TEST [[
local <!f!> = function () end
<?f?>()
]]
