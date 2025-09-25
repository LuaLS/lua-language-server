local node = test.scope.node

do
    local a = node.NIL & node.value(1)

    assert(a:view() == 'never')
end

do
    local a = node.value(1) & node.value(2)

    assert(a:view() == 'never')
end

do
    local a = node.value(1) & node.type('number')

    assert(a:view() == '1')
end

do
    local a = node.type('number') & node.value(1)

    assert(a:view() == '1')
end

do
    local a = node.type('number') & node.value(1)

    assert(a:view() == '1')
end

do
    local a = node.type('number') & node.type('string')

    assert(a:view() == 'never')
end

do
    local a = node.type('number') & node.type('number')

    assert(a:view() == 'number')
end

do
    local a = node.type('number') & node.type('number') & node.type('string')

    assert(a:view() == 'never')
end

do
    local a = node.type('table') & node.G

    assert(a:view() == 'table')
end

do
    node.TYPE_POOL['A'] = nil
    node.TYPE_POOL['B'] = nil
    local a = node.type('A') & node.type('B')

    assert(a:view() == 'A & B')
end

do
    node.TYPE_POOL['A'] = nil
    node.TYPE_POOL['B'] = nil
    node.TYPE_POOL['C'] = nil
    local a = node.type('A') & node.type('B') & node.type('C')

    assert(a:view() == 'A & B & C')
end

do
    local a = node.table()
        : addField {
            key   = node.value 'x',
            value = node.value 'x',
        }
    local b = node.table()
        : addField {
            key   = node.value 'y',
            value = node.value 'y',
        }
    local c = a & b

    assert(c:view() == '{ x: "x" } & { y: "y" }')
end

do
    node.TYPE_POOL['A'] = nil
    node.TYPE_POOL['B'] = nil
    node.TYPE_POOL['C'] = nil
    local a = node.type('A') & node.type('B') & node.type('C') & node.type('A')

    assert(a:view() == 'A & B & C')
end

do
    node.TYPE_POOL['A'] = nil
    node.TYPE_POOL['B'] = nil
    node.TYPE_POOL['C'] = nil
    node.TYPE_POOL['D'] = nil
    local a = node.type('A') & (node.type('B') | node.type('C')) & node.type('D')

    assert(a:view() == 'A & (B | C) & D')
end

do
    node.TYPE_POOL['A'] = nil
    node.TYPE_POOL['B'] = nil
    node.TYPE_POOL['C'] = nil
    local a = node.type('A') & (node.type('B') | node.type('C')) & node.type('A')

    assert(a:view() == 'A & (B | C)')
end
