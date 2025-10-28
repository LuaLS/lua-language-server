local rt = test.scope.rt

do
    rt:reset()
    local var = rt.variable('x')

    assert(var:viewAsVariable() == 'x')
    assert(var.value:view() == 'unknown')
    assert(var.fields == nil)

    local child1 = rt.variable(1, var)

    assert(child1:viewAsVariable() == 'x[1]')
    assert(var.value:view() == 'unknown')
    assert(var.fields == nil)

    local child2 = rt.variable('y', child1)

    assert(child2:viewAsVariable() == 'x[1].y')
    assert(var.value:view() == 'unknown')
    assert(var.fields == nil)
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

    var:addField {
        key = rt.value 'n',
        value = rt.type 'number',
    }

    assert(var:viewAsVariable() == 'x')
    assert(var.value:view() == '{ n: number }')
    assert(var.fields:view() == '{ n: number }')

    local a = rt.type 'A'

    assert(a.value:view() == 'A')

    local ca = rt.class 'A'
    a:addClass(ca)
    ca:addVariable(var)
    assert(a.value:view() == '{ n: number }')

    var:addField {
        key = rt.value 'self',
        value = a,
    }
    assert(var.value:view() == '{ n: number, self: A }')
    assert(a.value:view() == '{ n: number, self: A }')

    var:addClass(ca)
    assert(var.value:view() == 'A')
    assert(var.fields:view() == '{ n: number, self: A }')
    assert(a.value:view() == '{ n: number, self: A }')

    ca:addField {
        key = rt.value 's',
        value = rt.type 'string',
    }
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
    ca:addField {
        key = rt.value 'x',
        value = rt.type 'number',
    }

    local m = rt.variable 'M'
    ca:addVariable(m)
    m:addClass(ca)

    m:addField {
        key = rt.value '__index',
        value = rt.unsolve(rt.TABLE, m, function (unsolve, var)
            return var.value
        end),
    }
    m:addField {
        key = rt.value 'y',
        value = rt.value 'abc',
    }

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
    a:addField ({
        key = rt.value 'd',
        value = rt.value(1),
    }, {'b', 'c'})
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
    local d = a:addField({
        key = rt.value 'd',
        value = rt.table(),
    }, {'b', 'c'})
    assert(d:viewAsVariable() == 'a.b.c.d')
    assert(d.value:view() == '{}')
    assert(d.fields == nil)

    local A = rt.type 'A'
    local CA = rt.class 'A'
    CA:addVariable(d)
    d:addClass(CA)
    assert(d:viewAsVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields == nil)
    assert(A.value:view() == '{}')

    local dx = {
        key = rt.value 'x',
        value = rt.value(1),
    }
    d:addField(dx)
    assert(d:viewAsVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields:view() == '{ x: 1 }')
    assert(A.value:view() == '{ x: 1 }')

    local dy = {
        key = rt.value 'y',
        value = rt.value(2),
    }
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
    assert(d.fields == nil)
    assert(A.value:view() == '{}')
end
