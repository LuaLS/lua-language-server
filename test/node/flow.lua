local rt = test.scope.rt

do
    --[[
    local x = 10
    x --> 10
    x = 5
    x --> 5
    V = x
    ]]

    local flow = rt.flow({ uri = test.fileUri, offset = 0 })

    local x = rt.variable 'x'
    x:setCurrentValue(rt.value(10))
    flow:addVariable(x, 0)

    local x2 = x:shadow(rt.value(5))
    x2:addAssign(rt.field('x', rt.value(5)))
    flow:addVariable(x2, 20)

    local V = rt.variable 'V'
    V:addAssign(rt.field('V', x2))
    flow:addVariable(V, 30)

    assert(x:view() == '10')
    assert(x2:view() == '5')
    assert(V:view() == '5')

    assert(flow:variable(x, 0) == x)
    assert(flow:variable(x, 5) == x)
    assert(flow:variable(x, 20) == x2)
    assert(flow:variable(x, 25) == x2)
    assert(flow:variable(V, 30) == V)
end

do
    --[[
    local x
    x --> 5 | 10
    x = 10
    x --> 10
    x = 5
    x --> 5
    V = x
    ]]

    local flow = rt.flow({ uri = test.fileUri, offset = 0 })

    local x = rt.variable 'x'
    flow:addVariable(x, 0)

    local x1 = x:shadow(rt.value(10))
    x1:addAssign(rt.field('x', rt.value(10)))
    flow:addVariable(x1, 10)

    local x2 = x:shadow(rt.value(5))
    x2:addAssign(rt.field('x', rt.value(5)))
    flow:addVariable(x2, 20)

    local V = rt.variable 'V'
    V:addAssign(rt.field('V', x2))
    flow:addVariable(V, 30)

    assert(x:view() == '5 | 10')
    assert(x1:view() == '10')
    assert(x2:view() == '5')
    assert(V:view() == '5')

    assert(flow:variable(x, 0) == x)
    assert(flow:variable(x, 5) == x)
    assert(flow:variable(x, 10) == x1)
    assert(flow:variable(x, 15) == x1)
    assert(flow:variable(x, 20) == x2)
    assert(flow:variable(x, 25) == x2)
    assert(flow:variable(V, 30) == V)
end

do
    --[[
    ---@type integer?
    local x
    x --> integer | nil

    if x then
        x --> integer
    else
        x --> nil
    end

    x --> integer | nil
    ]]

    local flow = rt.flow({ uri = test.fileUri, offset = 0 })

    local x = rt.variable 'x'
    x:addType(rt.INTEGER | rt.NIL)
    flow:addVariable(x, 0)

    local xNarrow = rt.narrow(x):truly()

    local x1 = x:shadow(xNarrow)
    flow:addVariable(x1, 10)

    local x2 = x:shadow(xNarrow:otherHand())
    flow:addVariable(x2, 20)

    local x3 = x:shadow(x)
    flow:addVariable(x3, 30)

    assert(x:view() == 'integer | nil')
    assert(x1:view() == 'integer')
    assert(x2:view() == 'nil')
    assert(x3:view() == 'integer | nil')
end
