local node = test.scope.node

do
    node.TYPE_POOL['A'] = nil
    node.TYPE_POOL['B'] = nil
    node.TYPE_POOL['C'] = nil

    local u = node.type 'A' | node.type 'B' | node.type 'C'
    local r = u:narrow(node.type 'B')

    assert(r:view() == 'B')
end

do
    node:reset()

    node.type 'A'
        : addClass(node.class('A', nil, { node.type 'B' }))

    local u = node.type 'A' | node.type 'B' | node.type 'C'
    local r = u:narrow(node.type 'B')

    assert(r:view() == 'A | B')
end

do
    local u = node.value(1) | node.value(true) | node.value('x')
    local r1 = u:narrow(node.NUMBER)
    local r2 = u:narrow(node.STRING)
    local r3 = u:narrow(node.BOOLEAN)

    assert(r1:view() == '1')
    assert(r2:view() == '"x"')
    assert(r3:view() == 'true')
end

do
    local t = node.table {
        x = 1,
    } | node.table {
        y = 2,
    } | node.table {
        z = 3,
    }

    local r1 = t:narrow(node.table {
        x = 1,
    })
    local r2 = t:narrow(node.table {
        y = 2,
    })
    local r3 = t:narrow(node.table {
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
    local t = node.func()
        : addParamDef('x', node.NUMBER)
    | node.func()
        : addParamDef('x', node.STRING)

    local r = t:narrow(node.func()
        : addParamDef('x', node.NUMBER)
    )

    assert(r:view() == 'fun(x: number)')
end
