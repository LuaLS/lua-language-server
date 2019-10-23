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
