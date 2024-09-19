do
    local a = ls.node.NIL & ls.node.value(1)

    assert(a:view() == 'never')
end

do
    local a = ls.node.value(1) & ls.node.value(2)

    assert(a:view() == 'never')
end

do
    local a = ls.node.value(1) & ls.node.type('number')

    assert(a:view() == '1')
end

do
    local a = ls.node.type('number') & ls.node.value(1)

    assert(a:view() == '1')
end

do
    local a = ls.node.type('number') & ls.node.value(1)

    assert(a:view() == '1')
end

do
    local a = ls.node.type('number') & ls.node.type('string')

    assert(a:view() == 'never')
end

do
    local a = ls.node.type('number') & ls.node.type('number')

    assert(a:view() == 'number')
end

do
    local a = ls.node.type('number') & ls.node.type('number') & ls.node.type('string')

    assert(a:view() == 'never')
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    local a = ls.node.type('A') & ls.node.type('B')

    assert(a:view() == 'A & B')
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    ls.node.TYPE['C'] = nil
    local a = ls.node.type('A') & ls.node.type('B') & ls.node.type('C')

    assert(a:view() == 'A & B & C')
end

do
    local a = ls.node.table()
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x',
        }
    local b = ls.node.table()
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y',
        }
    local c = a & b

    assert(c:view() == '{ x: "x" } & { y: "y" }')
end
