local rt = test.scope.rt

do
    TEST_INDEX [[
    do
        X = 1
    end
    ]]

    local X = rt:globalGet('X')
    assert(X:view() == '1')
end

do
    TEST_INDEX [[
    if true then
        X = 1
    elseif true then
        Y = 2
    else
        Z = 3
    end
    ]]

    local X = rt:globalGet('X')
    local Y = rt:globalGet('Y')
    local Z = rt:globalGet('Z')

    assert(X:view() == '1')
    assert(Y:view() == '2')
    assert(Z:view() == '3')
end

do
    TEST_INDEX [[
    function F(a, b)
    end
    ]]

    local F = rt:globalGet('F')
    assert(F:view() == 'fun(a: any, b: any)')
end

do
    TEST_INDEX [[
    function F(a, b)
        return
    end
    ]]

    local F = rt:globalGet('F')
    assert(F:view() == 'fun(a: any, b: any)')
end

do
    TEST_INDEX [[
    function F(a, b)
        return 1
    end
    ]]

    local F = rt:globalGet('F')
    assert(F:view() == 'fun(a: any, b: any):1')
end

do
    TEST_INDEX [[
    function F(a, b)
        return 1, 2
    end
    ]]

    local F = rt:globalGet('F')
    assert(F:view() == 'fun(a: any, b: any):(1, 2)')
end

do
    TEST_INDEX [[
    function F(a, b)
        return 1, 2
        return 3, 4
    end
    ]]

    local F = rt:globalGet('F')
    assert(F:view() == 'fun(a: any, b: any):(1 | 3, 2 | 4)')
end

do
    TEST_INDEX [[
    local function next()
        return 1, 2
    end
    for x, y in next do
        X = x
        Y = y
    end
    ]]

    local X = rt:globalGet('X')
    local Y = rt:globalGet('Y')
    assert(X:view() == '1')
    assert(Y:view() == '2')
end

do
    TEST_INDEX [[
    local function next()
        return 1, 2
    end
    local function pairs()
        return next
    end
    for x, y in pairs() do
        X = x
        Y = y
    end
    ]]

    local X = rt:globalGet('X')
    local Y = rt:globalGet('Y')
    assert(X:view() == '1')
    assert(Y:view() == '2')
end
