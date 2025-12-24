local rt = test.scope.rt

do
    local a = rt.type('number')

    assert(a:view() == 'number')
end

do
    local a = rt.type('nil')

    assert(a:view() == 'nil')
end

do
    local a = rt.value(1)

    assert(a:view() == '1')
end

do
    local a = rt.value(1.2345)

    assert(a:view() == '1.2345')
end

do
    local a = rt.value(true)

    assert(a:view() == 'true')
end

do
    local a = rt.value(false)

    assert(a:view() == 'false')
end

do
    local a = rt.value('abc', '"')

    assert(a:view() == '"abc"')
end

do
    local a = rt.value('abc', "'")

    assert(a:view() == "'abc'")
end

do
    local a = rt.value('abc', "[[")

    assert(a:view() == "[[abc]]")
end

do
    local a = rt.type('number') | rt.type('string')

    assert(a:view() == 'number | string')
end

do
    local a = rt.union { rt.value(1), rt.value(2) }

    assert(a:view() == '1 | 2')
end

do
    local a = rt.union { rt.value(1), rt.value(2), rt.NEVER }

    assert(a:view() == '1 | 2')
end

do
    local a = rt.value(1) | rt.value(2)

    assert(a:view() == '1 | 2')
end

do
    local a = rt.value(1) | rt.value(2) | rt.value(3)

    assert(a:view() == '1 | 2 | 3')
end

do
    local a = (rt.value(1) | rt.value(2)) | (rt.value(1) | rt.value(3))

    assert(a:view() == '1 | 2 | 3')
end

do
    local a = rt.NEVER | rt.value(1)

    assert(a:view() == '1')
end

do
    local a = rt.value(1) | rt.NEVER

    assert(a:view() == '1')
end

do
    local a = rt.value(1) | nil

    assert(a:view() == '1')
end

do
    local a = nil | rt.value(1)

    assert(a:view() == '1')
end

do
    local a = rt.VAR_G

    assert(a:view() == '_G')
end

do
    local a = rt.value(1) | rt.VAR_G

    assert(a:view() == '1 | _G')
end

do
    local t = rt.table()
    t:addField(rt.field(rt.value('x'), rt.value(1)))
    t:addField(rt.field(rt.value('y'), rt.value(2)))
    t:addField(rt.field(rt.value('z'), rt.value(3)))
    t:addField(rt.field(rt.value(1),   rt.value('x')))
    t:addField(rt.field(rt.value(2),   rt.value('y')))
    t:addField(rt.field(rt.value(3),   rt.value('z')))

    assert(t:view() == [[{ [1]: "x", [2]: "y", [3]: "z", x: 1, y: 2, z: 3 }]])
end

do
    local t = rt.table {
        'x', 'y', 'z',
        x = 1, y = 2, z = 3,
    }

    assert(t:view() == [[{ [1]: "x", [2]: "y", [3]: "z", x: 1, y: 2, z: 3 }]])
end

do
    local t = rt.tuple({rt.value(1), rt.value(2), rt.value(3)})

    assert(t:view() == '[1, 2, 3]')
end

do
    local t = rt.tuple()
        : insert(rt.value(1))
        : insert(rt.value(2))
        : insert(rt.value(3))

    assert(t:view() == '[1, 2, 3]')
end

do
    local a = rt.array(rt.type('number'))

    assert(a:view() == 'number[]')
end

do
    local func = rt.func()
        : addParamDef('a', rt.value(1))
        : addParamDef('b', rt.value(2))
        : addReturnDef('suc', rt.value(true))
        : addReturnDef(nil, rt.value(false))

    assert(func:view() == 'fun(a: 1, b: 2):((suc: true), false)')
end
