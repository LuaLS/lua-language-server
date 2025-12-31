local rt = test.scope.rt

local Any     = rt.ANY
local Nil     = rt.NIL
local Never   = rt.NEVER
local Unknown = rt.UNKNOWN

do
    lt.assertEquals(Any >> Any, true)
    lt.assertEquals(Any >> Nil, true)
    lt.assertEquals(Any >> Never, false)
    lt.assertEquals(Any >> Unknown, true)
end

do
    lt.assertEquals(Nil >> Any, true)
    lt.assertEquals(Nil >> Nil, true)
    lt.assertEquals(Nil >> Never, false)
    lt.assertEquals(Nil >> Unknown, false)
end

do
    lt.assertEquals(Never >> Any, true)
    lt.assertEquals(Never >> Nil, true)
    lt.assertEquals(Never >> Never, true)
    lt.assertEquals(Never >> Unknown, true)
end

do
    lt.assertEquals(Unknown >> Any, true)
    lt.assertEquals(Unknown >> Nil, false)
    lt.assertEquals(Unknown >> Never, false)
    lt.assertEquals(Unknown >> Unknown, true)
end

do
    lt.assertEquals(rt.value(1) >> Any, true)
    lt.assertEquals(rt.value(1) >> Nil, false)
    lt.assertEquals(rt.value(1) >> Never, false)
    lt.assertEquals(rt.value(1) >> Unknown, true)

    lt.assertEquals(Any     >> rt.value(1), true)
    lt.assertEquals(Nil     >> rt.value(1), false)
    lt.assertEquals(Never   >> rt.value(1), true)
    lt.assertEquals(Unknown >> rt.value(1), true)
end

do
    lt.assertEquals(rt.value(1) >> rt.value(1), true)
    lt.assertEquals(rt.value(1) >> rt.value(2), false)
    lt.assertEquals(rt.value(1) >> rt.value(1.0), true)
    lt.assertEquals(rt.value(1) >> rt.type 'integer', true)

    lt.assertEquals(rt.type 'integer' >> rt.value(1), false)
end

do
    lt.assertEquals(rt.value(1.0) >> rt.value(1), true)
    lt.assertEquals(rt.value(1.0) >> rt.value(1.0), true)
    lt.assertEquals(rt.value(1.0) >> rt.value(2), false)
    lt.assertEquals(rt.value(1.0) >> rt.type 'integer', true)

    lt.assertEquals(rt.type 'integer' >> rt.value(1.0), false)
end

do
    lt.assertEquals(rt.value(1.1) >> rt.type 'integer', false)
    lt.assertEquals(rt.value(1.1) >> rt.type 'number', true)

    lt.assertEquals(rt.type 'number' >> rt.value(1.1), false)
end

do
    lt.assertEquals(rt.value(true) >> rt.value(true), true)
    lt.assertEquals(rt.value(true) >> rt.value(false), false)
    lt.assertEquals(rt.value(true) >> rt.type 'boolean', true)

    lt.assertEquals(rt.type 'boolean' >> rt.value(true), false)
end

do
    lt.assertEquals(rt.value(false) >> rt.value(false), true)
    lt.assertEquals(rt.value(false) >> rt.value(true), false)
    lt.assertEquals(rt.value(false) >> rt.type 'boolean', true)

    lt.assertEquals(rt.type 'boolean' >> rt.value(false), false)
end

do
    lt.assertEquals(rt.value('abc', '"') >> rt.value('abc', '"'), true)
    lt.assertEquals(rt.value('abc', '"') >> rt.value('abc', "'"), true)
    lt.assertEquals(rt.value('abc', '"') >> rt.type 'string', true)

    lt.assertEquals(rt.type 'string' >> rt.value('abc', '"'), false)
end

do
    local a = rt.type 'number'
    local b = rt.type 'string'

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end

do
    local a = rt.type 'number'
    local b = rt.type 'number' | rt.type 'string'

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, false)
end

do
    local a = rt.type 'number' | rt.type 'string'
    local b = rt.type 'number' | rt.type 'boolean'

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, false)
end

do
    local a = rt.type 'number' | rt.type 'string'
    local b = rt.type 'number' | rt.type 'boolean' | rt.type 'string'

    lt.assertEquals(a >> b, true)
    lt.assertEquals(b >> a, false)
end

do
    local a = rt.type 'number'
    local b = rt.type 'integer'

    lt.assertEquals(a >> b, false)
    lt.assertEquals(b >> a, true)
end

do
    rt:reset()

    local a = rt.type 'A'
    local b = rt.type 'B'
    local c = rt.type 'C'

    rt.class('A', nil, { b })
    rt.class('B', nil, { c })
    rt.class('C', nil, { a })

    lt.assertEquals(a >> b, true)
    lt.assertEquals(a >> c, true)
    lt.assertEquals(b >> c, true)
    lt.assertEquals(b >> a, true)
    lt.assertEquals(c >> a, true)
    lt.assertEquals(c >> b, true)
end

do
    local a = rt.value(1)
    local b = rt.value(2)
    local c = rt.type 'number'

    lt.assertEquals(a >> b, false)
    lt.assertEquals(a >> c, true)
    lt.assertEquals(b >> c, true)
    lt.assertEquals(c >> a, false)
    lt.assertEquals(c >> b, false)

    lt.assertEquals((a | b) >> c, true)
    lt.assertEquals((b | c) >> a, false)
    lt.assertEquals((c | a) >> b, false)
    lt.assertEquals(c >> (a | b), false)
    lt.assertEquals(a >> (b | c), true)
    lt.assertEquals(b >> (c | a), true)
end

do
    local a = rt.type 'number'
            & (rt.value(1) | rt.value(2))

    lt.assertEquals(a:view(), '1 | 2')
end

do
    local a = (rt.value(1) | rt.value(2))
            & rt.type 'number'

    lt.assertEquals(a:view(), '1 | 2')
end

do
    local a = (rt.value(1) | rt.value(2))
            & (rt.type 'number' | rt.type 'string')

    lt.assertEquals(a:view(), '1 | 2')
end
