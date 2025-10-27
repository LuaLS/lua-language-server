local node = test.scope.node

do
    local v1 = node.vararg()

    assert(v1:onViewAsVararg() == 'nil')
end

do
    local V1 = node.vararg({ node.value(1), node.value(2) }, 2, 2)
    assert(V1:viewAsVararg() == '1, 2')
    assert(V1.value:view() == '1')
    assert(V1:getLastValue():view() == '2')

    local V2 = node.vararg({ node.value(1), node.value(2), node.value(3) }, 2, 5)
    assert(V2:viewAsVararg() == '1, 2, 3?...(+2)')
    assert(V2.value:view() == '1')
    assert(V2:getLastValue():view() == '3 | nil')

    local V3 = node.vararg({ node.value(1), node.value(2), node.value(3) })
    assert(V3:viewAsVararg() == '1, 2, 3...')
    assert(V3.value:view() == '1')
    assert(V3:getLastValue():view() == '3')

    local V4 = node.vararg({ node.value(1), node.value(2), node.value(3) }, 100, 100)
    assert(V4:viewAsVararg() == '1, 2, 3...(+97)')
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
    assert(V5:viewAsVararg() == '1, 2, 3, 4, ...(+3), 8, 9, 10')
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
    assert(V6:viewAsVararg() == '1, 2, 3, 4, ...(+3), 8, 9, 10...(+90)')
    assert(V6.value:view() == '1')
    assert(V6:getLastValue():view() == '10')
end

do
    local V1 = node.vararg({ node.value(1), node.value(2) }, 2, 100)
    local V2 = node.vararg({ node.value(3), node.value(4) }, 2, 100)
    local V3 = node.vararg({ node.value(5), node.value(6) }, 2, 100)

    local V4 = node.vararg({ V1, V2, V3 })
    assert(V4:viewAsVararg() == '1, 3, 5, 6...(+98)')
end

do
    local V1 = node.vararg({ node.value(1), node.value(2) }, 2, 2)
    local V2 = node.vararg({ node.value(1), node.INTEGER }, 2, 2)

    assert(V1 >> V2 == true)
    assert(V2 >> V1 == false)
end

do
    local V1 = node.vararg({
        node.value(1),
        node.value(2),
        node.value(3),
    }, 3, 3)
    local V2 = node.vararg({
        node.value(1),
        node.value(2),
    }, 2, 2)

    assert(V1:viewAsVararg() == '1, 2, 3')
    assert(V2:viewAsVararg() == '1, 2')

    assert(V1 >> V2 == true)
    assert(V2 >> V1 == false)
end

do
    local V1 = node.vararg({
        node.value(1),
        node.value(2),
        node.value(3),
    }, 3, 3)
    local V2 = node.vararg({
        node.value(1),
        node.value(2),
    }, 2)

    assert(V1:viewAsVararg() == '1, 2, 3')
    assert(V2:viewAsVararg() == '1, 2...')

    assert(V1 >> V2 == false)
    assert(V2 >> V1 == false)
end

do
    local V1 = node.vararg({
        node.value(1),
        node.value(2),
        node.value(3),
    }, 5, 5)
    local V2 = node.vararg({
        node.value(1),
        node.value(2),
    }, 5, 5)

    assert(V1:viewAsVararg() == '1, 2, 3...(+2)')
    assert(V2:viewAsVararg() == '1, 2...(+3)')

    assert(V1 >> V2 == false)
    assert(V2 >> V1 == false)
end

do
    local V1 = node.vararg({
        node.value(1),
        node.value(2),
        node.value(2),
    }, 4, 4)
    local V2 = node.vararg({
        node.value(1),
        node.value(2),
    }, 4, 5)

    assert(V1:viewAsVararg() == '1, 2, 2...(+1)')
    assert(V2:viewAsVararg() == '1, 2...(+3)')

    assert(V1 >> V2 == true)
    assert(V2 >> V1 == true)
end

do
    local V1 = node.vararg({ node.INTEGER }, 0)
    assert(V1:viewAsVararg() == 'integer?...')

    local V = node.vararg({ node.value(1), V1 }, 2, 2)

    assert(V:viewAsVararg() == '1, integer?...')
end
