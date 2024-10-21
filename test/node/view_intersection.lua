do
    local a = test.scope.node.NIL & test.scope.node.value(1)

    assert(a:view() == 'never')
end

do
    local a = test.scope.node.value(1) & test.scope.node.value(2)

    assert(a:view() == 'never')
end

do
    local a = test.scope.node.value(1) & test.scope.node.type('number')

    assert(a:view() == '1')
end

do
    local a = test.scope.node.type('number') & test.scope.node.value(1)

    assert(a:view() == '1')
end

do
    local a = test.scope.node.type('number') & test.scope.node.value(1)

    assert(a:view() == '1')
end

do
    local a = test.scope.node.type('number') & test.scope.node.type('string')

    assert(a:view() == 'never')
end

do
    local a = test.scope.node.type('number') & test.scope.node.type('number')

    assert(a:view() == 'number')
end

do
    local a = test.scope.node.type('number') & test.scope.node.type('number') & test.scope.node.type('string')

    assert(a:view() == 'never')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    local a = test.scope.node.type('A') & test.scope.node.type('B')

    assert(a:view() == 'A & B')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    local a = test.scope.node.type('A') & test.scope.node.type('B') & test.scope.node.type('C')

    assert(a:view() == 'A & B & C')
end

do
    local a = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x',
        }
    local b = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y',
        }
    local c = a & b

    assert(c:view() == '{ x: "x" } & { y: "y" }')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    local a = test.scope.node.type('A') & test.scope.node.type('B') & test.scope.node.type('C') & test.scope.node.type('A')

    assert(a:view() == 'A & B & C')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    test.scope.node.TYPE_POOL['D'] = nil
    local a = test.scope.node.type('A') & (test.scope.node.type('B') | test.scope.node.type('C')) & test.scope.node.type('D')

    assert(a:view() == 'A & (B | C) & D')
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    local a = test.scope.node.type('A') & (test.scope.node.type('B') | test.scope.node.type('C')) & test.scope.node.type('A')

    assert(a:view() == 'A & (B | C)')
end
