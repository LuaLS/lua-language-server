TEST [[
local <!t!>
a = {
    <?t?>
}
]]

TEST [[
local t
t.<!x!> = 1
t.<?x?>()
]]

TEST [[
t.<!x!> = 1
t.<?x?>()
]]

TEST [[
local <!t!>
t.x = 1
<?t?>.x = 1
]]

TEST [[
t.<!x!> = 1
t.<?x?>.y = 1
]]

TEST [[
local t
t.<!x!> = 1
t.<?x?>()
]]

TEST [[
local t
t[<!1!>] = 1
t[<?1?>]()
]]

TEST [[
local t
t[<!true!>] = 1
t[<?true?>]()
]]

TEST [[
local t
t[<!"method"!>] = 1
t[<?"method"?>]()
]]

TEST [[
local t
t[<!"longString"!>] = 1
t[ <?[==[longString]==]?> ]()
]]

TEST [[
local t
t.<!x!> = 1
t[<?'x'?>]()
]]

TEST [[
local t
t.<!a!> = 1
t.<?a?>.b()
]]

TEST [[
local t
local <!x!>
t[<?x?>]()
]]

TEST[[
local <!t!>
local _ = {
    _ = <?t?>
}
]]

TEST[[
local <!t!>
t {
    _ = <?t?>.x
}
]]

TEST[[
local t = {
    <!insert!> = 1,
}
t.<?insert?>()
]]

TEST[[
local t = {
    [<!'insert'!>] = 1,
}
t.<?insert?>()
]]

TEST[[
local t;t = {
    <!insert!> = 1,
}
t.<?insert?>()
]]

TEST[[
local t;t = {
    <!insert!> = 1,
}
t.<?insert?>()
]]

--TEST[[
--local t = {
--    <!insert!> = 1,
--}
--y.<?insert?>()
--]]

TEST[[
local t = {
    <!insert!> = 1,
}
local y = {
    insert = 1,
}
t.<?insert?>()
]]

TEST [[
local function f()
    local t = {}
    t.field1 = {
        <!x!> = 1,
        y = 1,
        z = 1,
    }
    t.field2 = {
        x = 1,
        y = 1,
        z = 1,
    }
    t.field3 = {
        x = 1,
        y = 1,
        z = 1,
    }
    return t
end
local t = f()
t.field1.<?x?>
]]

TEST [[
local t = { <!a!> }

print(t[<?1?>])
]]
