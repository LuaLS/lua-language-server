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

do
    TEST_INDEX [[
    a.b.c = 1
    X0 = a.b.c
    a.b.c = 2
    X1 = a.b.c
    a.b.c = 3
    X2 = a.b.c
    ]]

    local X0 = rt:globalGet('X0')
    local X1 = rt:globalGet('X1')
    local X2 = rt:globalGet('X2')
    assert(X0:view() == '1')
    assert(X1:view() == '2')
    assert(X2:view() == '3')

    local abc = rt:globalGet('a', 'b', 'c')
    assert(abc:view() == '1 | 2 | 3')
end

do
    TEST_INDEX [[
    local x = 0
    x = x + 1

    W = x
    ]]

    local W = rt:globalGet('W')
    assert(W:view() == 'op.add<0, 1>')
end
