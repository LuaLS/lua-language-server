local rt = test.scope.rt

do
    lt.assertEquals(rt.ANY.truly:view(), 'truly')
    lt.assertEquals(rt.ANY.falsy:view(), 'false | nil')

    lt.assertEquals(rt.UNKNOWN.truly:view(), 'truly')
    lt.assertEquals(rt.UNKNOWN.falsy:view(), 'false')

    lt.assertEquals(rt.TRULY.truly:view(), 'truly')
    lt.assertEquals(rt.TRULY.falsy:view(), 'never')

    lt.assertEquals(rt.NIL.truly:view(), 'never')
    lt.assertEquals(rt.NIL.falsy:view(), 'nil')

    lt.assertEquals(rt.BOOLEAN.truly:view(), 'true')
    lt.assertEquals(rt.BOOLEAN.falsy:view(), 'false')

    lt.assertEquals(rt.TRUE.truly:view(), 'true')
    lt.assertEquals(rt.TRUE.falsy:view(), 'never')

    lt.assertEquals(rt.FALSE.truly:view(), 'never')
    lt.assertEquals(rt.FALSE.falsy:view(), 'false')

    lt.assertEquals(rt.TABLE.truly:view(), 'table')
    lt.assertEquals(rt.TABLE.falsy:view(), 'never')

    lt.assertEquals(rt.value(0).truly:view(), '0')
    lt.assertEquals(rt.value(0).falsy:view(), 'never')

    lt.assertEquals(rt.value(1).truly:view(), '1')
    lt.assertEquals(rt.value(1).falsy:view(), 'never')
end

do
    local u = rt.value(0) | rt.value(1) | rt.value(true) | rt.value(false) | rt.NIL

    lt.assertEquals(u:view(), '0 | 1 | true | false | nil')
    lt.assertEquals(u.truly:view(), '0 | 1 | true')
    lt.assertEquals(u.falsy:view(), 'false | nil')
end

do
    local u = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))

    lt.assertEquals(u:view(), [[
{
    x: 1,
    y: 2,
}]])
    lt.assertEquals(u.truly:view(), [[
{
    x: 1,
    y: 2,
}]])
    lt.assertEquals(u.falsy:view(), 'never')
end

do
    local a = rt.table()
        : addField(rt.field('x', rt.value(1)))
    local b = rt.table()
        : addField(rt.field('y', rt.value(2)))

    local u = a & b
    lt.assertEquals(u:view(), '{ x: 1 } & { y: 2 }')
    lt.assertEquals(u.truly:view(), [[
{
    x: 1,
    y: 2,
}]])
    lt.assertEquals(u.falsy:view(), 'never')
end

do
    rt.TYPE_POOL['A'] = nil
    local a = rt.type 'A'

    lt.assertEquals(a.truly:view(), 'A')
    lt.assertEquals(a.falsy:view(), 'A')
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.class('A')
        : addField(rt.field('x', rt.value(1)))

    lt.assertEquals(a.truly:view(), 'A')
    lt.assertEquals(a.falsy:view(), 'never')
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.value(1))
    rt.alias('A', nil, rt.value(2))
    rt.alias('A', nil, rt.value(true))
    rt.alias('A', nil, rt.value(false))

    lt.assertEquals(a:view(), 'A')
    lt.assertEquals(a.truly:view(), '1 | 2 | true')
    lt.assertEquals(a.falsy:view(), 'false')
end
