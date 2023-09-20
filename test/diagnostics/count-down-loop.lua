TEST [[
for i = <!10, 1!> do
    print(i)
end
]]

TEST [[
for i = <!10, 1, 5!> do
    print(i)
end
]]

TEST [[
for i = <!100, 10, 1!> do
    print(i)
end
]]

TEST [[
for i = <!1, -10!> do
    print(i)
end
]]

TEST [[
for i = 1, 1 do
    print(i)
end
]]
