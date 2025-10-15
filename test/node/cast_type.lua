local node = test.scope.node

do
    node:reset()

    local a = node.type 'A'
    local b = node.type 'B'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    node:reset()

    local a = node.type 'A'
    local b = node.type 'B'
        : addClass(node.class('B', nil, { a }))

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    node:reset()

    local a = node.type 'A'
    local b = node.type 'B'
        : addClass(node.class('B', nil, { a }))
    local c = node.type 'C'
        : addClass(node.class('C', nil, { b }))
    local d = node.type 'D'
        : addClass(node.class('D', nil, { c }))

    assert(a >> d == false)
    assert(d >> a == true)
end

do
    node:reset()

    local a = node.type 'A'
        : addAlias(node.alias('B', nil, { node.type 'B' }))
    local b = node.type 'B'
        : addAlias(node.alias('A', nil, { node.type 'A' }))

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    node:reset()

    local a = node.type 'A'
        : addClass(node.class('A')
            : addField {
                key   = node.value 'x',
                value = node.value 'x',
            }
            : addField {
                key   = node.value 'y',
                value = node.value 'y',
            }
        )
    local ta = node.table()
        : addField {
            key   = node.value 'x',
            value = node.value 'x',
        }
    local tb = node.table()
        : addField {
            key   = node.value 'y',
            value = node.value 'y',
        }
    local tc = node.table()
        : addField {
            key   = node.value 'z',
            value = node.value 'z',
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
    node:reset()

    local a = node.type 'A'
        : addAlias(node.alias('A', nil, { node.value(1) | node.value(2) | node.value(3) }))
    local b = node.type 'B'
        : addAlias(node.alias('B', nil, { node.value(1) }))
        : addAlias(node.alias('B', nil, { node.value(2) }))
        : addAlias(node.alias('B', nil, { node.value(3) }))

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    node:reset()

    local a = node.type 'A'
        : addAlias(node.alias('A', nil, { node.value(1) | node.value(2) | node.value(3) }))
    local b = node.type 'B'
        : addAlias(node.alias('B', nil, { node.value(1) }))
        : addAlias(node.alias('B', nil, { node.value(2) }))

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    node:reset()

    local a = node.type 'A'
        : addAlias(node.alias('A', nil, { node.table()
            : addField {
                key   = node.value 'x',
                value = node.value 'x',
            }
            : addField {
                key   = node.value 'y',
                value = node.value 'y',
            }
        }))
    local b = node.type 'B'
        : addAlias(node.alias('B', nil, { node.table()
            : addField {
                key   = node.value 'x',
                value = node.value 'x',
            }
            : addField {
                key   = node.value 'y',
                value = node.value 'y',
            }
            : addField {
                key   = node.value 'z',
                value = node.value 'z',
            }
        }))

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    node:reset()

    local a = node.type 'A'
        : addAlias(node.alias('A', nil, { node.table()
            : addField {
                key   = node.value 'x',
                value = node.value 'x',
            }
            : addField {
                key   = node.value 'y',
                value = node.value 'y',
            }
        }))
    local b = node.type 'B'
        : addClass(node.class('B')
            : addField {
                key   = node.value 'x',
                value = node.value 'x',
            }
            : addField {
                key   = node.value 'y',
                value = node.value 'y',
            }
        )

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    node:reset()

    local a = node.type 'A'
        : addAlias(node.alias('A', nil, { node.table()
            : addField {
                key   = node.value 'x',
                value = node.value 'x',
            }
            : addField {
                key   = node.value 'y',
                value = node.value 'y',
            }
        }))
    local b = node.type 'B'
        : addClass(node.class('B', nil, { node.type 'C' }))

    node.type('C'):addClass(node.class 'C'
        : addField {
            key   = node.value 'x',
            value = node.value 'x',
        }
        : addField {
            key   = node.value 'y',
            value = node.value 'y',
        }
    )

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    node:reset()

    local a = node.type 'A'
        : addAlias(node.alias('A', nil, { node.table()
            : addField {
                key   = node.value 'x',
                value = node.value 'x',
            }
            : addField {
                key   = node.value 'y',
                value = node.value 'y',
            }
            : addField {
                key   = node.value 'z',
                value = node.value 'z',
            }
        }))
    local b = node.type 'B'
        : addClass(node.class('B', nil, { node.type 'C' }))

    node.type('C'):addClass(node.class('C')
        : addField {
            key   = node.value 'x',
            value = node.value 'x',
        }
        : addField {
            key   = node.value 'y',
            value = node.value 'y',
        }
    )

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    node:reset()

    local a = node.type 'A'
        : addAlias(node.alias('A', nil, { node.table()
            : addField {
                key   = node.value 'x',
                value = node.value 'x',
            }
            : addField {
                key   = node.value 'y',
                value = node.value 'y',
            }
            : addField {
                key   = node.value 'z',
                value = node.value 'z',
            }
        }))
    local b = node.type 'B'
        : addClass(node.class('B', nil, { node.type 'C' })
            : addField {
                key   = node.value 'z',
                value = node.value 'z',
            }
        )

    node.type 'C'
        : addClass(node.class('C')
            : addField {
                key   = node.value 'x',
                value = node.value 'x',
            }
            : addField {
                key   = node.value 'y',
                value = node.value 'y',
            }
        )

    assert(a >> b == false)
    assert(b >> a == true)
end
