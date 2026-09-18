local rt = test.scope.rt

do
    rt:reset()
    local a = rt.variable 'a'
    local b = rt.variable 'b'
    a:setStaticValue(rt.union { b, rt.NUMBER })
    b:setStaticValue(rt.union { a, rt.NUMBER })

    local x = a & b
    lt.assertEquals(x:view(), 'number')
    lt.assertEquals(x.hasGeneric, false)
end

do
    rt:reset()
    local x = rt.intersection { rt.NUMBER, rt.STRING }
    ---@cast x Node.Intersection
    x.rawNodes[1] = x

    lt.assertEquals(x.hasGeneric, false)
    lt.assertEquals(#x.values, 2)
    lt.assertEquals(x.value, x)
end

do
    rt:reset()
    local t = rt.table()
    local x = rt.intersection { rt.NUMBER, rt.STRING }
    ---@cast x Node.Intersection
    t:addField(rt.field('f', x))
    x.rawNodes = { t }

    lt.assertEquals(x.hasGeneric, false)
    lt.assertEquals(x.value, t)
end
