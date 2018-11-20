
TEST [[
function <!x!> () end
<?x?> = 1
]]
    
TEST [[
local function <!x!> () end
<?x?> = 1
]]

TEST [[
local x
local function <!x!> ()
    <?x?> = 1
end
]]

TEST [[
local x
function <!x!>()
end
<?x?> = 1
]]
