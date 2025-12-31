local rt = test.scope.rt

do
    rt:reset()

    local a = rt.type 'A'
    local b = rt.type 'B'

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end

do
    rt:reset()

    local a = rt.NIL
    local b = rt.ANY

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    rt:reset()

    local a = rt.type 'A'
    local b = rt.type 'B'

    rt.class('B', nil, { a })

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, true)
end

do
    rt:reset()

    local a = rt.type 'A'
    local b = rt.type 'B'
    rt.class('B', nil, { a })
    local c = rt.type 'C'
    rt.class('C', nil, { b })
    local d = rt.type 'D'
    rt.class('D', nil, { c })

    lt.assertEquals(a >> d, false)
    lt.assertEquals(d >> a, true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('B', nil, rt.type 'B')
    local b = rt.type 'B'
    rt.alias('A', nil, rt.type 'A')

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.class('A')
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))

    local ta = rt.table()
        : addField(rt.field('x', rt.value 'x'))
    local tb = rt.table()
        : addField(rt.field('y', rt.value 'y'))
    local tc = rt.table()
        : addField(rt.field('z', rt.value 'z'))

    lt.assertEquals(a >> ta, true)
    lt.assertEquals(a >> tb, true)
    lt.assertEquals(a >> tc, false)

    lt.assertEquals(ta >> a, false)
    lt.assertEquals(tb >> a, false)
    lt.assertEquals(tc >> a, false)

    lt.assertEquals(a >> (ta & tb), true)
    lt.assertEquals((ta & tb) >> a, true)

    lt.assertEquals(a >> (ta & tb & tc), false)
    lt.assertEquals((ta & tb & tc) >> a, true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.value(1) | rt.value(2) | rt.value(3))
    local b = rt.type 'B'
    rt.alias('B', nil, rt.value(1))
    rt.alias('B', nil, rt.value(2))
    rt.alias('B', nil, rt.value(3))

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.value(1) | rt.value(2) | rt.value(3))
    local b = rt.type 'B'
    rt.alias('B', nil, rt.value(1))
    rt.alias('B', nil, rt.value(2))

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.table()
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))
    )
    local b = rt.type 'B'
    rt.alias('B', nil, rt.table()
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))
        : addField(rt.field('z', rt.value 'z'))
    )

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.table()
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))
    )
    local b = rt.type 'B'
    rt.class('B')
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.table()
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))
    )
    local b = rt.type 'B'
    rt.class('B', nil, { rt.type 'C' })

    rt.class 'C'
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))


    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.table()
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))
        : addField(rt.field('z', rt.value 'z'))
    )
    local b = rt.type 'B'
    rt.class('B', nil, { rt.type 'C' })

    rt.class('C')
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, false)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.table()
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))
        : addField(rt.field('z', rt.value 'z'))
    )

    local b = rt.type 'B'
    rt.class('B', nil, { rt.type 'C' })
        : addField(rt.field('z', rt.value 'z'))

    rt.class('C')
        : addField(rt.field('x', rt.value 'x'))
        : addField(rt.field('y', rt.value 'y'))

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end
