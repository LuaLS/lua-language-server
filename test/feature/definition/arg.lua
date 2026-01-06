TEST_DEF [[
local function xx (<!xx!>)
    <?xx?>()
end
]]

TEST_DEF [[
local <!mt!>
function mt:x()
    <?self?>()
end
mt:x()
]]

TEST_DEF [[
local mt
function mt:x(<!self!>)
    <?self?>()
end
]]
