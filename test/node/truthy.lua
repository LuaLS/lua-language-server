local rt = test.scope.rt

do
    lt.assertEquals(rt.ANY.truthy:view(), 'truthy')
    lt.assertEquals(rt.ANY.falsy:view(), 'false | nil')

    lt.assertEquals(rt.UNKNOWN.truthy:view(), 'truthy')
    lt.assertEquals(rt.UNKNOWN.falsy:view(), 'false')

    lt.assertEquals(rt.TRUTHY.truthy:view(), 'truthy')
    lt.assertEquals(rt.TRUTHY.falsy:view(), 'never')

    lt.assertEquals(rt.NIL.truthy:view(), 'never')
    lt.assertEquals(rt.NIL.falsy:view(), 'nil')

    lt.assertEquals(rt.BOOLEAN.truthy:view(), 'true')
    lt.assertEquals(rt.BOOLEAN.falsy:view(), 'false')

    lt.assertEquals(rt.TRUE.truthy:view(), 'true')
    lt.assertEquals(rt.TRUE.falsy:view(), 'never')

    lt.assertEquals(rt.FALSE.truthy:view(), 'never')
    lt.assertEquals(rt.FALSE.falsy:view(), 'false')

    lt.assertEquals(rt.TABLE.truthy:view(), 'table')
    lt.assertEquals(rt.TABLE.falsy:view(), 'never')

    lt.assertEquals(rt.value(0).truthy:view(), '0')
    lt.assertEquals(rt.value(0).falsy:view(), 'never')

    lt.assertEquals(rt.value(1).truthy:view(), '1')
    lt.assertEquals(rt.value(1).falsy:view(), 'never')
end

do
    local u = rt.value(0) | rt.value(1) | rt.value(true) | rt.value(false) | rt.NIL

    lt.assertEquals(u:view(), '0 | 1 | boolean | nil')
    lt.assertEquals(u.truthy:view(), '0 | 1 | true')
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
    lt.assertEquals(u.truthy:view(), [[
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
    lt.assertEquals(u:view(), [[
{
    x: 1,
    y: 2,
}]])
    lt.assertEquals(u.truthy:view(), [[
{
    x: 1,
    y: 2,
}]])
    lt.assertEquals(u.falsy:view(), 'never')
end

do
    rt.TYPE_POOL['A'] = nil
    local a = rt.type 'A'

    lt.assertEquals(a.truthy:view(), 'A')
    lt.assertEquals(a.falsy:view(), 'A')
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.class('A')
        : addField(rt.field('x', rt.value(1)))

    lt.assertEquals(a.truthy:view(), 'A')
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
    lt.assertEquals(a.truthy:view(), '1 | 2 | true')
    lt.assertEquals(a.falsy:view(), 'false')
end
