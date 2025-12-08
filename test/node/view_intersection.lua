local rt = test.scope.rt

do
    local a = rt.NIL & rt.value(1)

    assert(a:view() == '1')
end

do
    local a = rt.value(1) & rt.value(2)

    assert(a:view() == 'never')
end

do
    local a = rt.value(1) & rt.type('number')

    assert(a:view() == '1')
end

do
    local a = rt.type('number') & rt.value(1)

    assert(a:view() == '1')
end

do
    local a = rt.type('number') & rt.value(1)

    assert(a:view() == '1')
end

do
    local a = rt.type('number') & rt.type('string')

    assert(a:view() == 'never')
end

do
    local a = rt.type('number') & rt.type('number')

    assert(a:view() == 'number')
end

do
    local a = rt.type('number') & rt.type('number') & rt.type('string')

    assert(a:view() == 'never')
end

do
    local a = rt.type('table') & rt.VAR_G

    assert(a:view() == 'table & _G')
end

do
    rt.TYPE_POOL['A'] = nil
    rt.TYPE_POOL['B'] = nil
    local a = rt.type('A') & rt.type('B')

    assert(a:view() == 'A & B')
end

do
    rt.TYPE_POOL['A'] = nil
    rt.TYPE_POOL['B'] = nil
    rt.TYPE_POOL['C'] = nil
    local a = rt.type('A') & rt.type('B') & rt.type('C')

    assert(a:view() == 'A & B & C')
end

do
    local a = rt.table()
        : addField(rt.field(rt.value 'x', rt.value 'x'))
    local b = rt.table()
        : addField(rt.field(rt.value 'y', rt.value 'y'))
    local c = a & b

    assert(c:view() == '{ x: "x" } & { y: "y" }')
end

do
    rt.TYPE_POOL['A'] = nil
    rt.TYPE_POOL['B'] = nil
    rt.TYPE_POOL['C'] = nil
    local a = rt.type('A') & rt.type('B') & rt.type('C') & rt.type('A')

    assert(a:view() == 'A & B & C')
end

do
    rt.TYPE_POOL['A'] = nil
    rt.TYPE_POOL['B'] = nil
    rt.TYPE_POOL['C'] = nil
    rt.TYPE_POOL['D'] = nil
    local a = rt.type('A') & (rt.type('B') | rt.type('C')) & rt.type('D')

    assert(a:view() == '(A & B & D) | (A & C & D)')
end

do
    rt.TYPE_POOL['A'] = nil
    rt.TYPE_POOL['B'] = nil
    rt.TYPE_POOL['C'] = nil
    local a = rt.type('A') & (rt.type('B') | rt.type('C')) & rt.type('A')

    assert(a:view() == '(A & B) | (A & C)')
end

do
    local a = rt.table() & rt.NIL

    assert(a:view() == '{}')
end

do
    local a = rt.table() & rt.func()

    assert(a:view() == '{} & fun()')
end
