local rt = test.scope.rt

do
    rt:reset()

    -- 传入的收窄值已是 never 时，按字段收窄不做任何收窄：
    -- 继续判断会把基变量算成 never（`x.type == 'y'` 一族的反推会把类/实例踩成这样）
    local fieldType = rt.class 'F'
    local classA = rt.class('A'):addField(rt.field(rt.value 'type', fieldType))
    local narrowed, otherSide = classA:narrowByField(rt.value 'type', rt.NEVER)

    lt.assertEquals(narrowed, classA)
    lt.assertEquals(otherSide:view(), 'never')
end

do
    rt.TYPE_POOL['A'] = nil
    rt.TYPE_POOL['B'] = nil
    rt.TYPE_POOL['C'] = nil

    local u = rt.type 'A' | rt.type 'B' | rt.type 'C'
    local r = u:narrow(rt.type 'B')

    lt.assertEquals(r:view(), 'B')
end

do
    rt:reset()

    rt.type 'A'
    rt.class('A', nil, { rt.type 'B' })

    local u = rt.type 'A' | rt.type 'B' | rt.type 'C'
    local r = u:narrow(rt.type 'B')

    lt.assertEquals(r:view(), 'A | B')
end

do
    local u = rt.value(1) | rt.value(true) | rt.value('x')
    local r1 = u:narrow(rt.NUMBER)
    local r2 = u:narrow(rt.STRING)
    local r3 = u:narrow(rt.BOOLEAN)

    lt.assertEquals(r1:view(), '1')
    lt.assertEquals(r2:view(), '"x"')
    lt.assertEquals(r3:view(), 'true')
end

do
    local t = rt.table {
        x = 1,
    } | rt.table {
        y = 2,
    } | rt.table {
        z = 3,
    }

    local r1 = t:narrow(rt.table {
        x = 1,
    })
    local r2 = t:narrow(rt.table {
        y = 2,
    })
    local r3 = t:narrow(rt.table {
        z = 3,
    })
    local r4 = t:narrowByField('x', 1)
    local r5 = t:narrowByField('y', 2)
    local r6 = t:narrowByField('z', 3)

    lt.assertEquals(r1:view(), '{ x: 1 }')
    lt.assertEquals(r2:view(), '{ y: 2 }')
    lt.assertEquals(r3:view(), '{ z: 3 }')
    lt.assertEquals(r4:view(), '{ x: 1 }')
    lt.assertEquals(r5:view(), '{ y: 2 }')
    lt.assertEquals(r6:view(), '{ z: 3 }')
end

do
    local t = rt.func()
        : addParamDef('x', rt.NUMBER)
    | rt.func()
        : addParamDef('x', rt.STRING)

    local r = t:narrow(rt.func()
        : addParamDef('x', rt.NUMBER)
    )

    lt.assertEquals(r:view(), 'fun(x: number)')
end

do
    rt:reset()

    rt.alias('A', nil, rt.value(1) | rt.value(2))

    local b = rt.type('A').truthy

    lt.assertEquals(b:view(), 'A')
end

do
    rt:reset()

    rt.alias('A', nil, rt.value(1) | rt.value(2) | rt.NIL)

    local b = rt.type('A').truthy

    lt.assertEquals(b:view(), '1 | 2')
end

do
    rt:reset()

    local a = rt.ternary(
        rt.value(true),
        rt.value(1),
        rt.value(2)
    )
    lt.assertEquals(a:view(), '1')

    local b = rt.ternary(
        rt.value(false),
        rt.value(1),
        rt.value(2)
    )
    lt.assertEquals(b:view(), '2')

    local c = rt.ternary(
        rt.BOOLEAN,
        rt.value(1),
        rt.value(2)
    )
    lt.assertEquals(c:view(), '1 | 2')
end

do
    rt:reset()

    local a = rt.ANY:narrowEqual(rt.value(1))

    lt.assertEquals(a:view(), '1')
end

do
    rt:reset()

    -- 判等只在单值类型上成立：多值类型（any / unknown / 同类型变量 / 类）比较时
    -- 既不能排除取值也不能断定同值，两侧都保持原样
    local any1, any2 = rt.ANY:narrowEqual(rt.ANY)
    lt.assertEquals(any1:view(), 'any')
    lt.assertEquals(any2:view(), 'any')

    local s1, s2 = rt.type('string'):narrowEqual(rt.ANY)
    lt.assertEquals(s1:view(), 'string')
    lt.assertEquals(s2:view(), 'string')

    local t1, t2 = rt.type('string'):narrowEqual(rt.type('string'))
    lt.assertEquals(t1:view(), 'string')
    lt.assertEquals(t2:view(), 'string')

    local u1, u2 = rt.type('string'):narrowEqual(rt.UNKNOWN)
    lt.assertEquals(u1:view(), 'string')
    lt.assertEquals(u2:view(), 'string')

    local v1, v2 = rt.value(1):narrowEqual(rt.type('number'))
    lt.assertEquals(v1:view(), '1')
    lt.assertEquals(v2:view(), '1')
end

do
    rt:reset()

    -- 单值比较仍按判等收窄
    local l1, l2 = rt.value(1):narrowEqual(rt.value(1))
    lt.assertEquals(l1:view(), '1')
    lt.assertEquals(l2:view(), 'never')
end

do
    rt:reset()

    -- 联合体与多值类型比较不收窄；与单值比较仍按成员拆分
    local u = rt.value(1) | rt.value('x')

    local u1, u2 = u:narrowEqual(rt.ANY)
    lt.assertEquals(u1:view(), '1 | "x"')
    lt.assertEquals(u2:view(), '1 | "x"')

    local m1, m2 = u:narrowEqual(rt.value(1))
    lt.assertEquals(m1:view(), '1')
    lt.assertEquals(m2:view(), '"x"')
end

do
    rt:reset()

    -- 字段声明类型比比较值宽（`string` 对 `'x'`）时，字段既可能相等也可能不等：
    -- 两侧都保持原样，不再把基值算成 never
    local wide = rt.table { type = rt.STRING }
    local w1, w2 = wide:narrowByField(rt.value 'type', rt.value 'x')
    lt.assertEquals(w1:view(), '{ type: string }')
    lt.assertEquals(w2:view(), '{ type: string }')

    -- 字段类型就是该单值时，另一侧仍然不可能
    local exact = rt.table { type = rt.value 'x' }
    local e1, e2 = exact:narrowByField(rt.value 'type', rt.value 'x')
    lt.assertEquals(e1:view(), '{ type: "x" }')
    lt.assertEquals(e2:view(), 'never')

    -- 字段声明类型与比较值不相交时，相等一侧不可能
    local distinct = rt.table { type = rt.value(1) }
    local d1, d2 = distinct:narrowByField(rt.value 'type', rt.value 'x')
    lt.assertEquals(d1:view(), 'never')
    lt.assertEquals(d2:view(), '{ type: 1 }')

    -- 字段声明是 any（值不可知）时，两侧同样都保持原样
    local unknownField = rt.table { type = rt.ANY }
    local k1, k2 = unknownField:narrowByField(rt.value 'type', rt.value 'x')
    lt.assertEquals(k1:view(), '{ type: any }')
    lt.assertEquals(k2:view(), '{ type: any }')
end

do
    rt:reset()

    -- 联合体基值：字段能容纳该字面量的成员进入 narrowed；另一侧（字段 ≠ 值）保留
    -- ①「没有该字段」的成员，以及 ②「字段是多值（`string` / `any` 一类）因而还能取到
    -- 别的取值」的成员 —— 不能按 narrowed 的补集整块排除（与 F18 同一条语义）
    local xField = rt.table { type = rt.value 'x' }
    local yField = rt.table { type = rt.value 'y' }
    local u1, u2 = (xField | yField):narrowByField(rt.value 'type', rt.value 'x')
    lt.assertEquals(u1:view(), '{ type: "x" }')
    lt.assertEquals(u2:view(), '{ type: "y" }')

    local wideField = rt.table { type = rt.STRING }
    local noField   = rt.table { cate = rt.STRING }
    local v1, v2 = (wideField | noField):narrowByField(rt.value 'type', rt.value 'x')
    lt.assertEquals(v1:view(), '{ type: string }')
    lt.assertEquals(v2:view(), '{ type: string } | { cate: string }')

    -- 成员字段为 any 时同样进入 narrowed（判定“可能相等”），另一侧也保留它
    local anyField = rt.table { type = rt.ANY }
    local noType   = rt.table { cate = rt.value 'x' }
    local q1, q2 = (anyField | noType):narrowByField(rt.value 'type', rt.value 'x')
    lt.assertEquals(q1:view(), '{ type: any }')
    lt.assertEquals(q2:view(), '{ type: any } | { cate: "x" }')
end

do
    rt:reset()

    -- 多值类型与单值比较：相等一侧是那个单值本身（交集），不是 never
    -- （`never` 会作为读值泄漏到后面的流程里）
    local s1, s2 = rt.type('string'):narrowEqual(rt.value 'doc.field')
    lt.assertEquals(s1:view(), '"doc.field"')
    lt.assertEquals(s2:view(), 'string')

    -- 不相容时相等一侧才是不可能
    local n1, n2 = rt.type('number'):narrowEqual(rt.value 'doc.field')
    lt.assertEquals(n1:view(), 'never')
    lt.assertEquals(n2:view(), 'number')

    -- 联合体里的多值成员：相等侧按单值比较收窄（不留整个 `string`），
    -- 不等侧保留该成员（`string` 去掉 `'doc.field'` 后还有别的取值，不能整块排除）
    local u = rt.value('generic') | rt.type('string')
    local u1, u2 = u:narrowEqual(rt.value 'doc.field')
    lt.assertEquals(u1:view(), '"doc.field"')
    lt.assertEquals(u2:view(), '"generic" | string')
end
