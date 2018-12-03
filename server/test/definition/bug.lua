TEST [[
local <!x!>
function _(x)
end
function _()
    <?x?>()
end
]]

TEST [[
function _(<!x!>)
    do return end
    <?x?>()
end
]]

TEST [[
local <!a!>
function a:b()
    a:b()
    <?self?>()
end
]]

TEST [[
function _(...)
    function _()
        print(<?...?>)
    end
end
]]

TEST [[
local <!a!>
(<?a?> / b)()
]]
