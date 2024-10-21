
do
    test.scope.node.TYPE_POOL['A'] = nil
    local a = test.scope.node.type('A')

    assert(a:view() == 'A')
    assert(a.value:view() == 'A')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    local a = test.scope.node.type('A')
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x'
        }
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y'
        }

    assert(a:view() == 'A')
    assert(a.value:view() == '{ x: "x", y: "y" }')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    test.scope.node.TYPE_POOL['D'] = nil
    local a = test.scope.node.type('A')
    local b = test.scope.node.type('B')
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x'
        }
    local c = test.scope.node.type('C')
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y'
        }
    local d = test.scope.node.type('D')
        : addField {
            key   = test.scope.node.value 'z',
            value = test.scope.node.value 'z'
        }

    a:addExtends(b)
    a:addExtends(c)
    a:addExtends(d)

    assert(a:view() == 'A')
    assert(a.value:view() == '{ x: "x", y: "y", z: "z" }')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    test.scope.node.TYPE_POOL['D'] = nil
    local a = test.scope.node.type('A')
        : addField {
            key   = test.scope.node.value 'w',
            value = test.scope.node.value '1'
        }
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value '2'
        }
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value '3'
        }
    local b = test.scope.node.type('B')
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x'
        }
    local c = test.scope.node.type('C')
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y'
        }
    local d = test.scope.node.type('D')
        : addField {
            key   = test.scope.node.value 'z',
            value = test.scope.node.value 'z'
        }

    a:addExtends(b)
    a:addExtends(c)
    a:addExtends(d)

    assert(a:view() == 'A')
    assert(a.value:view() == '{ w: "1", x: "2", y: "3", z: "z" }')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    local a = test.scope.node.type('A')
        : addAlias(test.scope.node.value(1))
        : addAlias(test.scope.node.value(2))
        : addAlias(test.scope.node.value(3))

    assert(a:view() == 'A')
    assert(a.value:view() == '1 | 2 | 3')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    test.scope.node.TYPE_POOL['D'] = nil
    local a = test.scope.node.type('A')
        : addAlias(test.scope.node.type 'B')
        : addAlias(test.scope.node.type 'C')
        : addAlias(test.scope.node.type 'D')
    test.scope.node.type('B')
        : addAlias(test.scope.node.value(1))
        : addAlias(test.scope.node.value(2))
    test.scope.node.type('C')
        : addAlias(test.scope.node.value(2))
        : addAlias(test.scope.node.value(3))
    test.scope.node.type('D')
        : addAlias(test.scope.node.value(3))
        : addAlias(test.scope.node.value(4))

    assert(a:view() == 'A')
    assert(a.value:view() == 'B | C | D')
end
