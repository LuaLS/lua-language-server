local node = test.scope.rt

do
    local v1 = node.list()

    lt.assertEquals(v1:onViewAsList(), 'nil')
end

do
    local V1 = node.list({ node.value(1), node.value(2) })
    lt.assertEquals(V1:viewAsList(), '1, 2')
    lt.assertEquals(V1.value:view(), '1')
    lt.assertEquals(V1:getLastValue():view(), '2')

    local V2 = node.list({ node.value(1), node.value(2), node.value(3) }, 2, 5)
    lt.assertEquals(V2:viewAsList(), '1, 2, 3?...(+2)')
    lt.assertEquals(V2.value:view(), '1')
    lt.assertEquals(V2:getLastValue():view(), '3 | nil')

    local V3 = node.list({ node.value(1), node.value(2), node.value(3) }, 3, false)
    lt.assertEquals(V3:viewAsList(), '1, 2, 3...')
    lt.assertEquals(V3.value:view(), '1')
    lt.assertEquals(V3:getLastValue():view(), '3')

    local V4 = node.list({ node.value(1), node.value(2), node.value(3) }, 100, 100)
    lt.assertEquals(V4:viewAsList(), '1, 2, 3...(+97)')
    lt.assertEquals(V4.value:view(), '1')
    lt.assertEquals(V4:getLastValue():view(), '3')

    local V5 = node.list {
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
    }
    lt.assertEquals(V5:viewAsList(), '1, 2, 3, 4, ...(+3)..., 8, 9, 10')
    lt.assertEquals(V5.value:view(), '1')
    lt.assertEquals(V5:getLastValue():view(), '10')

    local V6 = node.list({
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
    lt.assertEquals(V6:viewAsList(), '1, 2, 3, 4, ...(+3)..., 8, 9, 10...(+90)')
    lt.assertEquals(V6.value:view(), '1')
    lt.assertEquals(V6:getLastValue():view(), '10')
end

do
    local V1 = node.list({ node.value(1), node.value(2) }, 2, 100)
    local V2 = node.list({ node.value(3), node.value(4) }, 2, 100)
    local V3 = node.list({ node.value(5), node.value(6) }, 2, 100)

    local V4 = node.list({ V1, V2, V3 })
    lt.assertEquals(V4:viewAsList(), '1, 3, 5, 6...(+98)')
end

do
    local V1 = node.list { node.value(1), node.value(2) }
    local V2 = node.list { node.value(1), node.INTEGER }

    lt.assertEquals(V1 >> V2, true)
    lt.assertEquals(V2 >> V1, false)
end

do
    local V1 = node.list {
        node.value(1),
        node.value(2),
        node.value(3),
    }
    local V2 = node.list {
        node.value(1),
        node.value(2),
    }

    lt.assertEquals(V1:viewAsList(), '1, 2, 3')
    lt.assertEquals(V2:viewAsList(), '1, 2')

    lt.assertEquals(V1 >> V2, true)
    lt.assertEquals(V2 >> V1, false)
end

do
    local V1 = node.list {
        node.value(1),
        node.value(2),
        node.value(3),
    }
    local V2 = node.list({
        node.value(1),
        node.value(2),
    }, 2, false)

    lt.assertEquals(V1:viewAsList(), '1, 2, 3')
    lt.assertEquals(V2:viewAsList(), '1, 2...')

    lt.assertEquals(V1 >> V2, false)
    lt.assertEquals(V2 >> V1, false)
end

do
    local V1 = node.list({
        node.value(1),
        node.value(2),
        node.value(3),
    }, 5, 5)
    local V2 = node.list({
        node.value(1),
        node.value(2),
    }, 5, 5)

    lt.assertEquals(V1:viewAsList(), '1, 2, 3...(+2)')
    lt.assertEquals(V2:viewAsList(), '1, 2...(+3)')

    lt.assertEquals(V1 >> V2, false)
    lt.assertEquals(V2 >> V1, false)
end

do
    local V1 = node.list({
        node.value(1),
        node.value(2),
        node.value(2),
    }, 4, 4)
    local V2 = node.list({
        node.value(1),
        node.value(2),
    }, 4, 5)

    lt.assertEquals(V1:viewAsList(), '1, 2, 2...(+1)')
    lt.assertEquals(V2:viewAsList(), '1, 2...(+3)')

    lt.assertEquals(V1 >> V2, true)
    lt.assertEquals(V2 >> V1, true)
end

do
    local V1 = node.list({ node.INTEGER }, 0, false)
    lt.assertEquals(V1:viewAsList(), 'integer?...')

    local V = node.list { node.value(1), V1 }

    lt.assertEquals(V:viewAsList(), '1, integer?...')
end
