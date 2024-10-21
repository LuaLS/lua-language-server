do
    assert(test.scope.node.ANY.truly:view() == 'truly')
    assert(test.scope.node.ANY.falsy:view() == 'false | nil')

    assert(test.scope.node.UNKNOWN.truly:view() == 'truly')
    assert(test.scope.node.UNKNOWN.falsy:view() == 'false')

    assert(test.scope.node.TRULY.truly:view() == 'truly')
    assert(test.scope.node.TRULY.falsy:view() == 'never')

    assert(test.scope.node.NIL.truly:view() == 'never')
    assert(test.scope.node.NIL.falsy:view() == 'nil')

    assert(test.scope.node.BOOLEAN.truly:view() == 'true')
    assert(test.scope.node.BOOLEAN.falsy:view() == 'false')

    assert(test.scope.node.TRUE.truly:view() == 'true')
    assert(test.scope.node.TRUE.falsy:view() == 'never')

    assert(test.scope.node.FALSE.truly:view() == 'never')
    assert(test.scope.node.FALSE.falsy:view() == 'false')

    assert(test.scope.node.TABLE.truly:view() == 'table')
    assert(test.scope.node.TABLE.falsy:view() == 'never')

    assert(test.scope.node.value(0).truly:view() == '0')
    assert(test.scope.node.value(0).falsy:view() == 'never')

    assert(test.scope.node.value(1).truly:view() == '1')
    assert(test.scope.node.value(1).falsy:view() == 'never')
end

do
    local u = test.scope.node.value(0) | test.scope.node.value(1) | test.scope.node.value(true) | test.scope.node.value(false) | test.scope.node.NIL

    assert(u:view() == '0 | 1 | true | false | nil')
    assert(u.truly:view() == '0 | 1 | true')
    assert(u.falsy:view() == 'false | nil')
end

do
    local u = test.scope.node.table()
        : addField {
            key   = test.scope.node.value('x'),
            value = test.scope.node.value(1)
        }
        : addField {
            key   = test.scope.node.value('y'),
            value = test.scope.node.value(2)
        }

    assert(u:view() == '{ x: 1, y: 2 }')
    assert(u.truly:view() == '{ x: 1, y: 2 }')
    assert(u.falsy:view() == 'never')
end

do
    local a = test.scope.node.table()
        : addField {
            key   = test.scope.node.value('x'),
            value = test.scope.node.value(1)
        }
    local b = test.scope.node.table()
        : addField {
            key   = test.scope.node.value('y'),
            value = test.scope.node.value(2)
        }

    local u = a & b
    assert(u:view() == '{ x: 1 } & { y: 2 }')
    assert(u.truly:view() == '{ x: 1, y: 2 }')
    assert(u.falsy:view() == 'never')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    local a = test.scope.node.type 'A'

    assert(a.truly:view() == 'A')
    assert(a.falsy:view() == 'never')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    local a = test.scope.node.type 'A'
        : addField {
            key   = test.scope.node.value('x'),
            value = test.scope.node.value(1)
        }

    assert(a.truly:view() == 'A')
    assert(a.falsy:view() == 'never')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    local a = test.scope.node.type 'A'
        : addAlias(test.scope.node.value(1))
        : addAlias(test.scope.node.value(2))
        : addAlias(test.scope.node.value(true))
        : addAlias(test.scope.node.value(false))

    assert(a:view() == 'A')
    assert(a.truly:view() == '1 | 2 | true')
    assert(a.falsy:view() == 'false')
end
