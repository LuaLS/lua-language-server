do
    assert(ls.node.ANY.truly:view() == 'truly')
    assert(ls.node.ANY.falsy:view() == 'false | nil')

    assert(ls.node.UNKNOWN.truly:view() == 'truly')
    assert(ls.node.UNKNOWN.falsy:view() == 'false')

    assert(ls.node.TRULY.truly:view() == 'truly')
    assert(ls.node.TRULY.falsy:view() == 'never')

    assert(ls.node.NIL.truly:view() == 'never')
    assert(ls.node.NIL.falsy:view() == 'nil')

    assert(ls.node.BOOLEAN.truly:view() == 'true')
    assert(ls.node.BOOLEAN.falsy:view() == 'false')

    assert(ls.node.TRUE.truly:view() == 'true')
    assert(ls.node.TRUE.falsy:view() == 'never')

    assert(ls.node.FALSE.truly:view() == 'never')
    assert(ls.node.FALSE.falsy:view() == 'false')

    assert(ls.node.TABLE.truly:view() == 'table')
    assert(ls.node.TABLE.falsy:view() == 'never')

    assert(ls.node.value(0).truly:view() == '0')
    assert(ls.node.value(0).falsy:view() == 'never')

    assert(ls.node.value(1).truly:view() == '1')
    assert(ls.node.value(1).falsy:view() == 'never')
end

do
    local u = ls.node.value(0) | ls.node.value(1) | ls.node.value(true) | ls.node.value(false) | ls.node.NIL

    assert(u:view() == '0 | 1 | true | false | nil')
    assert(u.truly:view() == '0 | 1 | true')
    assert(u.falsy:view() == 'false | nil')
end

do
    local u = ls.node.table()
        : addField {
            key   = ls.node.value('x'),
            value = ls.node.value(1)
        }
        : addField {
            key   = ls.node.value('y'),
            value = ls.node.value(2)
        }

    assert(u:view() == '{ x: 1, y: 2 }')
    assert(u.truly:view() == '{ x: 1, y: 2 }')
    assert(u.falsy:view() == 'never')
end

do
    local a = ls.node.table()
        : addField {
            key   = ls.node.value('x'),
            value = ls.node.value(1)
        }
    local b = ls.node.table()
        : addField {
            key   = ls.node.value('y'),
            value = ls.node.value(2)
        }

    local u = a & b
    assert(u:view() == '{ x: 1 } & { y: 2 }')
    assert(u.truly:view() == '{ x: 1, y: 2 }')
    assert(u.falsy:view() == 'never')
end

do
    ls.node.TYPE_POOL['A'] = nil
    local a = ls.node.type 'A'

    assert(a.truly:view() == 'A')
    assert(a.falsy:view() == 'never')
end

do
    ls.node.TYPE_POOL['A'] = nil
    local a = ls.node.type 'A'
        : addField {
            key   = ls.node.value('x'),
            value = ls.node.value(1)
        }

    assert(a.truly:view() == 'A')
    assert(a.falsy:view() == 'never')
end

do
    ls.node.TYPE_POOL['A'] = nil
    local a = ls.node.type 'A'
        : addAlias(ls.node.value(1))
        : addAlias(ls.node.value(2))
        : addAlias(ls.node.value(true))
        : addAlias(ls.node.value(false))

    assert(a:view() == 'A')
    assert(a.truly:view() == '1 | 2 | true')
    assert(a.falsy:view() == 'false')
end
