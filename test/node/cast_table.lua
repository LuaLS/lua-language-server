local rt = test.scope.rt

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))

    local B = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field('z', rt.value(3)))

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('y')))
        : addField(rt.field(3, rt.value('z')))

    local B = rt.array(rt.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('y')))
        : addField(rt.field(3, rt.value('z')))

    local B = rt.array(rt.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('y')))
        : addField(rt.field(3, rt.value(false)))

    local B = rt.array(rt.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = rt.table()
        : addField(rt.field(rt.type('number'), rt.value('x')))

    local B = rt.array(rt.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = rt.table()
        : addField(rt.field(rt.type('number'), rt.value(false)))

    local B = rt.array(rt.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
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

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.array(rt.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.table()
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('x')))

    assert(A >> B == true)
    assert(B >> A == true)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.table()
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('x')))
        : addField(rt.field(3, rt.value('y')))

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.tuple()
        : insert(rt.STRING)
        : insert(rt.STRING)
        : insert(rt.STRING)

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = rt.array(rt.STRING)
    local B = rt.tuple()
        : insert(rt.value 'x')
        : insert(rt.value 'y')
        : insert(rt.value 'z')

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = rt.tuple()
        : insert(rt.STRING)
        : insert(rt.STRING)
    local B = rt.tuple()
        : insert(rt.value 'x')
        : insert(rt.value 'y')
        : insert(rt.value 'z')

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.tuple(rt.list({ rt.STRING }, 3, false))

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local a = rt.type 'table'
    local b = rt.table()

    assert(a >> b == true)
    assert(b >> a == true)
end
