local rt = test.scope.rt

do
    rt:reset()
    -- 「表值 → 类」：类上没被写到的必填字段不算不匹配（缺字段交给 missing-fields 一类专门规则），
    -- 但实参里**已出现**的字段类型照旧要比；数组之类的非表值不受此宽限
    local C = rt.class 'C'
    C:addField(rt.field('x', rt.INTEGER))
    C:addField(rt.field('y', rt.INTEGER))

    local full  = rt.table { x = rt.value(1), y = rt.value(2) }
    local miss  = rt.table { x = rt.value(1) }
    local wrong = rt.table { x = rt.value 'str', y = rt.value(2) }

    lt.assertEquals(full  >> rt.type 'C', true)
    lt.assertEquals(miss  >> rt.type 'C', true)
    lt.assertEquals(wrong >> rt.type 'C', false)
    lt.assertEquals(rt.array(rt.INTEGER) >> rt.type 'C', false)
end

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))

    local B = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field('z', rt.value(3)))

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, true)
end

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('y')))
        : addField(rt.field(3, rt.value('z')))

    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('y')))
        : addField(rt.field(3, rt.value('z')))

    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
        : addField(rt.field('y', rt.value(2)))
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('y')))
        : addField(rt.field(3, rt.value(false)))

    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.table()
        : addField(rt.field(rt.type('number'), rt.value('x')))

    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.table()
        : addField(rt.field(rt.type('number'), rt.value(false)))

    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.table()
        : addField(rt.field(1, rt.value(5)))
        : addField(rt.field(2, rt.value(true)))
        : addField(rt.field(3, rt.value('hello')))

    local B = rt.tuple()
        : insert(rt.NUMBER)
        : insert(rt.BOOLEAN)
        : insert(rt.STRING)

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.array(rt.type 'string')

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.table()
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('x')))

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, true)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.table()
        : addField(rt.field(1, rt.value('x')))
        : addField(rt.field(2, rt.value('x')))
        : addField(rt.field(3, rt.value('y')))

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.tuple()
        : insert(rt.STRING)
        : insert(rt.STRING)
        : insert(rt.STRING)

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local A = rt.array(rt.STRING)
    local B = rt.tuple()
        : insert(rt.value 'x')
        : insert(rt.value 'y')
        : insert(rt.value 'z')

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, true)
end

do
    local A = rt.tuple()
        : insert(rt.STRING)
        : insert(rt.STRING)
    local B = rt.tuple()
        : insert(rt.value 'x')
        : insert(rt.value 'y')
        : insert(rt.value 'z')

    lt.assertEquals(A >> B, false)
    lt.assertEquals(B >> A, true)
end

do
    local A = rt.array(rt.value('x'))
    local B = rt.tuple(rt.list({ rt.STRING }, 3, false))

    lt.assertEquals(A >> B, true)
    lt.assertEquals(B >> A, false)
end

do
    local a = rt.type 'table'
    local b = rt.table()

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, true)
end

do
    -- 表转换为 union：任一 table 成员可转换即可
    -- union 转换为表：要求所有成员都能转换为该表
    local A = rt.table()
        : addField(rt.field('x', rt.value(1)))
    local B = rt.table()
        : addField(rt.field('x', rt.value(1)))
    local C = rt.table()
        : addField(rt.field('x', rt.value(2)))
    local D = rt.table()
        : addField(rt.field('y', rt.value(2)))

    lt.assertEquals(A >> (B | A), true)
    lt.assertEquals(A >> (B | C), true)
    lt.assertEquals(A >> (B | D), true)
    lt.assertEquals((B | A) >> A, true)
    lt.assertEquals((B | C) >> A, false)
    lt.assertEquals((C | D) >> A, false)
end
