TEST [[
<!x!> = 1
<?x?>()
]]

TEST [[
do
    <!global!> = 1
end
<?global?>()
]]

TEST [[
<!x!> = 1
do
    local x = 1
end
<?x?>()
]]

TEST [[
x = 1
do
    local <!x!> = 1
    do
        <!x!> = 2
    end
    <?x?>()
end
]]

TEST [[
<!x!> = 1
if y then
    <!x!> = 2
else
    <!x!> = 3
end
print(<?x?>)
]]

TEST [[
_ENV.<!x!> = 1
print(<?x?>)
]]

TEST [[
_G.<!x!> = 1
print(<?x?>)
]]

TEST [[
<!rawset(_G, 'x', 1)!>
print(<?x?>)
]]
