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
