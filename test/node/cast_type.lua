do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    local a = ls.node.type 'A'
    local b = ls.node.type 'B'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    local a = ls.node.type 'A'
    local b = ls.node.type 'B'
        : addExtends(a)

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    ls.node.TYPE['C'] = nil
    ls.node.TYPE['D'] = nil
    local a = ls.node.type 'A'
    local b = ls.node.type 'B'
        : addExtends(a)
    local c = ls.node.type 'C'
        : addExtends(b)
    local d = ls.node.type 'D'
        : addExtends(c)

    assert(a >> d == false)
    assert(d >> a == true)
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    local a = ls.node.type 'A'
        : addAlias(ls.node.type 'B')
    local b = ls.node.type 'B'
        : addAlias(ls.node.type 'A')

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    ls.node.TYPE['A'] = nil
    local a = ls.node.type 'A'
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x',
        }
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y',
        }
    local ta = ls.node.table()
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x',
        }
    local tb = ls.node.table()
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y',
        }
    local tc = ls.node.table()
        : addField {
            key   = ls.node.value 'z',
            value = ls.node.value 'z',
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
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    local a = ls.node.type 'A'
        : addAlias(ls.node.value(1) | ls.node.value(2) | ls.node.value(3))
    local b = ls.node.type 'B'
        : addAlias(ls.node.value(1))
        : addAlias(ls.node.value(2))
        : addAlias(ls.node.value(3))

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    local a = ls.node.type 'A'
        : addAlias(ls.node.value(1) | ls.node.value(2) | ls.node.value(3))
    local b = ls.node.type 'B'
        : addAlias(ls.node.value(1))
        : addAlias(ls.node.value(2))

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    local a = ls.node.type 'A'
        : addAlias(ls.node.table()
            : addField {
                key   = ls.node.value 'x',
                value = ls.node.value 'x',
            }
            : addField {
                key   = ls.node.value 'y',
                value = ls.node.value 'y',
            }
        )
    local b = ls.node.type 'B'
        : addAlias(ls.node.table()
            : addField {
                key   = ls.node.value 'x',
                value = ls.node.value 'x',
            }
            : addField {
                key   = ls.node.value 'y',
                value = ls.node.value 'y',
            }
            : addField {
                key   = ls.node.value 'z',
                value = ls.node.value 'z',
            }
        )

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    local a = ls.node.type 'A'
        : addAlias(ls.node.table()
            : addField {
                key   = ls.node.value 'x',
                value = ls.node.value 'x',
            }
            : addField {
                key   = ls.node.value 'y',
                value = ls.node.value 'y',
            }
        )
    local b = ls.node.type 'B'
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x',
        }
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y',
        }

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    ls.node.TYPE['C'] = nil
    local a = ls.node.type 'A'
        : addAlias(ls.node.table()
            : addField {
                key   = ls.node.value 'x',
                value = ls.node.value 'x',
            }
            : addField {
                key   = ls.node.value 'y',
                value = ls.node.value 'y',
            }
        )
    local b = ls.node.type 'B'
        : addExtends(ls.node.type 'C'
            : addField {
                key   = ls.node.value 'x',
                value = ls.node.value 'x',
            }
            : addField {
                key   = ls.node.value 'y',
                value = ls.node.value 'y',
            }
        )

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    ls.node.TYPE['C'] = nil
    local a = ls.node.type 'A'
        : addAlias(ls.node.table()
            : addField {
                key   = ls.node.value 'x',
                value = ls.node.value 'x',
            }
            : addField {
                key   = ls.node.value 'y',
                value = ls.node.value 'y',
            }
            : addField {
                key   = ls.node.value 'z',
                value = ls.node.value 'z',
            }
        )
    local b = ls.node.type 'B'
        : addExtends(ls.node.type 'C'
            : addField {
                key   = ls.node.value 'x',
                value = ls.node.value 'x',
            }
            : addField {
                key   = ls.node.value 'y',
                value = ls.node.value 'y',
            }
        )

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    ls.node.TYPE['A'] = nil
    ls.node.TYPE['B'] = nil
    ls.node.TYPE['C'] = nil
    local a = ls.node.type 'A'
        : addAlias(ls.node.table()
            : addField {
                key   = ls.node.value 'x',
                value = ls.node.value 'x',
            }
            : addField {
                key   = ls.node.value 'y',
                value = ls.node.value 'y',
            }
            : addField {
                key   = ls.node.value 'z',
                value = ls.node.value 'z',
            }
        )
    local b = ls.node.type 'B'
        : addExtends(ls.node.type 'C'
            : addField {
                key   = ls.node.value 'x',
                value = ls.node.value 'x',
            }
            : addField {
                key   = ls.node.value 'y',
                value = ls.node.value 'y',
            }
        )
        : addField {
            key   = ls.node.value 'z',
            value = ls.node.value 'z',
        }

    assert(a >> b == false)
    assert(b >> a == true)
end
