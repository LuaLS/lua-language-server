local rt = test.scope.rt

do
    rt:reset()
    local var = rt.variable('x')

    assert(var:viewAsVariable() == 'x')
    assert(var.value:view() == 'unknown')
    assert(var.fields == false)

    local child1 = rt.variable(1, var)

    assert(child1:viewAsVariable() == 'x[1]')
    assert(var.value:view() == 'unknown')
    assert(var.fields == false)

    local child2 = rt.variable('y', child1)

    assert(child2:viewAsVariable() == 'x[1].y')
    assert(var.value:view() == 'unknown')
    assert(var.fields == false)
end

do
    rt:reset()
    local var = rt.variable('x')

    var:addType(rt.type 'number')
    assert(var.value:view() == 'number')

    var:addType(rt.type 'string')
    assert(var.value:view() == 'number | string')

    var:addClass(rt.class 'A')
    assert(var.value:view() == 'A')
end

do
    rt:reset()
    local var = rt.variable('x')

    var:addField(rt.field(rt.value 'n', rt.type 'number'))

    assert(var:viewAsVariable() == 'x')
    assert(var.value:view() == '{ n: number }')
    assert(var.fields:view() == '{ n: number }')

    local a = rt.type 'A'

    assert(a.value:view() == 'A')

    local ca = rt.class 'A'
    a:addClass(ca)
    ca:addVariable(var)
    assert(a.value:view() == '{ n: number }')

    var:addField(rt.field(rt.value 'self', a))
    assert(var.value:view() == '{ n: number, self: A }')
    assert(a.value:view() == '{ n: number, self: A }')

    var:addClass(ca)
    assert(var.value:view() == 'A')
    assert(var.fields:view() == '{ n: number, self: A }')
    assert(a.value:view() == '{ n: number, self: A }')

    ca:addField(rt.field(rt.value 's', rt.type 'string'))
    assert(var.value:view() == 'A')
    assert(var.fields:view() == '{ n: number, self: A }')
    assert(a.value:view() == '{ n: number, s: string, self: A }')
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

    assert(a.value:view() == '{ x: number, y: "abc", __index: A }')
    assert(m.value:view() == 'A')
    assert(m.fields:view() == '{ y: "abc", __index: A }')
end

do
    --[[
    a.b.c.d = 1
    ]]
    rt:reset()

    local a = rt.variable 'a'
    a:addField(rt.field(rt.value 'd', rt.value(1)), {'b', 'c'})
    assert(a:viewAsVariable() == 'a')
    assert(a:view() == '{ b: { c: { d: 1 } } }')

    local b = a:getChild('b')
    assert(b)
    assert(b:viewAsVariable() == 'a.b')
    assert(b:view() == '{ c: { d: 1 } }')

    local c = a:getChild('b', 'c')
    assert(c)
    assert(c:viewAsVariable() == 'a.b.c')
    assert(c:view() == '{ d: 1 }')

    local d = a:getChild('b', 'c', 'd')
    assert(d)
    assert(d:viewAsVariable() == 'a.b.c.d')
    assert(d:view() == '1')
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
    assert(d:viewAsVariable() == 'a.b.c.d')
    assert(d.value:view() == '{}')
    assert(d.fields:view() == '{}')

    local A = rt.type 'A'
    local CA = rt.class 'A'
    CA:addVariable(d)
    d:addClass(CA)
    assert(d:viewAsVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields:view() == '{}')
    assert(A.value:view() == '{}')

    local dx = rt.field(rt.value 'x', rt.value(1))
    d:addField(dx)
    assert(d:viewAsVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields:view() == '{ x: 1 }')
    assert(A.value:view() == '{ x: 1 }')

    local dy = rt.field(rt.value 'y', rt.value(2))
    a:addField(dy, {'b', 'c', 'd'})
    assert(d:viewAsVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields:view() == '{ x: 1, y: 2 }')
    assert(A.value:view() == '{ x: 1, y: 2 }')

    a:removeField(dx, {'b', 'c', 'd'})
    assert(d:viewAsVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields:view() == '{ y: 2 }')
    assert(A.value:view() == '{ y: 2 }')

    d:removeField(dy)
    assert(d:viewAsVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields:view() == '{}')
    assert(A.value:view() == '{}')
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

    assert(T.fields == false)
    assert(T:view() == '{ a: 1 }')

    local TA = T:getChild 'a'
    assert(TA:view() == '1')
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

    assert(T.fields == false)
    assert(T:view() == '{ a: { b: 1 } }')

    local TA = T:getChild('a', 'b')
    assert(TA:view() == '1')
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

    assert(T.fields == false)
    assert(T:view() == '{ b: 1 }')

    local TA = T:getChild('b')
    assert(TA:view() == '1')
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

    assert(Z:view() == '{ a: 1 }')
    assert(#A:getEquivalentLocations() == 1)
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

    assert(X:view() == '{ y: { z: 1 } }')
end
