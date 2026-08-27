local rt = test.scope.rt

do
    rt:reset()

    local a = rt.type 'A'
    local b = rt.type 'B'
    rt.alias('A', nil, b)
    rt.alias('B', nil, a)

    lt.assertEquals(a:isTableLike(), false)
    lt.assertEquals(b:isTableLike(), false)
    -- alias 环不应死循环；truthy/falsy 保守返回
    lt.assertEquals(a.truthy:view(), 'A')
    lt.assertEquals(a.falsy:view(), 'never')
end

do
    rt:reset()

    rt.alias('N', nil, rt.NUMBER)

    lt.assertEquals(rt.type('N').truthy:view(), 'N')
    lt.assertEquals(rt.type('N').falsy:view(), 'never')
end
