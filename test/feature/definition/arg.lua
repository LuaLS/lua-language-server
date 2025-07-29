TEST [[
local function xx (<!xx!>)
    <?xx?>()
end
]]

TEST [[
local <!mt!>
function mt:x()
    <?self?>()
end
mt:x()
]]

TEST [[
function mt:x(<!self!>)
    <?self?>()
end
]]
