do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    local a = test.scope.node.type 'A'
    local b = test.scope.node.type 'B'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    local a = test.scope.node.type 'A'
    local b = test.scope.node.type 'B'
        : addExtends(a)

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    test.scope.node.TYPE_POOL['D'] = nil
    local a = test.scope.node.type 'A'
    local b = test.scope.node.type 'B'
        : addExtends(a)
    local c = test.scope.node.type 'C'
        : addExtends(b)
    local d = test.scope.node.type 'D'
        : addExtends(c)

    assert(a >> d == false)
    assert(d >> a == true)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    local a = test.scope.node.type 'A'
        : addAlias(test.scope.node.type 'B')
    local b = test.scope.node.type 'B'
        : addAlias(test.scope.node.type 'A')

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    local a = test.scope.node.type 'A'
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x',
        }
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y',
        }
    local ta = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x',
        }
    local tb = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y',
        }
    local tc = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'z',
            value = test.scope.node.value 'z',
        }

    assert(a >> ta == true)
    assert(a >> tb == true)
    assert(a >> tc == false)

    assert(ta >> a == false)
    assert(tb >> a == false)
    assert(tc >> a == false)

    assert(a >> (ta & tb) == true)
    assert((ta & tb) >> a == false)

    assert(a >> (ta & tb & tc) == false)
    assert((ta & tb & tc) >> a == false)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    local a = test.scope.node.type 'A'
        : addAlias(test.scope.node.value(1) | test.scope.node.value(2) | test.scope.node.value(3))
    local b = test.scope.node.type 'B'
        : addAlias(test.scope.node.value(1))
        : addAlias(test.scope.node.value(2))
        : addAlias(test.scope.node.value(3))

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    local a = test.scope.node.type 'A'
        : addAlias(test.scope.node.value(1) | test.scope.node.value(2) | test.scope.node.value(3))
    local b = test.scope.node.type 'B'
        : addAlias(test.scope.node.value(1))
        : addAlias(test.scope.node.value(2))

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    local a = test.scope.node.type 'A'
        : addAlias(test.scope.node.table()
            : addField {
                key   = test.scope.node.value 'x',
                value = test.scope.node.value 'x',
            }
            : addField {
                key   = test.scope.node.value 'y',
                value = test.scope.node.value 'y',
            }
        )
    local b = test.scope.node.type 'B'
        : addAlias(test.scope.node.table()
            : addField {
                key   = test.scope.node.value 'x',
                value = test.scope.node.value 'x',
            }
            : addField {
                key   = test.scope.node.value 'y',
                value = test.scope.node.value 'y',
            }
            : addField {
                key   = test.scope.node.value 'z',
                value = test.scope.node.value 'z',
            }
        )

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    local a = test.scope.node.type 'A'
        : addAlias(test.scope.node.table()
            : addField {
                key   = test.scope.node.value 'x',
                value = test.scope.node.value 'x',
            }
            : addField {
                key   = test.scope.node.value 'y',
                value = test.scope.node.value 'y',
            }
        )
    local b = test.scope.node.type 'B'
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x',
        }
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y',
        }

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    local a = test.scope.node.type 'A'
        : addAlias(test.scope.node.table()
            : addField {
                key   = test.scope.node.value 'x',
                value = test.scope.node.value 'x',
            }
            : addField {
                key   = test.scope.node.value 'y',
                value = test.scope.node.value 'y',
            }
        )
    local b = test.scope.node.type 'B'
        : addExtends(test.scope.node.type 'C'
            : addField {
                key   = test.scope.node.value 'x',
                value = test.scope.node.value 'x',
            }
            : addField {
                key   = test.scope.node.value 'y',
                value = test.scope.node.value 'y',
            }
        )

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    local a = test.scope.node.type 'A'
        : addAlias(test.scope.node.table()
            : addField {
                key   = test.scope.node.value 'x',
                value = test.scope.node.value 'x',
            }
            : addField {
                key   = test.scope.node.value 'y',
                value = test.scope.node.value 'y',
            }
            : addField {
                key   = test.scope.node.value 'z',
                value = test.scope.node.value 'z',
            }
        )
    local b = test.scope.node.type 'B'
        : addExtends(test.scope.node.type 'C'
            : addField {
                key   = test.scope.node.value 'x',
                value = test.scope.node.value 'x',
            }
            : addField {
                key   = test.scope.node.value 'y',
                value = test.scope.node.value 'y',
            }
        )

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    test.scope.node.TYPE_POOL['A'] = nil
    test.scope.node.TYPE_POOL['B'] = nil
    test.scope.node.TYPE_POOL['C'] = nil
    local a = test.scope.node.type 'A'
        : addAlias(test.scope.node.table()
            : addField {
                key   = test.scope.node.value 'x',
                value = test.scope.node.value 'x',
            }
            : addField {
                key   = test.scope.node.value 'y',
                value = test.scope.node.value 'y',
            }
            : addField {
                key   = test.scope.node.value 'z',
                value = test.scope.node.value 'z',
            }
        )
    local b = test.scope.node.type 'B'
        : addExtends(test.scope.node.type 'C'
            : addField {
                key   = test.scope.node.value 'x',
                value = test.scope.node.value 'x',
            }
            : addField {
                key   = test.scope.node.value 'y',
                value = test.scope.node.value 'y',
            }
        )
        : addField {
            key   = test.scope.node.value 'z',
            value = test.scope.node.value 'z',
        }

    assert(a >> b == false)
    assert(b >> a == true)
end
