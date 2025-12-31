local rt = test.scope.rt

do
    rt:reset()

    local s1 = rt.value('hello')
    local s2 = rt.value('hello', '"')
    local s3 = rt.value('hello', "'")
    local s4 = rt.value('hello', '[[')

    lt.assertEquals(s1:view(), '"hello"')
    lt.assertEquals(s2:view(), '"hello"')
    lt.assertEquals(s3:view(), "'hello'")
    lt.assertEquals(s4:view(), '[[hello]]')

    lt.assertEquals(s1 >> s2, true)
    lt.assertEquals(s1 >> s3, true)
    lt.assertEquals(s1 >> s4, true)
    lt.assertEquals(s2 >> s1, true)
    lt.assertEquals(s2 >> s3, true)
    lt.assertEquals(s2 >> s4, true)
    lt.assertEquals(s3 >> s1, true)
    lt.assertEquals(s3 >> s2, true)
    lt.assertEquals(s3 >> s4, true)
    lt.assertEquals(s4 >> s1, true)
    lt.assertEquals(s4 >> s2, true)
    lt.assertEquals(s4 >> s3, true)

    local t = rt.table()
    t:addField(rt.field(s2, rt.value(1)))

    local v = t:get(s3)
    lt.assertEquals(v:view(), '1')

    t:addField(rt.field(s4, rt.value(2)))

    local v = t:get(s2)
    lt.assertEquals(v:view(), '2')
end
