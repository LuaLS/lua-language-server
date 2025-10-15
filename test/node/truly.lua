local node = test.scope.node

do
    assert(node.ANY.truly:view() == 'truly')
    assert(node.ANY.falsy:view() == 'false | nil')

    assert(node.UNKNOWN.truly:view() == 'truly')
    assert(node.UNKNOWN.falsy:view() == 'false')

    assert(node.TRULY.truly:view() == 'truly')
    assert(node.TRULY.falsy:view() == 'never')

    assert(node.NIL.truly:view() == 'never')
    assert(node.NIL.falsy:view() == 'nil')

    assert(node.BOOLEAN.truly:view() == 'true')
    assert(node.BOOLEAN.falsy:view() == 'false')

    assert(node.TRUE.truly:view() == 'true')
    assert(node.TRUE.falsy:view() == 'never')

    assert(node.FALSE.truly:view() == 'never')
    assert(node.FALSE.falsy:view() == 'false')

    assert(node.TABLE.truly:view() == 'table')
    assert(node.TABLE.falsy:view() == 'never')

    assert(node.value(0).truly:view() == '0')
    assert(node.value(0).falsy:view() == 'never')

    assert(node.value(1).truly:view() == '1')
    assert(node.value(1).falsy:view() == 'never')
end

do
    local u = node.value(0) | node.value(1) | node.value(true) | node.value(false) | node.NIL

    assert(u:view() == '0 | 1 | true | false | nil')
    assert(u.truly:view() == '0 | 1 | true')
    assert(u.falsy:view() == 'false | nil')
end

do
    local u = node.table()
        : addField {
            key   = node.value('x'),
            value = node.value(1)
        }
        : addField {
            key   = node.value('y'),
            value = node.value(2)
        }

    assert(u:view() == '{ x: 1, y: 2 }')
    assert(u.truly:view() == '{ x: 1, y: 2 }')
    assert(u.falsy:view() == 'never')
end

do
    local a = node.table()
        : addField {
            key   = node.value('x'),
            value = node.value(1)
        }
    local b = node.table()
        : addField {
            key   = node.value('y'),
            value = node.value(2)
        }

    local u = a & b
    assert(u:view() == '{ x: 1 } & { y: 2 }')
    assert(u.truly:view() == '{ x: 1, y: 2 }')
    assert(u.falsy:view() == 'never')
end

do
    node.TYPE_POOL['A'] = nil
    local a = node.type 'A'

    assert(a.truly:view() == 'A')
    assert(a.falsy:view() == 'never')
end

do
    node:reset()

    local a = node.type 'A'
        : addClass(node.class('A')
            : addField {
                key   = node.value('x'),
                value = node.value(1)
            }
        )

    assert(a.truly:view() == 'A')
    assert(a.falsy:view() == 'never')
end

do
    node:reset()

    local a = node.type 'A'
        : addAlias(node.alias('A', nil, { node.value(1) }))
        : addAlias(node.alias('A', nil, { node.value(2) }))
        : addAlias(node.alias('A', nil, { node.value(true) }))
        : addAlias(node.alias('A', nil, { node.value(false) }))

    assert(a:view() == 'A')
    assert(a.truly:view() == '1 | 2 | true')
    assert(a.falsy:view() == 'false')
end
