local rt = test.scope.rt

do
    local t = rt.table()

    lt.assertEquals(t:view(), '{}')

    local field1 = rt.field('x', rt.NUMBER)
    local field2 = rt.field('y', rt.STRING)

    t:addField(field1)
    lt.assertEquals(t:view(), '{ x: number }')

    t:addField(field2)
    lt.assertEquals(t:view(), [[
{
    x: number,
    y: string,
}]])

    t:removeField(field1)
    lt.assertEquals(t:view(), '{ y: string }')

    t:removeField(field2)
    lt.assertEquals(t:view(), '{}')
end

do
    rt:reset()

    local a = rt.type 'A'

    lt.assertEquals(a:get 'x', rt.NEVER)

    local field1 = rt.field('x', rt.NUMBER)
    local field2 = rt.field('x', rt.STRING)
    local ca = rt.class 'A'
    lt.assertEquals(a:get 'x', rt.NIL)

    ca:addField(field1)
    lt.assertEquals(a:get 'x' :view(), 'number')

    local b = rt.type 'B'
    lt.assertEquals(b:get 'x' :view(), 'never')

    local cb = rt.class 'B'

    cb:addExtends(a)
    lt.assertEquals(b:get 'x' :view(), 'number')
    lt.assertEquals(b:get 'y' :view(), 'nil')

    ca:removeField(field1)
    ca:addField(field2)
    lt.assertEquals(a:get 'x' :view(), 'string')
    lt.assertEquals(b:get 'x' :view(), 'string')
end

do
    rt:reset()
    --[[
    ---@class A<T>
    ---@field x T
    ]]

    local a = rt.type 'A'
    local T = rt.generic 'T'

    local ca = rt.class('A', { T })
        : addField(rt.field('x', T))

    local an = a:call { rt.NUMBER }
    lt.assertEquals(an.value:view(), '{ x: number }')
    lt.assertEquals(an:get('x'):view(), 'number')
    lt.assertEquals(an:get('y'):view(), 'nil')

    ca:addField(rt.field('y', rt.STRING))
    lt.assertEquals(an.value:view(), [[
{
    x: number,
    y: string,
}]])
    lt.assertEquals(an:get('y'):view(), 'string')
end

do
    local t1 = rt.table {
        x = 1
    }
    local t2 = rt.table {
        y = 2
    }
    local sec = t1 & t2

    lt.assertEquals(sec:view(), '{ x: 1 } & { y: 2 }')
    lt.assertEquals(sec.value:view(), [[
{
    x: 1,
    y: 2,
}]])

    t1:addField(rt.field('xx', rt.value(11)))
    t2:addField(rt.field('yy', rt.value(22)))

    lt.assertEquals(sec:view(), [[
{
    x: 1,
    xx: 11,
} & {
    y: 2,
    yy: 22,
}]])
    lt.assertEquals(sec.value:view(), [[
{
    x: 1,
    xx: 11,
    y: 2,
    yy: 22,
}]])
end

do
    local t1 = rt.table {
        x = 1
    }
    local t2 = rt.table {
        y = 2
    }
    lt.assertEquals((t1 >> t2), false)

    t1:addField(rt.field('y', rt.value(2)))
    lt.assertEquals((t1 >> t2), true)
end
