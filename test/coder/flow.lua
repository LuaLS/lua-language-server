local rt = test.scope.rt

do
    TEST_INDEX [[
    local x = 10
    X = x
    x = 5
    X2 = x
    ]]

    local X = rt:globalGet('X')
    local X2 = rt:globalGet('X2')
    assert(X:view() == '10')
    assert(X2:view() == '5')
end

do
    TEST_INDEX [[
    local x
    X0 = x
    x = 10
    X1 = x
    x = 5
    X2 = x
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    assert(X0:view() == '5 | 10')
    assert(X1:view() == '10')
    assert(X2:view() == '5')
end
