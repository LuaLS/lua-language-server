local rt = test.scope.rt

do
    --[[
    local x = 10
    x --> 10
    x = 5
    x --> 5
    V = x
    ]]

    -- local flow = rt.flow({ uri = test.fileUri, offset = 0 })
    -- local x = rt.variable 'x'
    -- flow:addVariable(x)
    -- x:addAssign(rt.field('x', rt.value(10)))
    -- flow:addAssign(x, rt.value(10), 0)
    -- x:addAssign(rt.field('x', rt.value(5)))
    -- flow:addAssign(x, rt.value(5), 10)
    -- local V = rt.variable 'V'
    -- V:addAssign(rt.field('V', x))
    -- flow:addAssign(V, x, 30)

    -- assert(flow:variable(x, 0):view() == '10')
    -- assert(flow:variable(x, 5):view() == '10')
    -- assert(flow:variable(x, 10):view() == '5')
    -- assert(flow:variable(x, 15):view() == '5')
    -- assert(flow:variable(V, 30):view() == '5')
    -- assert(x:view() == '5 | 10')
    -- assert(V:view() == '5')
end

do
    --[[
    local x
    x --> 5 | 10
    x = 10
    x --> 10
    x = 5
    x --> 5
    ]]

    -- local x = rt.variable 'x'
    -- local x1 = x:shadow(rt.value(10))

    -- x1:addAssign(rt.field('x', rt.value(10)))

    -- local x2 = x1:shadow(rt.value(5))
    -- x2:addAssign(rt.field('x', rt.value(5)))

    -- assert(x:view() == '5 | 10')
    -- assert(x1:view() == '10')
    -- assert(x2:view() == '5')
end
