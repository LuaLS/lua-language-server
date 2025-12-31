local rt = test.scope.rt

do
    rt.TYPE_POOL['A'] = nil
    rt.TYPE_POOL['B'] = nil
    rt.TYPE_POOL['C'] = nil

    local u = rt.type 'A' | rt.type 'B' | rt.type 'C'
    local r = u:narrow(rt.type 'B')

    lt.assertEquals(r:view(), 'B')
end

do
    rt:reset()

    rt.type 'A'
    rt.class('A', nil, { rt.type 'B' })

    local u = rt.type 'A' | rt.type 'B' | rt.type 'C'
    local r = u:narrow(rt.type 'B')

    lt.assertEquals(r:view(), 'A | B')
end

do
    local u = rt.value(1) | rt.value(true) | rt.value('x')
    local r1 = u:narrow(rt.NUMBER)
    local r2 = u:narrow(rt.STRING)
    local r3 = u:narrow(rt.BOOLEAN)

    lt.assertEquals(r1:view(), '1')
    lt.assertEquals(r2:view(), '"x"')
    lt.assertEquals(r3:view(), 'true')
end

do
    local t = rt.table {
        x = 1,
    } | rt.table {
        y = 2,
    } | rt.table {
        z = 3,
    }

    local r1 = t:narrow(rt.table {
        x = 1,
    })
    local r2 = t:narrow(rt.table {
        y = 2,
    })
    local r3 = t:narrow(rt.table {
        z = 3,
    })
    local r4 = t:narrowByField('x', 1)
    local r5 = t:narrowByField('y', 2)
    local r6 = t:narrowByField('z', 3)

    lt.assertEquals(r1:view(), '{ x: 1 }')
    lt.assertEquals(r2:view(), '{ y: 2 }')
    lt.assertEquals(r3:view(), '{ z: 3 }')
    lt.assertEquals(r4:view(), '{ x: 1 }')
    lt.assertEquals(r5:view(), '{ y: 2 }')
    lt.assertEquals(r6:view(), '{ z: 3 }')
end

do
    local t = rt.func()
        : addParamDef('x', rt.NUMBER)
    | rt.func()
        : addParamDef('x', rt.STRING)

    local r = t:narrow(rt.func()
        : addParamDef('x', rt.NUMBER)
    )

    lt.assertEquals(r:view(), 'fun(x: number)')
end

do
    rt:reset()

    rt.alias('A', nil, rt.value(1) | rt.value(2))

    local b = rt.type('A').truly

    lt.assertEquals(b:view(), 'A')
end

do
    rt:reset()

    rt.alias('A', nil, rt.value(1) | rt.value(2) | rt.NIL)

    local b = rt.type('A').truly

    lt.assertEquals(b:view(), '1 | 2')
end

do
    rt:reset()

    local a = rt.ternary(
        rt.value(true),
        rt.value(1),
        rt.value(2)
    )
    lt.assertEquals(a:view(), '1')

    local b = rt.ternary(
        rt.value(false),
        rt.value(1),
        rt.value(2)
    )
    lt.assertEquals(b:view(), '2')

    local c = rt.ternary(
        rt.BOOLEAN,
        rt.value(1),
        rt.value(2)
    )
    lt.assertEquals(c:view(), '1 | 2')
end

do
    rt:reset()

    local a = rt.ANY:narrowEqual(rt.value(1))

    lt.assertEquals(a:view(), '1')
end
