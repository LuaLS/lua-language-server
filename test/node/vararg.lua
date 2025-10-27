local node = test.scope.node

do
    local v1 = node.vararg()

    assert(v1:view() == 'nil')
end

do
    local V1 = node.vararg({ node.value(1), node.value(2) }, 2, 2)
    assert(V1:view() == '1, 2')
    assert(V1.value:view() == '1')
    assert(V1:getLastValue():view() == '2')

    local V2 = node.vararg({ node.value(1), node.value(2), node.value(3) }, 2, 5)
    assert(V2:view() == '1, 2, 3?, 3?, 3?')
    assert(V2.value:view() == '1')
    assert(V2:getLastValue():view() == '3 | nil')

    local V3 = node.vararg({ node.value(1), node.value(2), node.value(3) })
    assert(V3:view() == '1, 2, 3...')
    assert(V3.value:view() == '1')
    assert(V3:getLastValue():view() == '3')

    local V4 = node.vararg({ node.value(1), node.value(2), node.value(3) }, 100, 100)
    assert(V4:view() == '1, 2, 3, 3, 3, 3, 3, 3...(+93)')
    assert(V4.value:view() == '1')
    assert(V4:getLastValue():view() == '3')

    local V5 = node.vararg({
        node.value(1),
        node.value(2),
        node.value(3),
        node.value(4),
        node.value(5),
        node.value(6),
        node.value(7),
        node.value(8),
        node.value(9),
        node.value(10),
    }, 10, 10)
    assert(V5:view() == '1, 2, 3, 4, ...(+3), 8, 9, 10')
    assert(V5.value:view() == '1')
    assert(V5:getLastValue():view() == '10')

    local V6 = node.vararg({
        node.value(1),
        node.value(2),
        node.value(3),
        node.value(4),
        node.value(5),
        node.value(6),
        node.value(7),
        node.value(8),
        node.value(9),
        node.value(10),
    }, 10, 100)
    assert(V6:view() == '1, 2, 3, 4, ...(+3), 8, 9, 10...(+90)')
    assert(V6.value:view() == '1')
    assert(V6:getLastValue():view() == '10')
end
