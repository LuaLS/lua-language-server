local rt = test.scope.rt

do
    local A = rt.table()
        : addField { key = rt.value('x'), value = rt.value(1) }
        : addField { key = rt.value('y'), value = rt.value(2) }

    local B = rt.table()
        : addField { key = rt.value('x'), value = rt.value(1) }
        : addField { key = rt.value('y'), value = rt.value(2) }
        : addField { key = rt.value('z'), value = rt.value(3) }

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = rt.table()
        : addField {
            key   = rt.value('x'),
            value = rt.value(1)
        }
        : addField {
            key   = rt.value('y'),
            value = rt.value(2)
        }
        : addField {
            key   = rt.value(1),
            value = rt.value('x')
        }
        : addField {
            key   = rt.value(2),
            value = rt.value('y')
        }
        : addField {
            key   = rt.value(3),
            value = rt.value('z')
        }

    local B = rt.array(rt.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = rt.table()
        : addField {
            key   = rt.value('x'),
            value = rt.value(1)
        }
        : addField {
            key   = rt.value('y'),
            value = rt.value(2)
        }
        : addField {
            key   = rt.value(1),
            value = rt.value('x')
        }
        : addField {
            key   = rt.value(2),
            value = rt.value('y')
        }
        : addField {
            key   = rt.value(3),
            value = rt.value(false)
        }

    local B = rt.array(rt.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = rt.table()
        : addField {
            key   = rt.type('number'),
            value = rt.value('x')
        }

    local B = rt.array(rt.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = rt.table()
        : addField {
            key   = rt.type('number'),
            value = rt.value(false)
        }

    local B = rt.array(rt.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = rt.table()
        : addField {
            key   = rt.value(1),
            value = rt.value(5),
        }
        : addField {
            key   = rt.value(2),
            value = rt.value(true),
        }
        : addField {
            key   = rt.value(3),
            value = rt.value('hello'),
        }

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
        : addField {
            key   = rt.value(1),
            value = rt.value('x'),
        }
        : addField {
            key   = rt.value(2),
            value = rt.value('x'),
        }

    assert(A >> B == true)
    assert(B >> A == true)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.table()
        : addField {
            key   = rt.value(1),
            value = rt.value('x'),
        }
        : addField {
            key   = rt.value(2),
            value = rt.value('x'),
        }
        : addField {
            key   = rt.value(3),
            value = rt.value('y'),
        }

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
