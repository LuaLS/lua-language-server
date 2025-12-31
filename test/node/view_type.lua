local rt = test.scope.rt

do
    rt:reset()

    local a = rt.type('A')

    lt.assertEquals(a:view(), 'A')
    lt.assertEquals(a.value:view(), 'A')
end

do
    rt:reset()
    --[[
    ---@class A
    ---@field x 'x'
    ---@field y 'y'
    ]]

    local a = rt.type('A')
    rt.class('A')
        : addField(rt.field(rt.value 'x', rt.value 'x'))
        : addField(rt.field(rt.value 'y', rt.value 'y'))

    lt.assertEquals(a:view(), 'A')
    lt.assertEquals(a.value:view(), [[
{
    x: "x",
    y: "y",
}]])
end

do
    rt:reset()
    --[[
    ---@class A: B, C, D

    ---@class B
    ---@field x 'x'

    ---@class C
    ---@field y 'y'

    ---@class D
    ---@field z 'z'
    ]]

    local a = rt.type('A')
    local b = rt.type('B')
    rt.class('B')
        : addField(rt.field(rt.value 'x', rt.value 'x'))
    local c = rt.type('C')
    rt.class('C')
        : addField(rt.field(rt.value 'y', rt.value 'y'))
    local d = rt.type('D')
    rt.class('D')
        : addField(rt.field(rt.value 'z', rt.value 'z'))

    rt.class('A', nil, { b, c, d })

    lt.assertEquals(a:view(), 'A')
    lt.assertEquals(a.value:view(), [[
{
    x: "x",
    y: "y",
    z: "z",
}]])
end

do
    rt:reset()
    --[[
    ---@class A: B, C, D
    ---@field w 1
    ---@field x 2
    ---@field y 3

    ---@class B
    ---@field field x 'x'

    ---@class C
    ---@field field y 'y'

    ---@class D
    ---@field field z 'z'
    ]]

    local a = rt.type('A')
    rt.class('A')
        : addField(rt.field(rt.value 'w', rt.value '1'))
        : addField(rt.field(rt.value 'x', rt.value '2'))
        : addField(rt.field(rt.value 'y', rt.value '3'))
        : addExtends(rt.type 'B')
        : addExtends(rt.type 'C')
        : addExtends(rt.type 'D')

    rt.class('B')
        : addField(rt.field(rt.value 'x', rt.value 'x'))

    rt.class('C')
        : addField(rt.field(rt.value 'y', rt.value 'y'))

    rt.class('D')
        : addField(rt.field(rt.value 'z', rt.value 'z'))

    lt.assertEquals(a:view(), 'A')
    lt.assertEquals(a.value:view(), [[
{
    w: "1",
    x: "2",
    y: "3",
    z: "z",
}]])
end

do
    rt:reset()
    --[[
    ---@alias A 1
    ---@alias A 2
    ---@alias A 3
    ]]

    local a = rt.type('A')
    rt.alias('A', nil, rt.value(1))
    rt.alias('A', nil, rt.value(2))
    rt.alias('A', nil, rt.value(3))

    lt.assertEquals(a:view(), 'A')
    lt.assertEquals(a.value:view(), '1 | 2 | 3')
end

do
    rt:reset()
    --[[
    ---@alias A B
    ---@alias A C
    ---@alias A D

    ---@alias B 1
    ---@alias B 2

    ---@alias C 2
    ---@alias C 3

    ---@alias D 3
    ---@alias D 4
    ]]

    local a = rt.type('A')
    rt.alias('A', nil, rt.type 'B')
    rt.alias('A', nil, rt.type 'C')
    rt.alias('A', nil, rt.type 'D')
    rt.type('B')
    rt.alias('B', nil, rt.value(1))
    rt.alias('B', nil, rt.value(2))
    rt.type('C')
    rt.alias('C', nil, rt.value(2))
    rt.alias('C', nil, rt.value(3))
    rt.type('D')
    rt.alias('D', nil, rt.value(3))
    rt.alias('D', nil, rt.value(4))

    lt.assertEquals(a:view(), 'A')
    lt.assertEquals(a.value:view(), 'B | C | D')
end

do
    rt:reset()
    --[[
    ---@class A: { [string]: boolean }
    ]]

    local a = rt.type('A')
    rt.class('A', nil, { rt.table {
        [rt.STRING] = rt.BOOLEAN,
    }})

    lt.assertEquals(a:view(), 'A')
    lt.assertEquals(a.value:view(), '{ [string]: boolean }')
end

do
    rt:reset()
    --[[
    ---@class A: B
    ---@field x 1

    ---@class B: A
    ---@field y 2
    ]]

    local a = rt.type('A')
    rt.class('A', nil, { rt.type 'B' })
        : addField(rt.field(rt.value('x'), rt.value(1)))


    local b = rt.type('B')
    rt.class('B', nil, { rt.type 'A' })
        : addField(rt.field(rt.value('y'), rt.value(2)))


    lt.assertEquals(a:view(), 'A')
    lt.assertEquals(a.value:view(), [[
{
    x: 1,
    y: 2,
}]])

    lt.assertEquals(b:view(), 'B')
    lt.assertEquals(b.value:view(), [[
{
    x: 1,
    y: 2,
}]])
end
