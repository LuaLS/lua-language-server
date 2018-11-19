TEST [[
local function x (<!x!>)
    <?x?> = 1
end
]]

TEST [[
local function x (x, <!...!>)
    x = <?...?>
end
]]
