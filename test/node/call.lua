local node = test.scope.node

do
    node:reset()
    --[[
    ---@alias A 1
    ---@alias A<X, Y> 2
    ---@alias A<X: number, Y> 3
    ---@alias A<X, Y: number> 4
    ---@alias A<X: number, Y: string> 5
    ---@alias A<X: number, Y: number> 6

    A<1, 1> --> 6
    A<1, 'x'> --> 5
    A<1, true> --> 3
    A<'x', 1> --> 4
    A<'x', true> --> 2
    A --> 1
    ]]
    node.alias('A', nil, node.value(1))
    node.alias('A', {
        node.generic 'X',
        node.generic 'Y',
    }, node.value(2))
    node.alias('A', {
        node.generic('X', node.NUMBER),
        node.generic 'Y',
    }, node.value(3))
    node.alias('A', {
        node.generic 'X',
        node.generic('Y', node.NUMBER),
    }, node.value(4))
    node.alias('A', {
        node.generic('X', node.NUMBER),
        node.generic('Y', node.STRING),
    }, node.value(5))
    node.alias('A', {
        node.generic('X', node.NUMBER),
        node.generic('Y', node.NUMBER),
    }, node.value(6))

    local r1 = node.call('A', { node.value(1), node.value(1) })
    local r2 = node.call('A', { node.value(1), node.value 'x' })
    local r3 = node.call('A', { node.value(1), node.value(true) })
    local r4 = node.call('A', { node.value 'x', node.value(1) })
    local r5 = node.call('A', { node.value 'x', node.value(true) })
    local r6 = node.type('A')

    assert(r1.value:view() == '6')
    assert(r2.value:view() == '5')
    assert(r3.value:view() == '3')
    assert(r4.value:view() == '4')
    assert(r5.value:view() == '2')
    assert(r6.value:view() == '1')
end
