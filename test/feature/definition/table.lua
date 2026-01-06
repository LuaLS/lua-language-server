TEST_DEF [[
local <!t!>
a = {
    <?t?>
}
]]

TEST_DEF [[
local t
t.<!x!> = 1
t.<?x?>()
]]

TEST_DEF [[
t.<!x!> = 1
t.<?x?>()
]]

TEST_DEF [[
local <!t!>
t.x = 1
<?t?>.x = 1
]]

TEST_DEF [[
t.<!x!> = 1
t.<?x?>.y = 1
]]

TEST_DEF [[
local t
t.<!x!> = 1
t.<?x?>()
]]

--TEST [[
--local t
--t[<!1!>] = 1
--t[<?1?>]()
--]]

--TEST [[
--local t
--t[<!true!>] = 1
--t[<?true?>]()
--]]

TEST_DEF [[
local t
t[<!"method"!>] = 1
t[<?"method"?>]()
]]

TEST_DEF [[
local t
t[<!"longString"!>] = 1
t[ <?[==[longString]==]?> ]()
]]

TEST_DEF [[
local t
t.<!x!> = 1
t[<?'x'?>]()
]]

TEST_DEF [[
local t
t.<!a!> = 1
t.<?a?>.b()
]]

TEST_DEF [[
local t
local <!x!>
t[<?x?>]()
]]

TEST_DEF[[
local <!t!>
local _ = {
    _ = <?t?>
}
]]

TEST_DEF[[
local <!t!>
t {
    _ = <?t?>.x
}
]]

TEST_DEF[[
local t = {
    <!insert!> = 1,
}
t.<?insert?>()
]]

TEST_DEF[[
local t = {
    [<!'insert'!>] = 1,
}
t.<?insert?>()
]]

TEST_DEF[[
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

TEST_DEF[[
local t = {
    <!insert!> = 1,
}
local y = {
    insert = 1,
}
t.<?insert?>()
]]


TEST_DEF [[
local x
x.y.<!z!> = 1
print(x.y.<?z?>)
]]


TEST_DEF [[
local x
x.y = {
    <!z!> = 1
}
print(x.y.<?z?>)
]]

TEST_DEF [[
local x = {
    y = {
        <!z!> = 1
    }
}
print(x.y.<?z?>)
]]

TEST_DEF [[
local function f()
    local t = {
        <!x!> = 1,
    }
    return t
end
local t = f()
t.<?x?>
]]

--TEST [[
--local t = { <!a!> }
--
--print(t[<?1?>])
--]]

TEST_DEF [[
local t = {
    <?x?> = 1,
}

local y

t.x = y
]]
