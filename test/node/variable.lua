local rt = test.scope.rt

do
    rt:reset()
    local var = rt.variable('x')

    lt.assertEquals(var:viewAsVariable(), 'x')
    lt.assertEquals(var.value:view(), 'any')
    lt.assertEquals(var.fields, false)

    local child1 = rt.variable(1, var)

    lt.assertEquals(child1:viewAsVariable(), 'x[1]')
    lt.assertEquals(var.value:view(), 'any')
    lt.assertEquals(var.fields, false)

    local child2 = rt.variable('y', child1)

    lt.assertEquals(child2:viewAsVariable(), 'x[1].y')
    lt.assertEquals(var.value:view(), 'any')
    lt.assertEquals(var.fields, false)
end

do
    rt:reset()
    local var = rt.variable('x')

    var:addType(rt.type 'number')
    lt.assertEquals(var.value:view(), 'number')

    var:addType(rt.type 'string')
    lt.assertEquals(var.value:view(), 'number | string')

    var:addClass(rt.class 'A')
    lt.assertEquals(var.value:view(), 'A')
end

do
    rt:reset()
    local var = rt.variable('x')

    var:addField(rt.field(rt.value 'n', rt.type 'number'))

    lt.assertEquals(var:viewAsVariable(), 'x')
    lt.assertEquals(var.value:view(), '{ n: number }')
    lt.assertEquals(var.fields:view(), '{ n: number }')

    local a = rt.type 'A'

    lt.assertEquals(a.value:view(), 'A')

    local ca = rt.class 'A'
    a:addClass(ca)
    ca:addVariable(var)
    lt.assertEquals(a.value:view(), '{ n: number }')

    var:addField(rt.field(rt.value 'self', a))
    lt.assertEquals(var.value:view(), [[
{
    n: number,
    self: A,
}]])
    lt.assertEquals(a.value:view(), [[
{
    n: number,
    self: A,
}]])

    var:addClass(ca)
    lt.assertEquals(var.value:view(), 'A')
    lt.assertEquals(var.fields:view(), [[
{
    n: number,
    self: A,
}]])
    lt.assertEquals(a.value:view(), [[
{
    n: number,
    self: A,
}]])

    ca:addField(rt.field(rt.value 's', rt.type 'string'))
    lt.assertEquals(var.value:view(), 'A')
    lt.assertEquals(var.fields:view(), [[
{
    n: number,
    self: A,
}]])
    lt.assertEquals(a.value:view(), [[
{
    n: number,
    s: string,
    self: A,
}]])
end

do
    --[[
    ---@class A
    ---@field x number
    local M = {}
    M.__index = M

    M.y = 'abc'
    ]]
    rt:reset()

    local a = rt.type 'A'
    local ca = rt.class 'A'
    ca:addField(rt.field(rt.value 'x', rt.type 'number'))

    local m = rt.variable 'M'
    ca:addVariable(m)
    m:addClass(ca)

    m:addField(rt.field(rt.value '__index', m))
    m:addField(rt.field(rt.value 'y', rt.value 'abc'))

    lt.assertEquals(a.value:view(), [[
{
    x: number,
    y: "abc",
    __index: A,
}]])
    lt.assertEquals(m.value:view(), 'A')
    lt.assertEquals(m.fields:view(), [[
{
    y: "abc",
    __index: A,
}]])
end

do
    --[[
    a.b.c.d = 1
    ]]
    rt:reset()

    local a = rt.variable 'a'
    a:addField(rt.field(rt.value 'd', rt.value(1)), {'b', 'c'})
    lt.assertEquals(a:viewAsVariable(), 'a')
    lt.assertEquals(a:view(), '{ b: { c: { d: 1 } } }')

    local b = a:getChild('b')
    assert(b)
    lt.assertEquals(b:viewAsVariable(), 'a.b')
    lt.assertEquals(b:view(), '{ c: { d: 1 } }')

    local c = a:getChild('b', 'c')
    assert(c)
    lt.assertEquals(c:viewAsVariable(), 'a.b.c')
    lt.assertEquals(c:view(), '{ d: 1 }')

    local d = a:getChild('b', 'c', 'd')
    assert(d)
    lt.assertEquals(d:viewAsVariable(), 'a.b.c.d')
    lt.assertEquals(d:view(), '1')
end

do
    --[[
    ---@class A
    a.b.c.d = {}

    a.b.c.d.x = 1
    a.b.c.d.y = 2
    ]]
    rt:reset()

    local a = rt.variable 'a'
    local d = a:addField(rt.field(rt.value 'd', rt.table()), {'b', 'c'})
    lt.assertEquals(d:viewAsVariable(), 'a.b.c.d')
    lt.assertEquals(d.value:view(), '{}')
    lt.assertEquals(d.fields:view(), '{}')

    local A = rt.type 'A'
    local CA = rt.class 'A'
    CA:addVariable(d)
    d:addClass(CA)
    lt.assertEquals(d:viewAsVariable(), 'a.b.c.d')
    lt.assertEquals(d.value:view(), 'A')
    lt.assertEquals(d.fields:view(), '{}')
    lt.assertEquals(A.value:view(), '{}')

    local dx = rt.field(rt.value 'x', rt.value(1))
    d:addField(dx)
    lt.assertEquals(d:viewAsVariable(), 'a.b.c.d')
    lt.assertEquals(d.value:view(), 'A')
    lt.assertEquals(d.fields:view(), '{ x: 1 }')
    lt.assertEquals(A.value:view(), '{ x: 1 }')

    local dy = rt.field(rt.value 'y', rt.value(2))
    a:addField(dy, {'b', 'c', 'd'})
    lt.assertEquals(d:viewAsVariable(), 'a.b.c.d')
    lt.assertEquals(d.value:view(), 'A')
    lt.assertEquals(d.fields:view(), [[
{
    x: 1,
    y: 2,
}]])
    lt.assertEquals(A.value:view(), [[
{
    x: 1,
    y: 2,
}]])

    a:removeField(dx, {'b', 'c', 'd'})
    lt.assertEquals(d:viewAsVariable(), 'a.b.c.d')
    lt.assertEquals(d.value:view(), 'A')
    lt.assertEquals(d.fields:view(), '{ y: 2 }')
    lt.assertEquals(A.value:view(), '{ y: 2 }')

    d:removeField(dy)
    lt.assertEquals(d:viewAsVariable(), 'a.b.c.d')
    lt.assertEquals(d.value:view(), 'A')
    lt.assertEquals(d.fields:view(), '{}')
    lt.assertEquals(A.value:view(), '{}')
end

do
    rt:reset()
    --[[
    X.a = 1
    local t = X
    print(t.a)
    ]]

    local X = rt.variable 'X'
    X:addField(rt.field(rt.value 'a', rt.value(1)))

    local T = rt.variable 't'
    T:addAssign(rt.field(rt.value 't', X))

    lt.assertEquals(T.fields, false)
    lt.assertEquals(T:view(), '{ a: 1 }')

    local TA = T:getChild 'a'
    lt.assertEquals(TA:view(), '1')
end

do
    rt:reset()
    --[[
    X.a.b = 1
    local t = X
    print(t.a.b)
    ]]

    local X = rt.variable 'X'
    X:addField(rt.field(rt.value 'b', rt.value(1)), { 'a' })

    local T = rt.variable 't'
    T:addAssign(rt.field(rt.value 't', X))

    lt.assertEquals(T.fields, false)
    lt.assertEquals(T:view(), '{ a: { b: 1 } }')

    local TA = T:getChild('a', 'b')
    lt.assertEquals(TA:view(), '1')
end

do
    rt:reset()
    --[[
    X.a.b = 1
    local t = X.a
    print(t.b)
    ]]

    local X = rt.variable 'X'
    X:addField(rt.field(rt.value 'b', rt.value(1)), { 'a' })

    local T = rt.variable 't'
    T:addAssign(rt.field(rt.value 't', X:getChild 'a'))

    lt.assertEquals(T.fields, false)
    lt.assertEquals(T:view(), '{ b: 1 }')

    local TA = T:getChild('b')
    lt.assertEquals(TA:view(), '1')
end

do
    rt:reset()
    --[[
    x.a = 1
    y = x
    z = y
    print(z.a)
    ]]
    local X = rt.variable 'x'
    X:addField(rt.field(rt.value 'a', rt.value(1)):setLocation({ uri = test.fileUri, offset = 0 }))
    local Y = rt.variable 'y'
    Y:addAssign(rt.field(rt.value 'y', X))
    local Z = rt.variable 'z'
    Z:addAssign(rt.field(rt.value 'z', Y))
    local A = Z:getChild 'a'

    lt.assertEquals(Z:view(), '{ a: 1 }')
    lt.assertEquals(#A:getEquivalentLocations(), 1)
end

do
    rt:reset()

    --[[
    local x = { y = {} }
    x.y.z = 1
    ]]

    local X = rt.variable 'x'

    X:addAssign(rt.field(rt.value 'x', rt.table {
        y = rt.table(),
    }))

    X:addField(rt.field(rt.value 'z', rt.value(1)), { 'y' })

    lt.assertEquals(X:view(), '{ y: { z: 1 } }')
end
