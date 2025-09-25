do
    local A = test.scope.node.table()
        : addField { key = test.scope.node.value('x'), value = test.scope.node.value(1) }
        : addField { key = test.scope.node.value('y'), value = test.scope.node.value(2) }

    local B = test.scope.node.table()
        : addField { key = test.scope.node.value('x'), value = test.scope.node.value(1) }
        : addField { key = test.scope.node.value('y'), value = test.scope.node.value(2) }
        : addField { key = test.scope.node.value('z'), value = test.scope.node.value(3) }

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = test.scope.node.table()
        : addField {
            key   = test.scope.node.value('x'),
            value = test.scope.node.value(1)
        }
        : addField {
            key   = test.scope.node.value('y'),
            value = test.scope.node.value(2)
        }
        : addField {
            key   = test.scope.node.value(1),
            value = test.scope.node.value('x')
        }
        : addField {
            key   = test.scope.node.value(2),
            value = test.scope.node.value('y')
        }
        : addField {
            key   = test.scope.node.value(3),
            value = test.scope.node.value('z')
        }

    local B = test.scope.node.array(test.scope.node.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = test.scope.node.table()
        : addField {
            key   = test.scope.node.value('x'),
            value = test.scope.node.value(1)
        }
        : addField {
            key   = test.scope.node.value('y'),
            value = test.scope.node.value(2)
        }
        : addField {
            key   = test.scope.node.value(1),
            value = test.scope.node.value('x')
        }
        : addField {
            key   = test.scope.node.value(2),
            value = test.scope.node.value('y')
        }
        : addField {
            key   = test.scope.node.value(3),
            value = test.scope.node.value(false)
        }

    local B = test.scope.node.array(test.scope.node.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = test.scope.node.table()
        : addField {
            key   = test.scope.node.type('number'),
            value = test.scope.node.value('x')
        }

    local B = test.scope.node.array(test.scope.node.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = test.scope.node.table()
        : addField {
            key   = test.scope.node.type('number'),
            value = test.scope.node.value(false)
        }

    local B = test.scope.node.array(test.scope.node.type 'string')

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = test.scope.node.table()
        : addField {
            key   = test.scope.node.value(1),
            value = test.scope.node.value(5),
        }
        : addField {
            key   = test.scope.node.value(2),
            value = test.scope.node.value(true),
        }
        : addField {
            key   = test.scope.node.value(3),
            value = test.scope.node.value('hello'),
        }

    local B = test.scope.node.tuple()
        : insert(test.scope.node.NUMBER)
        : insert(test.scope.node.BOOLEAN)
        : insert(test.scope.node.STRING)

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = test.scope.node.array(test.scope.node.value('x'))
    local B = test.scope.node.array(test.scope.node.type 'string')

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = test.scope.node.array(test.scope.node.value('x'))
    local B = test.scope.node.table()
        : addField {
            key   = test.scope.node.value(1),
            value = test.scope.node.value('x'),
        }
        : addField {
            key   = test.scope.node.value(2),
            value = test.scope.node.value('x'),
        }

    assert(A >> B == true)
    assert(B >> A == true)
end

do
    local A = test.scope.node.array(test.scope.node.value('x'))
    local B = test.scope.node.table()
        : addField {
            key   = test.scope.node.value(1),
            value = test.scope.node.value('x'),
        }
        : addField {
            key   = test.scope.node.value(2),
            value = test.scope.node.value('x'),
        }
        : addField {
            key   = test.scope.node.value(3),
            value = test.scope.node.value('y'),
        }

    assert(A >> B == false)
    assert(B >> A == false)
end

do
    local A = test.scope.node.array(test.scope.node.value('x'))
    local B = test.scope.node.tuple()
        : insert(test.scope.node.STRING)
        : insert(test.scope.node.STRING)
        : insert(test.scope.node.STRING)

    assert(A >> B == true)
    assert(B >> A == false)
end

do
    local A = test.scope.node.array(test.scope.node.STRING)
    local B = test.scope.node.tuple()
        : insert(test.scope.node.value 'x')
        : insert(test.scope.node.value 'y')
        : insert(test.scope.node.value 'z')

    assert(A >> B == false)
    assert(B >> A == true)
end

do
    local A = test.scope.node.tuple()
        : insert(test.scope.node.STRING)
        : insert(test.scope.node.STRING)
    local B = test.scope.node.tuple()
        : insert(test.scope.node.value 'x')
        : insert(test.scope.node.value 'y')
        : insert(test.scope.node.value 'z')

    assert(A >> B == false)
    assert(B >> A == true)
end
