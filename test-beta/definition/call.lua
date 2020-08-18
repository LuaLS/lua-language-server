TEST [[
function f()
    local <!x!>
    return <!x!>
end
local <!y!> = f()
print(<?y?>)
]]
