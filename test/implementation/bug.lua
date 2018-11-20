TEST [[
local <!x!>
function _(x)
end
function _()
    <?x?>
end
]]

TEST [[
function _(<!x!>)
    do return end
    <?x?> = 1
end
]]

TEST [[
local <!x!>
if 1 then
    x = 1
else
    <?x?> = 2
end
]]
