local node = test.scope.node

do
    local a = node.type('number')

    assert(a:view() == 'number')
end

do
    local a = node.type('nil')

    assert(a:view() == 'nil')
end

do
    local a = node.value(1)

    assert(a:view() == '1')
end

do
    local a = node.value(1.2345)

    assert(a:view() == '1.2345')
end

do
    local a = node.value(true)

    assert(a:view() == 'true')
end

do
    local a = node.value(false)

    assert(a:view() == 'false')
end

do
    local a = node.value('abc', '"')

    assert(a:view() == '"abc"')
end

do
    local a = node.value('abc', "'")

    assert(a:view() == "'abc'")
end

do
    local a = node.value('abc', "[[")

    assert(a:view() == "[[abc]]")
end

do
    local a = node.type('number') | node.type('string')

    assert(a:view() == 'number | string')
end

do
    local a = node.union { node.value(1), node.value(2) }

    assert(a:view() == '1 | 2')
end

do
    local a = node.value(1) | node.value(2)

    assert(a:view() == '1 | 2')
end

do
    local a = node.value(1) | node.value(2) | node.value(3)

    assert(a:view() == '1 | 2 | 3')
end

do
    local a = (node.value(1) | node.value(2)) | (node.value(1) | node.value(3))

    assert(a:view() == '1 | 2 | 3')
end

do
    local a = node.NEVER | node.value(1)

    assert(a:view() == '1')
end

do
    local a = node.value(1) | node.NEVER

    assert(a:view() == '1')
end

do
    local a = node.value(1) | nil

    assert(a:view() == '1')
end

do
    local a = nil | node.value(1)

    assert(a:view() == '1')
end

do
    local a = node.value(1) | node.VAR_G

    assert(a:view() == '1')
end

do
    local t = node.table()
    t:addField({ key = node.value('x'), value = node.value(1)})
    t:addField({ key = node.value('y'), value = node.value(2)})
    t:addField({ key = node.value('z'), value = node.value(3)})
    t:addField({ key = node.value(1),   value = node.value('x')})
    t:addField({ key = node.value(2),   value = node.value('y')})
    t:addField({ key = node.value(3),   value = node.value('z')})

    assert(t:view() == [[{ [1]: "x", [2]: "y", [3]: "z", x: 1, y: 2, z: 3 }]])
end

do
    local t = node.table {
        'x', 'y', 'z',
        x = 1, y = 2, z = 3,
    }

    assert(t:view() == [[{ [1]: "x", [2]: "y", [3]: "z", x: 1, y: 2, z: 3 }]])
end

do
    local t = node.tuple({node.value(1), node.value(2), node.value(3)})

    assert(t:view() == '[1, 2, 3]')
end

do
    local t = node.tuple()
        : insert(node.value(1))
        : insert(node.value(2))
        : insert(node.value(3))

    assert(t:view() == '[1, 2, 3]')
end

do
    local a = node.array(node.type('number'))

    assert(a:view() == 'number[]')
end

do
    local func = node.func()
        : addParamDef('a', node.value(1))
        : addParamDef('b', node.value(2))
        : addReturnDef('suc', node.value(true))
        : addReturnDef(nil, node.value(false))

    assert(func:view() == 'fun(a: 1, b: 2):((suc: true), false)')
end
