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

    lt.assertEquals(x:view(), '10')
    lt.assertEquals(x2:view(), '5')
    lt.assertEquals(W:view(), '10')
    lt.assertEquals(V:view(), '5')
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

    lt.assertEquals(x:view(), '5 | 10')
    lt.assertEquals(x1:view(), '10')
    lt.assertEquals(x2:view(), '5')
    lt.assertEquals(V:view(), '5')
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

    local xNarrow = rt.narrow(x):matchTruly()

    local x1 = x:shadow(xNarrow)

    local x2 = x:shadow(xNarrow:otherSide())

    local x3 = x:shadow(x)

    lt.assertEquals(x:view(), 'integer | nil')
    lt.assertEquals(x1:view(), 'integer')
    lt.assertEquals(x2:view(), 'nil')
    lt.assertEquals(x3:view(), 'integer | nil')
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

    local xNarrow = rt.narrow(x):matchTruly()

    local x1 = x:shadow(xNarrow)

    local x2 = x:shadow(xNarrow:otherSide())

    local x21 = x2:shadow(rt.value 'string')
    x21:addAssign(rt.field('x', rt.value 'string'))

    local x3 = x:shadow(x1 | x21)

    lt.assertEquals(x:view(), 'integer | nil')
    lt.assertEquals(x1:view(), 'integer')
    lt.assertEquals(x2:view(), 'nil')
    lt.assertEquals(x21:view(), '"string"')
    lt.assertEquals(x3:view(), '"string" | integer')
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

    lt.assertEquals(x:view(), '1 | 2 | 3 | 4')
    lt.assertEquals(x1:view(), '1')
    lt.assertEquals(x2:view(), '2')
    lt.assertEquals(x3:view(), '3 | 4')
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

    lt.assertEquals(x:view(), '{ a: 1 } | { a: 2 }')
    lt.assertEquals(x1:view(), '{ a: 1 }')
    lt.assertEquals(x2:view(), '{ a: 2 }')
    lt.assertEquals(x3:view(), '{ a: 1 } | { a: 2 }')
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

    lt.assertEquals(y:view(), '10')
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

    lt.assertEquals(W:view(), 'op.add<0, 1>')
end

do
    --[[
    ---@type 1 | 2
    local x
    X0 = x --> 1 | 2

    ---@type (fun(x: 1): true) | (fun(x: 2): false)
    local f

    if f(x) then
        X1 = x --> 1
    else
        X2 = x --> 2
    end

    XX = x --> 1 | 2
    ]]

    rt:reset()

    local x = rt.variable 'x'
    x:addType(rt.value(1) | rt.value(2))

    local f1 = rt.func()
        : addParamDef('x', rt.value(1))
        : addReturnDef(nil, rt.value(true))
    local f2 = rt.func()
        : addParamDef('x', rt.value(2))
        : addReturnDef(nil, rt.value(false))

    local f = rt.variable 'f'
    f:addType(f1 | f2)

    local xNarrow = rt.narrow(x):asCall {
        func = f,
        myType = 'param',
        myIndex = 1,
        mode = 'match',
        targetType = 'return',
        targetIndex = 1,
        targetValue = rt.value(true),
    }

    local x1 = x:shadow(xNarrow)

    local x2 = x:shadow(xNarrow:otherSide())

    local x3 = x:shadow(x)

    lt.assertEquals(x:view(), '1 | 2')
    lt.assertEquals(x1:view(), '1')
    lt.assertEquals(x2:view(), '2')
    lt.assertEquals(x3:view(), '1 | 2')
end

do
    --[[
    ---@type 1 | 2
    local x
    X0 = x --> 1 | 2

    ---@type (fun(x: 1): true) | (fun(x: 2): false)
    local f

    if f(x) == false then
        X1 = x --> 2
    else
        X2 = x --> 1
    end

    XX = x --> 1 | 2
    ]]

    rt:reset()

    local x = rt.variable 'x'
    x:addType(rt.value(1) | rt.value(2))

    local f1 = rt.func()
        : addParamDef('x', rt.value(1))
        : addReturnDef(nil, rt.value(true))
    local f2 = rt.func()
        : addParamDef('x', rt.value(2))
        : addReturnDef(nil, rt.value(false))

    local f = rt.variable 'f'
    f:addType(f1 | f2)

    local xNarrow = rt.narrow(x):asCall {
        func = f,
        myType = 'param',
        myIndex = 1,
        mode = 'equal',
        targetType = 'return',
        targetIndex = 1,
        targetValue = rt.value(false),
    }

    local x1 = x:shadow(xNarrow)

    local x2 = x:shadow(xNarrow:otherSide())

    local x3 = x:shadow(x)

    lt.assertEquals(x:view(), '1 | 2')
    lt.assertEquals(x1:view(), '2')
    lt.assertEquals(x2:view(), '1')
    lt.assertEquals(x3:view(), '1 | 2')
end

do
    --[[
    ---@type fun<T>(x: T): T
    local f

    local x
    X = x --> any
    
    if f(x) == 1 then
        X1 = x --> 1
    elseif f(x) == 2 then
        X2 = x --> 2
    else
        X3 = x --> any
    end

    XX = x --> any
    ]]

    rt:reset()

    local T = rt.generic 'T'
    local f = rt.variable 'f'
    local fType = rt.func()
        : addParamDef('x', T)
        : addReturnDef(nil, T)

    f:addType(fType)
    local x = rt.variable 'x'

    local xNarrow1 = rt.narrow(x):asCall {
        func = f,
        myType = 'param',
        myIndex = 1,
        mode = 'equal',
        targetType = 'return',
        targetIndex = 1,
        targetValue = rt.value(1),
    }
    local x1 = x:shadow(xNarrow1)

    local xNarrow2 = rt.narrow(xNarrow1:otherSide()):asCall {
        func = f,
        myType = 'param',
        myIndex = 1,
        mode = 'equal',
        targetType = 'return',
        targetIndex = 1,
        targetValue = rt.value(2),
    }
    local x2 = x:shadow(xNarrow2)

    local x3 = x:shadow(xNarrow2:otherSide())

    lt.assertEquals(x:view(), 'any')
    lt.assertEquals(x1:view(), '1')
    lt.assertEquals(x2:view(), '2')
    lt.assertEquals(x3:view(), 'any')
end

do
    --[[
    ---@type fun<T>(x: T): T
    local f

    local x
    X = x --> any
    
    if f(x) then
        X1 = x --> truly
    else
        X2 = x --> false | nil
    end

    XX = x --> any
    ]]

    rt:reset()

    local T = rt.generic 'T'
    local f = rt.variable 'f'
    local fType = rt.func()
        : addParamDef('x', T)
        : addReturnDef(nil, T)

    f:addType(fType)
    local x = rt.variable 'x'

    local xNarrow1 = rt.narrow(x):asCall {
        func = f,
        myType = 'param',
        myIndex = 1,
        mode = 'match',
        targetType = 'return',
        targetIndex = 1,
        targetValue = rt.TRULY,
    }
    local x1 = x:shadow(xNarrow1)

    local x2 = x:shadow(xNarrow1:otherSide())

    lt.assertEquals(x:view(), 'any')
    lt.assertEquals(x1:view(), 'truly')
    lt.assertEquals(x2:view(), 'false | nil')
end

do
    --[[
    ---@type fun<T>(x: T): T
    local f

    ---@type 1 | 2 | 3 | 4
    local x
    X = x --> 1 | 2 | 3 | 4
    
    if f(x) == 1 then
        X1 = x --> 1
    elseif f(x) == 2 then
        X2 = x --> 2
    else
        X3 = x --> 3 | 4
    end

    XX = x --> 1 | 2 | 3 | 4
    ]]

    rt:reset()

    local T = rt.generic 'T'
    local f = rt.variable 'f'
    local fType = rt.func()
        : addParamDef('x', T)
        : addReturnDef(nil, T)

    f:addType(fType)
    local x = rt.variable 'x'
    x:addType(rt.value(1) | rt.value(2) | rt.value(3) | rt.value(4))

    local xNarrow1 = rt.narrow(x):asCall {
        func = f,
        myType = 'param',
        myIndex = 1,
        mode = 'equal',
        targetType = 'return',
        targetIndex = 1,
        targetValue = rt.value(1),
    }
    local x1 = x:shadow(xNarrow1)

    local xNarrow2 = rt.narrow(xNarrow1:otherSide()):asCall {
        func = f,
        myType = 'param',
        myIndex = 1,
        mode = 'equal',
        targetType = 'return',
        targetIndex = 1,
        targetValue = rt.value(2),
    }
    local x2 = x:shadow(xNarrow2)

    local x3 = x:shadow(xNarrow2:otherSide())

    lt.assertEquals(x:view(), '1 | 2 | 3 | 4')
    lt.assertEquals(x1:view(), '1')
    lt.assertEquals(x2:view(), '2')
    lt.assertEquals(x3:view(), '3 | 4')
end

do
    --[[
    ---@type fun<T>(x: T): T
    local f

    ---@type boolean
    local x
    X = x --> boolean
    
    if f(x) then
        X1 = x --> true
    else
        X2 = x --> false
    end

    XX = x --> boolean
    ]]

    rt:reset()

    local T = rt.generic 'T'
    local f = rt.variable 'f'
    local fType = rt.func()
        : addParamDef('x', T)
        : addReturnDef(nil, T)

    f:addType(fType)
    local x = rt.variable 'x'
    x:addType(rt.BOOLEAN)

    local xNarrow1 = rt.narrow(x):asCall {
        func = f,
        myType = 'param',
        myIndex = 1,
        mode = 'match',
        targetType = 'return',
        targetIndex = 1,
        targetValue = rt.value(true),
    }
    local x1 = x:shadow(xNarrow1)

    local x2 = x:shadow(xNarrow1:otherSide())


    lt.assertEquals(x:view(), 'boolean')
    lt.assertEquals(x1:view(), 'true')
    lt.assertEquals(x2:view(), 'false')
end

do
    --[[
    ---@overload fun(x: string): 'string'
    ---@overload fun(x: number): 'number'
    function type(...) end

    local x
    local tp = type(x)

    X0 = x --> any
    TP = tp --> 'string' | 'number'

    if tp == 'string' then
        X1 = x --> string
    else
        X2 = x --> number
    end

    XX = x --> any
    ]]

    rt:reset()

    local f1 = rt.func()
        : addParamDef('x', rt.STRING)
        : addReturnDef(nil, rt.value('string'))
    local f2 = rt.func()
        : addParamDef('x', rt.NUMBER)
        : addReturnDef(nil, rt.value('number'))

    local typeFunc = f1 | f2

    local x = rt.variable 'x'
    lt.assertEquals(x:view(), 'any')

    local tp = rt.variable 'tp'
    local fcall = rt.fcall(typeFunc, { x })
    tp:setCurrentValue(rt.select(fcall, 1))
    lt.assertEquals(tp:view(), '"string" | "number"')

    local tpNarrow = rt.narrow(tp):equalValue(rt.value('string'))
    lt.assertEquals(tpNarrow:view(), '"string"')
    local xNarrow = rt.narrow(x):asCall {
        func = typeFunc,
        myType = 'param',
        myIndex = 1,
        mode = 'equal',
        targetType = 'return',
        targetIndex = 1,
        targetValue = rt.value('string'),
    }

    local x1 = x:shadow(xNarrow)
    lt.assertEquals(x1:view(), 'string')

    local x2 = x:shadow(xNarrow:otherSide())
    lt.assertEquals(x2:view(), 'number')

    local x3 = x:shadow(x)
    lt.assertEquals(x3:view(), 'any')
end
