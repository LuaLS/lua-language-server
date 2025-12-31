local rt = test.scope.rt

do
    rt:reset()
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
    -- 维持住引用
    local A = rt.type 'A'
    rt.alias('A', nil, rt.value(1))
    rt.alias('A', {
        rt.generic 'X',
        rt.generic 'Y',
    }, rt.value(2))
    rt.alias('A', {
        rt.generic('X', rt.NUMBER),
        rt.generic 'Y',
    }, rt.value(3))
    rt.alias('A', {
        rt.generic 'X',
        rt.generic('Y', rt.NUMBER),
    }, rt.value(4))
    rt.alias('A', {
        rt.generic('X', rt.NUMBER),
        rt.generic('Y', rt.STRING),
    }, rt.value(5))
    rt.alias('A', {
        rt.generic('X', rt.NUMBER),
        rt.generic('Y', rt.NUMBER),
    }, rt.value(6))

    local r1 = rt.call('A', { rt.value(1), rt.value(1) })
    local r2 = rt.call('A', { rt.value(1), rt.value 'x' })
    local r3 = rt.call('A', { rt.value(1), rt.value(true) })
    local r4 = rt.call('A', { rt.value 'x', rt.value(1) })
    local r5 = rt.call('A', { rt.value 'x', rt.value(true) })
    local r6 = rt.type('A')

    lt.assertEquals(r1.value:view(), '6')
    lt.assertEquals(r2.value:view(), '5')
    lt.assertEquals(r3.value:view(), '3')
    lt.assertEquals(r4.value:view(), '4')
    lt.assertEquals(r5.value:view(), '2')
    lt.assertEquals(r6.value:view(), '1')
end
