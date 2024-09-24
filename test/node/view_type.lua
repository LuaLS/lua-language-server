
do
    ls.node.TYPE['A'] = nil
    local a = ls.node.type('A')

    assert(a:view() == 'A')
    assert(a.value:view() == 'A')
end

do
    ls.node.TYPE['A'] = nil
    local a = ls.node.type('A')
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x'
        }
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y'
        }

    assert(a:view() == 'A')
    assert(a.value:view() == '{ x: "x", y: "y" }')
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    ls.node.TYPE['C'] = nil
    ls.node.TYPE['D'] = nil
    local a = ls.node.type('A')
    local b = ls.node.type('B')
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x'
        }
    local c = ls.node.type('C')
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y'
        }
    local d = ls.node.type('D')
        : addField {
            key   = ls.node.value 'z',
            value = ls.node.value 'z'
        }

    a:addExtends(b)
    a:addExtends(c)
    a:addExtends(d)

    assert(a:view() == 'A')
    assert(a.value:view() == '{ x: "x", y: "y", z: "z" }')
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    ls.node.TYPE['C'] = nil
    ls.node.TYPE['D'] = nil
    local a = ls.node.type('A')
        : addField {
            key   = ls.node.value 'w',
            value = ls.node.value '1'
        }
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value '2'
        }
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value '3'
        }
    local b = ls.node.type('B')
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x'
        }
    local c = ls.node.type('C')
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y'
        }
    local d = ls.node.type('D')
        : addField {
            key   = ls.node.value 'z',
            value = ls.node.value 'z'
        }

    a:addExtends(b)
    a:addExtends(c)
    a:addExtends(d)

    assert(a:view() == 'A')
    assert(a.value:view() == '{ w: "1", x: "2", y: "3", z: "z" }')
end

do
    ls.node.TYPE['A'] = nil
    local a = ls.node.type('A')
        : addAlias(ls.node.value(1))
        : addAlias(ls.node.value(2))
        : addAlias(ls.node.value(3))

    assert(a:view() == 'A')
    assert(a.value:view() == '1 | 2 | 3')
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    ls.node.TYPE['C'] = nil
    ls.node.TYPE['D'] = nil
    local a = ls.node.type('A')
        : addAlias(ls.node.type 'B')
        : addAlias(ls.node.type 'C')
        : addAlias(ls.node.type 'D')
    ls.node.type('B')
        : addAlias(ls.node.value(1))
        : addAlias(ls.node.value(2))
    ls.node.type('C')
        : addAlias(ls.node.value(2))
        : addAlias(ls.node.value(3))
    ls.node.type('D')
        : addAlias(ls.node.value(3))
        : addAlias(ls.node.value(4))

    assert(a:view() == 'A')
    assert(a.value:view() == 'B | C | D')
end
