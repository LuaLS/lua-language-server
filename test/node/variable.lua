local node = test.scope.node

do
    node:reset()
    local var = node.variable('x')

    assert(var:viewVariable() == 'x')
    assert(var.value:view() == 'unknown')
    assert(var.fields == nil)

    local child1 = node.variable(1, var)

    assert(child1:viewVariable() == 'x[1]')
    assert(var.value:view() == 'unknown')
    assert(var.fields == nil)

    local child2 = node.variable('y', child1)

    assert(child2:viewVariable() == 'x[1].y')
    assert(var.value:view() == 'unknown')
    assert(var.fields == nil)
end

do
    node:reset()
    local var = node.variable('x')

    var:addType(node.type 'number')
    assert(var.value:view() == 'number')

    var:addType(node.type 'string')
    assert(var.value:view() == 'number | string')

    var:addClass(node.class 'A')
    assert(var.value:view() == 'A')
end

do
    node:reset()
    local var = node.variable('x')

    var:addField {
        key = node.value 'n',
        value = node.type 'number',
    }

    assert(var:viewVariable() == 'x')
    assert(var.value:view() == 'unknown')
    assert(var.fields:view() == '{ n: number }')

    local a = node.type 'A'

    assert(a.value:view() == 'A')

    local ca = node.class 'A'
    a:addClass(ca)
    ca:addVariable(var)
    assert(a.value:view() == '{ n: number }')

    var:addField {
        key = node.value 'self',
        value = a,
    }
    assert(var.value:view() == 'unknown')
    assert(var.fields:view() == '{ n: number, self: A }')
    assert(a.value:view() == '{ n: number, self: A }')

    var:addClass(ca)
    assert(var.value:view() == 'A')
    assert(var.fields:view() == '{ n: number, self: A }')
    assert(a.value:view() == '{ n: number, self: A }')

    ca:addField {
        key = node.value 's',
        value = node.type 'string',
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
    node:reset()

    local a = node.type 'A'
    local ca = node.class 'A'
    a:addClass(ca)
    ca:addField {
        key = node.value 'x',
        value = node.type 'number',
    }

    local m = node.variable 'M'
    ca:addVariable(m)
    m:addClass(ca)

    m:addField {
        key = node.value '__index',
        value = node.unsolve(node.TABLE, m, function (unsolve, var)
            return var.value
        end),
    }
    m:addField {
        key = node.value 'y',
        value = node.value 'abc',
    }

    assert(a.value:view() == '{ x: number, y: "abc", __index: A }')
    assert(m.value:view() == 'A')
    assert(m.fields:view() == '{ y: "abc", __index: A }')
end

do
    --[[
    a.b.c.d = 1
    ]]
    node:reset()

    local a = node.variable 'a'
    a:addField ({
        key = node.value 'd',
        value = node.value(1),
    }, {'b', 'c'})
    assert(a:viewVariable() == 'a')
    assert(a.value:view() == 'unknown')

    local b = a:getChild('b')
    assert(b)
    assert(b:viewVariable() == 'a.b')
    assert(b.value:view() == 'unknown')

    local c = a:getChild('b', 'c')
    assert(c)
    assert(c:viewVariable() == 'a.b.c')
    assert(c.value:view() == 'unknown')
    assert(c.fields:view() == '{ d: 1 }')

    local d = a:getChild('b', 'c', 'd')
    assert(d)
    assert(d:viewVariable() == 'a.b.c.d')
    assert(d.value:view() == '1')
end

do
    --[[
    ---@class A
    a.b.c.d = {}

    a.b.c.d.x = 1
    a.b.c.d.y = 2
    ]]
    node:reset()

    local a = node.variable 'a'
    local d = a:addField({
        key = node.value 'd',
        value = node.table(),
    }, {'b', 'c'})
    assert(d:viewVariable() == 'a.b.c.d')
    assert(d.value:view() == '{}')
    assert(d.fields == nil)

    local A = node.type 'A'
    local CA = node.class 'A'
    A:addClass(CA)
    CA:addVariable(d)
    d:addClass(CA)
    assert(d:viewVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields == nil)
    assert(A.value:view() == '{}')

    local dx = {
        key = node.value 'x',
        value = node.value(1),
    }
    d:addField(dx)
    assert(d:viewVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields:view() == '{ x: 1 }')
    assert(A.value:view() == '{ x: 1 }')

    local dy = {
        key = node.value 'y',
        value = node.value(2),
    }
    a:addField(dy, {'b', 'c', 'd'})
    assert(d:viewVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields:view() == '{ x: 1, y: 2 }')
    assert(A.value:view() == '{ x: 1, y: 2 }')

    a:removeField(dx, {'b', 'c', 'd'})
    assert(d:viewVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields:view() == '{ y: 2 }')
    assert(A.value:view() == '{ y: 2 }')

    d:removeField(dy)
    assert(d:viewVariable() == 'a.b.c.d')
    assert(d.value:view() == 'A')
    assert(d.fields == nil)
    assert(A.value:view() == '{}')
end
