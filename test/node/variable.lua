local node = test.scope.node

do
    node:reset()
    local var = node.variable('x')

    assert(var:view() == 'x')
    assert(var.value:view() == 'unknown')
    assert(var.fields == nil)

    local child1 = node.variable(1, var)

    assert(child1:view() == 'x[1]')
    assert(var.value:view() == 'unknown')
    assert(var.fields == nil)

    local child2 = node.variable('y', child1)

    assert(child2:view() == 'x[1].y')
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

    var:addClass(node.type 'A')
    assert(var.value:view() == 'A')
end

do
    node:reset()
    local var = node.variable('x')

    var:addField {
        key = node.value 'n',
        value = node.type 'number',
    }

    assert(var:view() == 'x')
    assert(var.value:view() == 'unknown')
    assert(var.fields:view() == '{ n: number }')

    local a = node.type 'A'

    assert(a.value:view() == 'A')

    a:addVariable(var)
    assert(a.value:view() == '{ n: number }')

    var:addField {
        key = node.value 'self',
        value = a,
    }
    assert(var.value:view() == 'unknown')
    assert(var.fields:view() == '{ n: number, self: A }')
    assert(a.value:view() == '{ n: number, self: A }')

    var:addClass(node.type 'A')
    assert(var.value:view() == 'A')
    assert(var.fields:view() == '{ n: number, self: A }')
    assert(a.value:view() == '{ n: number, self: A }')

    a:addField {
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
    a:addField {
        key = node.value 'x',
        value = node.type 'number',
    }

    local m = node.variable 'M'
    a:addVariable(m)
    m:addClass(a)

    m:addField {
        key = node.value '__index',
        value = node.unsolve(node.TABLE, m, function (unsolve, var)
            return var.value
        end)
    }
    m:addField {
        key = node.value 'y',
        value = node.value 'abc',
    }

    assert(a.value:view() == '{ x: number, y: "abc", __index: A }')
    assert(m.value:view() == 'A')
    assert(m.fields:view() == '{ y: "abc", __index: A }')
end
