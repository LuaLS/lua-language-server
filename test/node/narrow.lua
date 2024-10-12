do
    ls.node.TYPE_POOL['A'] = nil
    ls.node.TYPE_POOL['B'] = nil
    ls.node.TYPE_POOL['C'] = nil

    local u = ls.node.type 'A' | ls.node.type 'B' | ls.node.type 'C'
    local r = u:narrow(ls.node.type 'B')

    assert(r:view() == 'B')
end

do
    ls.node.TYPE_POOL['A'] = nil
    ls.node.TYPE_POOL['B'] = nil
    ls.node.TYPE_POOL['C'] = nil

    ls.node.type 'A'
        : addExtends(ls.node.type 'B')

    local u = ls.node.type 'A' | ls.node.type 'B' | ls.node.type 'C'
    local r = u:narrow(ls.node.type 'B')

    assert(r:view() == 'A | B')
end

do
    local u = ls.node.value(1) | ls.node.value(true) | ls.node.value('x')
    local r1 = u:narrow(ls.node.NUMBER)
    local r2 = u:narrow(ls.node.STRING)
    local r3 = u:narrow(ls.node.BOOLEAN)

    assert(r1:view() == '1')
    assert(r2:view() == '"x"')
    assert(r3:view() == 'true')
end

do
    local t = ls.node.table {
        x = 1,
    } | ls.node.table {
        y = 2,
    } | ls.node.table {
        z = 3,
    }

    local r1 = t:narrow(ls.node.table {
        x = 1,
    })
    local r2 = t:narrow(ls.node.table {
        y = 2,
    })
    local r3 = t:narrow(ls.node.table {
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
    local t = ls.node.func()
        : addParam('x', ls.node.NUMBER)
    | ls.node.func()
        : addParam('x', ls.node.STRING)

    local r = t:narrow(ls.node.func()
        : addParam('x', ls.node.NUMBER)
    )

    assert(r:view() == 'fun(x: number)')
end
