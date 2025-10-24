local node = test.scope.node

local Any     = node.ANY
local Nil     = node.NIL
local Never   = node.NEVER
local Unknown = node.UNKNOWN

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
    assert(node.value(1) >> Any == true)
    assert(node.value(1) >> Nil == false)
    assert(node.value(1) >> Never == false)
    assert(node.value(1) >> Unknown == true)

    assert(Any     >> node.value(1) == true)
    assert(Nil     >> node.value(1) == false)
    assert(Never   >> node.value(1) == false)
    assert(Unknown >> node.value(1) == true)
end

do
    assert(node.value(1) >> node.value(1) == true)
    assert(node.value(1) >> node.value(2) == false)
    assert(node.value(1) >> node.value(1.0) == true)
    assert(node.value(1) >> node.type 'integer' == true)

    assert(node.type 'integer' >> node.value(1) == false)
end

do
    assert(node.value(1.0) >> node.value(1) == true)
    assert(node.value(1.0) >> node.value(1.0) == true)
    assert(node.value(1.0) >> node.value(2) == false)
    assert(node.value(1.0) >> node.type 'integer' == true)

    assert(node.type 'integer' >> node.value(1.0) == false)
end

do
    assert(node.value(1.1) >> node.type 'integer' == false)
    assert(node.value(1.1) >> node.type 'number'  == true)

    assert(node.type 'number' >> node.value(1.1) == false)
end

do
    assert(node.value(true) >> node.value(true) == true)
    assert(node.value(true) >> node.value(false) == false)
    assert(node.value(true) >> node.type 'boolean' == true)

    assert(node.type 'boolean' >> node.value(true) == false)
end

do
    assert(node.value(false) >> node.value(false) == true)
    assert(node.value(false) >> node.value(true) == false)
    assert(node.value(false) >> node.type 'boolean' == true)

    assert(node.type 'boolean' >> node.value(false) == false)
end

do
    assert(node.value('abc', '"') >> node.value('abc', '"') == true)
    assert(node.value('abc', '"') >> node.value('abc', "'") == true)
    assert(node.value('abc', '"') >> node.type 'string' == true)

    assert(node.type 'string' >> node.value('abc', '"') == false)
end

do
    local a = node.type 'number'
    local b = node.type 'string'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = node.type 'number'
    local b = node.type 'number' | node.type 'string'

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = node.type 'number' | node.type 'string'
    local b = node.type 'number' | node.type 'boolean'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = node.type 'number' | node.type 'string'
    local b = node.type 'number' | node.type 'boolean' | node.type 'string'

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = node.type 'number'
    local b = node.type 'integer'

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    node:reset()

    local a = node.type 'A'
    local b = node.type 'B'
    local c = node.type 'C'

    node.class('A', nil, { b })
    node.class('B', nil, { c })
    node.class('C', nil, { a })

    assert(a >> b == true)
    assert(a >> c == true)
    assert(b >> c == true)
    assert(b >> a == true)
    assert(c >> a == true)
    assert(c >> b == true)
end

do
    local a = node.value(1)
    local b = node.value(2)
    local c = node.type 'number'

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
    local a = node.type 'number'
            & (node.value(1) | node.value(2))

    assert(a:view() == '1 | 2')
end

do
    local a = (node.value(1) | node.value(2))
            & node.type 'number'

    assert(a:view() == '1 | 2')
end

do
    local a = (node.value(1) | node.value(2))
            & (node.type 'number' | node.type 'string')

    assert(a:view() == '1 | 2')
end
