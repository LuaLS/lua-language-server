local rt = test.scope.rt

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))

    local B = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field('z', rt.value(3)))

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, true)
end

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('y')))
        : addField(rt.field(3, rt.value('z')))

    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('y')))
        : addField(rt.field(3, rt.value('z')))

    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('y')))
        : addField(rt.field(3, rt.value(false)))

    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.table()
        : addField(rt.field(rt.type('number'), rt.value('x')))

    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.table()
        : addField(rt.field(rt.type('number'), rt.value(false)))

    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.table()
        : addField(rt.field(1, rt.value(5)))
        : addField(rt.field(2, rt.value(true)))
        : addField(rt.field(3, rt.value('hello')))

    local B = rt.tuple()
        : insert(rt.NUMBER)
        : insert(rt.BOOLEAN)
        : insert(rt.STRING)

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.table()
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('x')))

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, true)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.table()
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('x')))
        : addField(rt.field(3, rt.value('y')))

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.tuple()
        : insert(rt.STRING)
        : insert(rt.STRING)
        : insert(rt.STRING)

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.array(rt.STRING)
    local B = rt.tuple()
        : insert(rt.value 'x')
        : insert(rt.value 'y')
        : insert(rt.value 'z')

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, true)
end

do
    local A = rt.tuple()
        : insert(rt.STRING)
        : insert(rt.STRING)
    local B = rt.tuple()
        : insert(rt.value 'x')
        : insert(rt.value 'y')
        : insert(rt.value 'z')

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, true)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.tuple(rt.list({ rt.STRING }, 3, false))

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local a = rt.type 'table'
    local b = rt.table()

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end
