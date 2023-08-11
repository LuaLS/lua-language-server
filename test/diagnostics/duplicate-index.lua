TEST [[
return {
    <!x!> = 1,
    y = 2,
    <!x!> = 3,
}
]]

TEST [[
return {
    x = 1,
    y = 2,
}, {
    x = 1,
    y = 2,
}
]]

TEST [[
return {
    1, <!2!>, 3,
    [<!2!>] = 4,
}
]]
