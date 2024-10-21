do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil

    local u = test.scope.node.type 'A' | test.scope.node.type 'B' | test.scope.node.type 'C'
    local r = u:narrow(test.scope.node.type 'B')

    assert(r:view() == 'B')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil

    test.scope.node.type 'A'
        : addExtends(test.scope.node.type 'B')

    local u = test.scope.node.type 'A' | test.scope.node.type 'B' | test.scope.node.type 'C'
    local r = u:narrow(test.scope.node.type 'B')

    assert(r:view() == 'A | B')
end

do
    local u = test.scope.node.value(1) | test.scope.node.value(true) | test.scope.node.value('x')
    local r1 = u:narrow(test.scope.node.NUMBER)
    local r2 = u:narrow(test.scope.node.STRING)
    local r3 = u:narrow(test.scope.node.BOOLEAN)

    assert(r1:view() == '1')
    assert(r2:view() == '"x"')
    assert(r3:view() == 'true')
end

do
    local t = test.scope.node.table {
        x = 1,
    } | test.scope.node.table {
        y = 2,
    } | test.scope.node.table {
        z = 3,
    }

    local r1 = t:narrow(test.scope.node.table {
        x = 1,
    })
    local r2 = t:narrow(test.scope.node.table {
        y = 2,
    })
    local r3 = t:narrow(test.scope.node.table {
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
    local t = test.scope.node.func()
        : addParam('x', test.scope.node.NUMBER)
    | test.scope.node.func()
        : addParam('x', test.scope.node.STRING)

    local r = t:narrow(test.scope.node.func()
        : addParam('x', test.scope.node.NUMBER)
    )

    assert(r:view() == 'fun(x: number)')
end
