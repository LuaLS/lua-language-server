local rt = test.scope.rt

do
    local t = rt.table {
        [1] = rt.value(100),
        [2] = rt.value(200),
    }

    lt.assertEquals(t:get(1):view(), '100')
    lt.assertEquals(t:get(2):view(), '200')
    lt.assertEquals(t:get(3):view(), 'nil')
    lt.assertEquals(t:get(rt.INTEGER):view(), '100 | 200')
    lt.assertEquals(t:get(rt.NUMBER):view(), '100 | 200')
end

do
    local t = rt.table {
        [rt.INTEGER] = rt.TRUE,
    }

    lt.assertEquals(t:get(1):view(), 'true')
    lt.assertEquals(t:get(2):view(), 'true')
    lt.assertEquals(t:get(rt.INTEGER):view(), 'true')
    lt.assertEquals(t:get(rt.NUMBER):view(), 'true')
end

do
    local t = rt.table {
        [rt.NUMBER] = rt.TRUE,
    }

    lt.assertEquals(t:get(1):view(), 'true')
    lt.assertEquals(t:get(2):view(), 'true')
    lt.assertEquals(t:get(rt.INTEGER):view(), 'true')
    lt.assertEquals(t:get(rt.NUMBER):view(), 'true')
end

do
    local A = rt.class('A')
    A:addField(rt.field('x', rt.NUMBER))

    local t = rt.table {
        x = rt.TRUE,
    }

    t:setExpectParent(rt.type 'A')

    lt.assertEquals(t:get('x'):view(), 'number')
end

-- string key 查 rt.STRING 泛型 key（类似 integer 查 rt.INTEGER 的情况）
do
    local t = rt.table {
        [rt.STRING] = rt.TRUE,
    }

    lt.assertEquals(t:get('foo'):view(), 'true')
    lt.assertEquals(t:get('bar'):view(), 'true')
    lt.assertEquals(t:get(rt.STRING):view(), 'true')
end

-- table<string, "red"|"blue"> 风格：泛型 string key 映射到联合字面量值
do
    local t = rt.table {
        [rt.STRING] = rt.union { rt.value 'red', rt.value 'blue' },
    }

    lt.assertEquals(t:get('foo'):view(), '"red" | "blue"')
    lt.assertEquals(t:get(rt.STRING):view(), '"red" | "blue"')
end
