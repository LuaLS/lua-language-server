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
