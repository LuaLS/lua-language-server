local rt = test.scope.rt

local Any     = rt.ANY
local Nil     = rt.NIL
local Never   = rt.NEVER
local Unknown = rt.UNKNOWN

do
    assert(Any >> Any == true)
    assert(Any >> Nil == true)
    assert(Any >> Never == false)
    assert(Any >> Unknown == true)
end

do
    assert(Nil >> Any == true)
    assert(Nil >> Nil == true)
    assert(Nil >> Never == false)
    assert(Nil >> Unknown == false)
end

do
    assert(Never >> Any == false)
    assert(Never >> Nil == false)
    assert(Never >> Never == false)
    assert(Never >> Unknown == false)
end

do
    assert(Unknown >> Any == true)
    assert(Unknown >> Nil == false)
    assert(Unknown >> Never == false)
    assert(Unknown >> Unknown == true)
end

do
    assert(rt.value(1) >> Any == true)
    assert(rt.value(1) >> Nil == false)
    assert(rt.value(1) >> Never == false)
    assert(rt.value(1) >> Unknown == true)

    assert(Any     >> rt.value(1) == true)
    assert(Nil     >> rt.value(1) == false)
    assert(Never   >> rt.value(1) == false)
    assert(Unknown >> rt.value(1) == true)
end

do
    assert(rt.value(1) >> rt.value(1) == true)
    assert(rt.value(1) >> rt.value(2) == false)
    assert(rt.value(1) >> rt.value(1.0) == true)
    assert(rt.value(1) >> rt.type 'integer' == true)

    assert(rt.type 'integer' >> rt.value(1) == false)
end

do
    assert(rt.value(1.0) >> rt.value(1) == true)
    assert(rt.value(1.0) >> rt.value(1.0) == true)
    assert(rt.value(1.0) >> rt.value(2) == false)
    assert(rt.value(1.0) >> rt.type 'integer' == true)

    assert(rt.type 'integer' >> rt.value(1.0) == false)
end

do
    assert(rt.value(1.1) >> rt.type 'integer' == false)
    assert(rt.value(1.1) >> rt.type 'number'  == true)

    assert(rt.type 'number' >> rt.value(1.1) == false)
end

do
    assert(rt.value(true) >> rt.value(true) == true)
    assert(rt.value(true) >> rt.value(false) == false)
    assert(rt.value(true) >> rt.type 'boolean' == true)

    assert(rt.type 'boolean' >> rt.value(true) == false)
end

do
    assert(rt.value(false) >> rt.value(false) == true)
    assert(rt.value(false) >> rt.value(true) == false)
    assert(rt.value(false) >> rt.type 'boolean' == true)

    assert(rt.type 'boolean' >> rt.value(false) == false)
end

do
    assert(rt.value('abc', '"') >> rt.value('abc', '"') == true)
    assert(rt.value('abc', '"') >> rt.value('abc', "'") == true)
    assert(rt.value('abc', '"') >> rt.type 'string' == true)

    assert(rt.type 'string' >> rt.value('abc', '"') == false)
end

do
    local a = rt.type 'number'
    local b = rt.type 'string'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = rt.type 'number'
    local b = rt.type 'number' | rt.type 'string'

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = rt.type 'number' | rt.type 'string'
    local b = rt.type 'number' | rt.type 'boolean'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = rt.type 'number' | rt.type 'string'
    local b = rt.type 'number' | rt.type 'boolean' | rt.type 'string'

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = rt.type 'number'
    local b = rt.type 'integer'

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    rt:reset()

    local a = rt.type 'A'
    local b = rt.type 'B'
    local c = rt.type 'C'

    rt.class('A', nil, { b })
    rt.class('B', nil, { c })
    rt.class('C', nil, { a })

    assert(a >> b == true)
    assert(a >> c == true)
    assert(b >> c == true)
    assert(b >> a == true)
    assert(c >> a == true)
    assert(c >> b == true)
end

do
    local a = rt.value(1)
    local b = rt.value(2)
    local c = rt.type 'number'

    assert(a >> b == false)
    assert(a >> c == true)
    assert(b >> c == true)
    assert(c >> a == false)
    assert(c >> b == false)

    assert((a | b) >> c == true)
    assert((b | c) >> a == false)
    assert((c | a) >> b == false)
    assert(c >> (a | b) == false)
    assert(a >> (b | c) == true)
    assert(b >> (c | a) == true)
end

do
    local a = rt.type 'number'
            & (rt.value(1) | rt.value(2))

    assert(a:view() == '1 | 2')
end

do
    local a = (rt.value(1) | rt.value(2))
            & rt.type 'number'

    assert(a:view() == '1 | 2')
end

do
    local a = (rt.value(1) | rt.value(2))
            & (rt.type 'number' | rt.type 'string')

    assert(a:view() == '1 | 2')
end
