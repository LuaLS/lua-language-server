local rt = test.scope.rt

do
    rt:reset()

    local a = rt.type 'A'
    local b = rt.type 'B'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    rt:reset()

    local a = rt.NIL
    local b = rt.ANY

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    rt:reset()

    local a = rt.type 'A'
    local b = rt.type 'B'

    rt.class('B', nil, { a })

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    rt:reset()

    local a = rt.type 'A'
    local b = rt.type 'B'
    rt.class('B', nil, { a })
    local c = rt.type 'C'
    rt.class('C', nil, { b })
    local d = rt.type 'D'
    rt.class('D', nil, { c })

    assert(a >> d == false)
    assert(d >> a == true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('B', nil, rt.type 'B')
    local b = rt.type 'B'
    rt.alias('A', nil, rt.type 'A')

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.class('A')
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }

    local ta = rt.table()
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
    local tb = rt.table()
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }
    local tc = rt.table()
        : addField {
            key   = rt.value 'z',
            value = rt.value 'z',
        }

    assert(a >> ta == true)
    assert(a >> tb == true)
    assert(a >> tc == false)

    assert(ta >> a == false)
    assert(tb >> a == false)
    assert(tc >> a == false)

    assert(a >> (ta & tb) == true)
    assert((ta & tb) >> a == true)

    assert(a >> (ta & tb & tc) == false)
    assert((ta & tb & tc) >> a == true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.value(1) | rt.value(2) | rt.value(3))
    local b = rt.type 'B'
    rt.alias('B', nil, rt.value(1))
    rt.alias('B', nil, rt.value(2))
    rt.alias('B', nil, rt.value(3))

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.value(1) | rt.value(2) | rt.value(3))
    local b = rt.type 'B'
    rt.alias('B', nil, rt.value(1))
    rt.alias('B', nil, rt.value(2))

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.table()
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }
    )
    local b = rt.type 'B'
    rt.alias('B', nil, rt.table()
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }
        : addField {
            key   = rt.value 'z',
            value = rt.value 'z',
        }
    )

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.table()
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }
    )
    local b = rt.type 'B'
    rt.class('B')
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }

    assert(a >> b == true)
    assert(b >> a == true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.table()
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }
    )
    local b = rt.type 'B'
    rt.class('B', nil, { rt.type 'C' })

    rt.class 'C'
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }


    assert(a >> b == true)
    assert(b >> a == true)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.table()
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }
        : addField {
            key   = rt.value 'z',
            value = rt.value 'z',
        }
    )
    local b = rt.type 'B'
    rt.class('B', nil, { rt.type 'C' })

    rt.class('C')
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    rt:reset()

    local a = rt.type 'A'
    rt.alias('A', nil, rt.table()
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }
        : addField {
            key   = rt.value 'z',
            value = rt.value 'z',
        }
    )

    local b = rt.type 'B'
    rt.class('B', nil, { rt.type 'C' })
        : addField {
            key   = rt.value 'z',
            value = rt.value 'z',
        }

    rt.class('C')
        : addField {
            key   = rt.value 'x',
            value = rt.value 'x',
        }
        : addField {
            key   = rt.value 'y',
            value = rt.value 'y',
        }

    assert(a >> b == true)
    assert(b >> a == true)
end
