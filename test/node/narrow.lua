local rt = test.scope.rt

do
    rt.TYPE_POOL['A'] = nil
    rt.TYPE_POOL['B'] = nil
    rt.TYPE_POOL['C'] = nil

    local u = rt.type 'A' | rt.type 'B' | rt.type 'C'
    local r = u:narrow(rt.type 'B')

    assert(r:view() == 'B')
end

do
    rt:reset()

    rt.type 'A'
    rt.class('A', nil, { rt.type 'B' })

    local u = rt.type 'A' | rt.type 'B' | rt.type 'C'
    local r = u:narrow(rt.type 'B')

    assert(r:view() == 'A | B')
end

do
    local u = rt.value(1) | rt.value(true) | rt.value('x')
    local r1 = u:narrow(rt.NUMBER)
    local r2 = u:narrow(rt.STRING)
    local r3 = u:narrow(rt.BOOLEAN)

    assert(r1:view() == '1')
    assert(r2:view() == '"x"')
    assert(r3:view() == 'true')
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

    assert(r1:view() == '{ x: 1 }')
    assert(r2:view() == '{ y: 2 }')
    assert(r3:view() == '{ z: 3 }')
    assert(r4:view() == '{ x: 1 }')
    assert(r5:view() == '{ y: 2 }')
    assert(r6:view() == '{ z: 3 }')
end

do
    local t = rt.func()
        : addParamDef('x', rt.NUMBER)
    | rt.func()
        : addParamDef('x', rt.STRING)

    local r = t:narrow(rt.func()
        : addParamDef('x', rt.NUMBER)
    )

    assert(r:view() == 'fun(x: number)')
end
