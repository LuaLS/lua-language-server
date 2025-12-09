local rt = test.scope.rt

do
    --[[
    local x = 10
    x --> 10
    x = 5
    x --> 5
    ]]

    local x = rt.variable 'x'
    x:addAssign(rt.field('x', rt.value(10)))
    x.currentValue = rt.value(10)

    local x2 = x:shadow()
    x2:addAssign(rt.field('x', rt.value(5)))
    x2.currentValue = rt.value(5)

    assert(x:view() == '10')
    assert(x2:view() == '5')
end

do
    --[[
    local x
    x --> 5 | 10
    x = 10
    x --> 10
    x = 5
    x --> 5
    ]]

    local x = rt.variable 'x'
    local x1 = x:shadow()

    x1:addAssign(rt.field('x', rt.value(10)))
    x1.currentValue = rt.value(10)

    local x2 = x1:shadow()
    x2:addAssign(rt.field('x', rt.value(5)))
    x2.currentValue = rt.value(5)

    assert(x:view() == '5 | 10')
    assert(x1:view() == '10')
    assert(x2:view() == '5')
end
