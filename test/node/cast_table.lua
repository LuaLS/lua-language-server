local node = test.scope.node

do
    local A = node.table()
        : addField { key = node.value('x'), value = node.value(1) }
        : addField { key = node.value('y'), value = node.value(2) }

    local B = node.table()
        : addField { key = node.value('x'), value = node.value(1) }
        : addField { key = node.value('y'), value = node.value(2) }
        : addField { key = node.value('z'), value = node.value(3) }

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = node.table()
        : addField {
            key   = node.value('x'),
            value = node.value(1)
        }
        : addField {
            key   = node.value('y'),
            value = node.value(2)
        }
        : addField {
            key   = node.value(1),
            value = node.value('x')
        }
        : addField {
            key   = node.value(2),
            value = node.value('y')
        }
        : addField {
            key   = node.value(3),
            value = node.value('z')
        }

    local B = node.array(node.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = node.table()
        : addField {
            key   = node.value('x'),
            value = node.value(1)
        }
        : addField {
            key   = node.value('y'),
            value = node.value(2)
        }
        : addField {
            key   = node.value(1),
            value = node.value('x')
        }
        : addField {
            key   = node.value(2),
            value = node.value('y')
        }
        : addField {
            key   = node.value(3),
            value = node.value(false)
        }

    local B = node.array(node.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = node.table()
        : addField {
            key   = node.type('number'),
            value = node.value('x')
        }

    local B = node.array(node.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = node.table()
        : addField {
            key   = node.type('number'),
            value = node.value(false)
        }

    local B = node.array(node.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = node.table()
        : addField {
            key   = node.value(1),
            value = node.value(5),
        }
        : addField {
            key   = node.value(2),
            value = node.value(true),
        }
        : addField {
            key   = node.value(3),
            value = node.value('hello'),
        }

    local B = node.tuple()
        : insert(node.NUMBER)
        : insert(node.BOOLEAN)
        : insert(node.STRING)

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = node.array(node.value('x'))
    local B = node.array(node.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = node.array(node.value('x'))
    local B = node.table()
        : addField {
            key   = node.value(1),
            value = node.value('x'),
        }
        : addField {
            key   = node.value(2),
            value = node.value('x'),
        }

    assert(A >> B == true)
    assert(B >> A == true)
end

do
    local A = node.array(node.value('x'))
    local B = node.table()
        : addField {
            key   = node.value(1),
            value = node.value('x'),
        }
        : addField {
            key   = node.value(2),
            value = node.value('x'),
        }
        : addField {
            key   = node.value(3),
            value = node.value('y'),
        }

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = node.array(node.value('x'))
    local B = node.tuple()
        : insert(node.STRING)
        : insert(node.STRING)
        : insert(node.STRING)

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = node.array(node.STRING)
    local B = node.tuple()
        : insert(node.value 'x')
        : insert(node.value 'y')
        : insert(node.value 'z')

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = node.tuple()
        : insert(node.STRING)
        : insert(node.STRING)
    local B = node.tuple()
        : insert(node.value 'x')
        : insert(node.value 'y')
        : insert(node.value 'z')

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = node.array(node.value('x'))
    local B = node.tuple(node.vararg({ node.STRING }, 3))

    assert(A >> B == true)
    assert(B >> A == false)
end
