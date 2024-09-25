do
    local A = ls.node.table()
        : addField { key = ls.node.value('x'), value = ls.node.value(1) }
        : addField { key = ls.node.value('y'), value = ls.node.value(2) }

    local B = ls.node.table()
        : addField { key = ls.node.value('x'), value = ls.node.value(1) }
        : addField { key = ls.node.value('y'), value = ls.node.value(2) }
        : addField { key = ls.node.value('z'), value = ls.node.value(3) }

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = ls.node.table()
        : addField {
            key   = ls.node.value('x'),
            value = ls.node.value(1)
        }
        : addField {
            key   = ls.node.value('y'),
            value = ls.node.value(2)
        }
        : addField {
            key   = ls.node.value(1),
            value = ls.node.value('x')
        }
        : addField {
            key   = ls.node.value(2),
            value = ls.node.value('y')
        }
        : addField {
            key   = ls.node.value(3),
            value = ls.node.value('z')
        }

    local B = ls.node.array(ls.node.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = ls.node.table()
        : addField {
            key   = ls.node.value('x'),
            value = ls.node.value(1)
        }
        : addField {
            key   = ls.node.value('y'),
            value = ls.node.value(2)
        }
        : addField {
            key   = ls.node.value(1),
            value = ls.node.value('x')
        }
        : addField {
            key   = ls.node.value(2),
            value = ls.node.value('y')
        }
        : addField {
            key   = ls.node.value(3),
            value = ls.node.value(false)
        }

    local B = ls.node.array(ls.node.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = ls.node.table()
        : addField {
            key   = ls.node.value('x'),
            value = ls.node.value(1)
        }
        : addField {
            key   = ls.node.value('y'),
            value = ls.node.value(2)
        }
        : addField {
            key   = ls.node.value(1),
            value = ls.node.value('x')
        }
        : addField {
            key   = ls.node.value(2),
            value = ls.node.value('y')
        }
        : addField {
            key   = ls.node.value(3),
            value = ls.node.value(false)
        }

    local B = ls.node.array(ls.node.type 'string', 2)

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = ls.node.table()
        : addField {
            key   = ls.node.type('number'),
            value = ls.node.value('x')
        }

    local B = ls.node.array(ls.node.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = ls.node.table()
        : addField {
            key   = ls.node.type('number'),
            value = ls.node.value(false)
        }

    local B = ls.node.array(ls.node.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = ls.node.table()
        : addField {
            key   = ls.node.value(1),
            value = ls.node.value(5),
        }
        : addField {
            key   = ls.node.value(2),
            value = ls.node.value(true),
        }
        : addField {
            key   = ls.node.value(3),
            value = ls.node.value('hello'),
        }

    local B = ls.node.tuple()
        : insert(ls.node.NUMBER)
        : insert(ls.node.BOOLEAN)
        : insert(ls.node.STRING)

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = ls.node.array(ls.node.value('x'))
    local B = ls.node.array(ls.node.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = ls.node.array(ls.node.value('x'), 3)
    local B = ls.node.array(ls.node.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = ls.node.array(ls.node.value('x'))
    local B = ls.node.table()
        : addField {
            key   = ls.node.value(1),
            value = ls.node.value('x'),
        }
        : addField {
            key   = ls.node.value(2),
            value = ls.node.value('x'),
        }

    assert(A >> B == true)
    assert(B >> A == true)
end

do
    local A = ls.node.array(ls.node.value('x'))
    local B = ls.node.table()
        : addField {
            key   = ls.node.value(1),
            value = ls.node.value('x'),
        }
        : addField {
            key   = ls.node.value(2),
            value = ls.node.value('x'),
        }
        : addField {
            key   = ls.node.value(3),
            value = ls.node.value('y'),
        }

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = ls.node.array(ls.node.value('x'))
    local B = ls.node.tuple()
        : insert(ls.node.STRING)
        : insert(ls.node.STRING)
        : insert(ls.node.STRING)

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = ls.node.array(ls.node.STRING)
    local B = ls.node.tuple()
        : insert(ls.node.value 'x')
        : insert(ls.node.value 'y')
        : insert(ls.node.value 'z')

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = ls.node.tuple()
        : insert(ls.node.STRING)
        : insert(ls.node.STRING)
    local B = ls.node.tuple()
        : insert(ls.node.value 'x')
        : insert(ls.node.value 'y')
        : insert(ls.node.value 'z')

    assert(A >> B == false)
    assert(B >> A == true)
end
