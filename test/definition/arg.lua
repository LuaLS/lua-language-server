TEST [[
local function xx (<!xx!>)
    <?xx?> = 1
end
]]

TEST [[
local function x (x, <!...!>)
    x = <?...?>
end
]]

TEST [[
function mt<!:!>x()
    <?self?> = 1
end
]]

TEST [[
function mt:x(<!self!>)
    <?self?> = 1
end
]]
