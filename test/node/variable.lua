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
    var:addField {
        key = node.value 's',
        value = node.type 'string',
    }

    assert(var:view() == 'x')
    assert(var.value:view() == 'unknown')
    assert(var.fields:view() == '{ n: number, s: string }')

    local a = node.type 'A'

    assert(a.value:view() == 'A')

    a:addVariable(var)
    assert(a.value:view() == '{ n: number, s: string }')
end
