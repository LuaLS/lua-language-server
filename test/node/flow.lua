local rt = test.scope.rt

do
    --[[
    local x = 10
    x --> 10
    W = x
    x = 5
    x --> 5
    V = x
    ]]

    local x = rt.variable 'x'
    x:setCurrentValue(rt.value(10))

    local W = rt.variable 'W'
    W:addAssign(rt.field('W', x))

    local x2 = x:shadow(rt.value(5))
    x2:addAssign(rt.field('x', rt.value(5)))

    local V = rt.variable 'V'
    V:addAssign(rt.field('V', x2))

    assert(x:view() == '10')
    assert(x2:view() == '5')
    assert(W:view() == '10')
    assert(V:view() == '5')
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

    local x = rt.variable 'x'

    local x1 = x:shadow(rt.value(10))
    x1:addAssign(rt.field('x', rt.value(10)))

    local x2 = x:shadow(rt.value(5))
    x2:addAssign(rt.field('x', rt.value(5)))

    local V = rt.variable 'V'
    V:addAssign(rt.field('V', x2))

    assert(x:view() == '5 | 10')
    assert(x1:view() == '10')
    assert(x2:view() == '5')
    assert(V:view() == '5')
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

    local x = rt.variable 'x'
    x:addType(rt.INTEGER | rt.NIL)

    local xNarrow = rt.narrow(x):truly()

    local x1 = x:shadow(xNarrow)

    local x2 = x:shadow(xNarrow:otherSide())

    local x3 = x:shadow(x)

    assert(x:view() == 'integer | nil')
    assert(x1:view() == 'integer')
    assert(x2:view() == 'nil')
    assert(x3:view() == 'integer | nil')
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
        x = 'string'
    end

    x --> integer | 'string'
    ]]

    local x = rt.variable 'x'
    x:addType(rt.INTEGER | rt.NIL)

    local xNarrow = rt.narrow(x):truly()

    local x1 = x:shadow(xNarrow)

    local x2 = x:shadow(xNarrow:otherSide())

    local x21 = x2:shadow(rt.value 'string')
    x21:addAssign(rt.field('x', rt.value 'string'))

    local x3 = x:shadow(x1 | x21)

    assert(x:view() == 'integer | nil')
    assert(x1:view() == 'integer')
    assert(x2:view() == 'nil')
    assert(x21:view() == '"string"')
    assert(x3:view() == '"string" | integer')
end

do
    --[[
    ---@type 1 | 2 | 3 | 4
    local x
    x --> 1 | 2 | 3 | 4

    if x == 1 then
        x --> 1
    elseif x == 2 then
        x --> 2
    else
        x --> 3 | 4
    end

    x --> 1 | 2 | 3 | 4
    ]]

    local x = rt.variable 'x'
    x:addType(rt.value(1) | rt.value(2) | rt.value(3) | rt.value(4))

    local v1 = rt.narrow(x):equalValue(rt.value(1))
    local x1 = x:shadow(v1)

    local v2 = rt.narrow(v1:otherSide()):equalValue(rt.value(2))
    local x2 = x:shadow(v2)

    local x3 = x:shadow(v2:otherSide())

    assert(x:view() == '1 | 2 | 3 | 4')
    assert(x1:view() == '1')
    assert(x2:view() == '2')
    assert(x3:view() == '3 | 4')
end

do
    --[[
    ---@type { a: 1 } | { a: 2 }
    local x
    x --> { a: 1 } | { a: 2 }

    if x.a == 1 then
        x --> { a: 1 }
    else
        x --> { a: 2 }
    end

    x --> { a: 1 } | { a: 2 }
    ]]

    local x = rt.variable 'x'
    x:addType(rt.table { a = rt.value(1) } | rt.table { a = rt.value(2) })

    local xNarrow = rt.narrow(x):matchField('a', rt.value(1))

    local x1 = x:shadow(xNarrow)

    local x2 = x:shadow(xNarrow:otherSide())

    local x3 = x:shadow(x)

    assert(x:view() == '{ a: 1 } | { a: 2 }')
    assert(x1:view() == '{ a: 1 }')
    assert(x2:view() == '{ a: 2 }')
    assert(x3:view() == '{ a: 1 } | { a: 2 }')
end

do
    --[[
    local x = 10
    local y = x
    x = 20
    ]]

    local x = rt.variable 'x'
    x:setCurrentValue(rt.value(10))

    local y = rt.variable 'y'
    y:addAssign(rt.field('y', x))
    y:setCurrentValue(x)

    local x2 = x:shadow(rt.value(20))
    x2:addAssign(rt.field('x', rt.value(20)))

    assert(y:view() == '10')
end

do
    --[[
    local x = 0
    x = x + 1

    W = x
    ]]

    local x = rt.variable 'x'
    x:setCurrentValue(rt.value(0))

    local x2 = x:shadow()
    x2:setCurrentValue(rt.call('op.add', { x, rt.value(1) }))
    x2:addAssign(rt.field('x', x2:getCurrentValue()))

    local W = rt:globalGet('W'):shadow()
    W:setCurrentValue(x2)
    W:addAssign(rt.field('W', x2))

    assert(W:view() == 'op.add<0, 1>')
end
