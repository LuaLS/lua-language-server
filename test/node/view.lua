do
    local a = test.scope.node.type('number')

    assert(a:view() == 'number')
end

do
    local a = test.scope.node.type('nil')

    assert(a:view() == 'nil')
end

do
    local a = test.scope.node.value(1)

    assert(a:view() == '1')
end

do
    local a = test.scope.node.value(1.2345)

    assert(a:view() == '1.2345')
end

do
    local a = test.scope.node.value(true)

    assert(a:view() == 'true')
end

do
    local a = test.scope.node.value(false)

    assert(a:view() == 'false')
end

do
    local a = test.scope.node.value('abc', '"')

    assert(a:view() == '"abc"')
end

do
    local a = test.scope.node.value('abc', "'")

    assert(a:view() == "'abc'")
end

do
    local a = test.scope.node.value('abc', "[[")

    assert(a:view() == "[[abc]]")
end

do
    local a = test.scope.node.type('number') | test.scope.node.type('string')

    assert(a:view() == 'number | string')
end

do
    local a = test.scope.node.union { test.scope.node.value(1), test.scope.node.value(2) }

    assert(a:view() == '1 | 2')
end

do
    local a = test.scope.node.value(1) | test.scope.node.value(2)

    assert(a:view() == '1 | 2')
end

do
    local a = test.scope.node.value(1) | test.scope.node.value(2) | test.scope.node.value(3)

    assert(a:view() == '1 | 2 | 3')
end

do
    local a = (test.scope.node.value(1) | test.scope.node.value(2)) | (test.scope.node.value(1) | test.scope.node.value(3))

    assert(a:view() == '1 | 2 | 3')
end

do
    local a = test.scope.node.NEVER | test.scope.node.value(1)

    assert(a:view() == '1')
end

do
    local a = test.scope.node.value(1) | test.scope.node.NEVER

    assert(a:view() == '1')
end

do
    local a = test.scope.node.value(1) | nil

    assert(a:view() == '1')
end

do
    local a = nil | test.scope.node.value(1)

    assert(a:view() == '1')
end

do
    local t = test.scope.node.table()
    t:addField({ key = test.scope.node.value('x'), value = test.scope.node.value(1)})
    t:addField({ key = test.scope.node.value('y'), value = test.scope.node.value(2)})
    t:addField({ key = test.scope.node.value('z'), value = test.scope.node.value(3)})
    t:addField({ key = test.scope.node.value(1),   value = test.scope.node.value('x')})
    t:addField({ key = test.scope.node.value(2),   value = test.scope.node.value('y')})
    t:addField({ key = test.scope.node.value(3),   value = test.scope.node.value('z')})

    assert(t:view() == [[{ [1]: "x", [2]: "y", [3]: "z", x: 1, y: 2, z: 3 }]])
end

do
    local t = test.scope.node.table {
        'x', 'y', 'z',
        x = 1, y = 2, z = 3,
    }

    assert(t:view() == [[{ [1]: "x", [2]: "y", [3]: "z", x: 1, y: 2, z: 3 }]])
end

do
    local t = test.scope.node.tuple({test.scope.node.value(1), test.scope.node.value(2), test.scope.node.value(3)})

    assert(t:view() == '[1, 2, 3]')
end

do
    local t = test.scope.node.tuple()
        : insert(test.scope.node.value(1))
        : insert(test.scope.node.value(2))
        : insert(test.scope.node.value(3))

    assert(t:view() == '[1, 2, 3]')
end

do
    local a = test.scope.node.array(test.scope.node.type('number'))

    assert(a:view() == 'number[]')
end

do
    local func = test.scope.node.func()
        : addParamDef('a', test.scope.node.value(1))
        : addParamDef('b', test.scope.node.value(2))
        : addReturnDef('suc', test.scope.node.value(true))
        : addReturnDef(nil, test.scope.node.value(false))

    assert(func:view() == 'fun(a: 1, b: 2):((suc: true), false)')
end
