TEST [[
<!print()
('string')!>:sub(1, 1)
]]

TEST [[
print()
('string')
]]

TEST [[
print
{}
{}
]]

TEST [[
local x
return x
    : f(1)
    : f(1)
]]

TEST [[
print()
'string'
]]

TEST [[
print
{
    x = 1,
}
]]
