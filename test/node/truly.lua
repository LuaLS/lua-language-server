local rt = test.scope.rt

do
    assert(rt.ANY.truly:view() == 'truly')
    assert(rt.ANY.falsy:view() == 'false | nil')

    assert(rt.UNKNOWN.truly:view() == 'truly')
    assert(rt.UNKNOWN.falsy:view() == 'false')

    assert(rt.TRULY.truly:view() == 'truly')
    assert(rt.TRULY.falsy:view() == 'never')

    assert(rt.NIL.truly:view() == 'never')
    assert(rt.NIL.falsy:view() == 'nil')

    assert(rt.BOOLEAN.truly:view() == 'true')
    assert(rt.BOOLEAN.falsy:view() == 'false')

    assert(rt.TRUE.truly:view() == 'true')
    assert(rt.TRUE.falsy:view() == 'never')

    assert(rt.FALSE.truly:view() == 'never')
    assert(rt.FALSE.falsy:view() == 'false')

    assert(rt.TABLE.truly:view() == 'table')
    assert(rt.TABLE.falsy:view() == 'never')

    assert(rt.value(0).truly:view() == '0')
    assert(rt.value(0).falsy:view() == 'never')

    assert(rt.value(1).truly:view() == '1')
    assert(rt.value(1).falsy:view() == 'never')
end

do
    local u = rt.value(0) | rt.value(1) | rt.value(true) | rt.value(false) | rt.NIL

    assert(u:view() == '0 | 1 | true | false | nil')
    assert(u.truly:view() == '0 | 1 | true')
    assert(u.falsy:view() == 'false | nil')
end

do
    local u = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))

    assert(u:view() == '{ x: 1, y: 2 }')
    assert(u.truly:view() == '{ x: 1, y: 2 }')
    assert(u.falsy:view() == 'never')
end

do
    local a = rt.table()
        : addField(rt.field('x', rt.value(1)))
    local b = rt.table()
        : addField(rt.field('y', rt.value(2)))

    local u = a & b
    assert(u:view() == '{ x: 1 } & { y: 2 }')
    assert(u.truly:view() == '{ x: 1, y: 2 }')
    assert(u.falsy:view() == 'never')
end

do
    rt.TYPE_POOL['A'] = nil
    local a = rt.type 'A'

    assert(a.truly:view() == 'A')
    assert(a.falsy:view() == 'never')
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.class('A')
        : addField(rt.field('x', rt.value(1)))

    assert(a.truly:view() == 'A')
    assert(a.falsy:view() == 'never')
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.value(1))
    rt.alias('A', nil, rt.value(2))
    rt.alias('A', nil, rt.value(true))
    rt.alias('A', nil, rt.value(false))

    assert(a:view() == 'A')
    assert(a.truly:view() == '1 | 2 | true')
    assert(a.falsy:view() == 'false')
end
