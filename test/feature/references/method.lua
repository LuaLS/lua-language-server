TEST_REF [[
local mt = {}
function mt.<!m1!>() end
mt.<?<!m1!>?>()
]]

TEST_REF [[
local mt = {}
function mt:<!m1!>() end
mt:<?<!m1!>?>()
]]

TEST_REF [[
local mt = {}
<?function?> mt:<!m1!>()
end
mt:<!m1!>()
]]

TEST_REF [[
function <!foo!>()
end
<?<!foo!>?>()
]]

TEST_REF [[
<?function?> <!foo!>()
end

<!foo!>()
]]

TEST_REF [[
local f = <?function?> () end
<!f()!>
]]

TEST_REF [[
<!(<?function?> () end)()!>
]]

TEST_REF [[
local function foo()
    return <?function?> () end
end

<!foo()()!>
]]
