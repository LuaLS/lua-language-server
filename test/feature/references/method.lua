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
function <!foo!>()
end
<?<!foo!>?>()
]]

TEST_REF [[
local <!mt!> = {}
function <!mt!>:f()
    return <?<!self!>?>
end
]]
