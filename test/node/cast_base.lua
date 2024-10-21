local Any     = test.scope.node.ANY
local Nil     = test.scope.node.NIL
local Never   = test.scope.node.NEVER
local Unknown = test.scope.node.UNKNOWN

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
    assert(test.scope.node.value(1) >> Any == true)
    assert(test.scope.node.value(1) >> Nil == false)
    assert(test.scope.node.value(1) >> Never == false)
    assert(test.scope.node.value(1) >> Unknown == true)

    assert(Any     >> test.scope.node.value(1) == true)
    assert(Nil     >> test.scope.node.value(1) == false)
    assert(Never   >> test.scope.node.value(1) == false)
    assert(Unknown >> test.scope.node.value(1) == true)
end

do
    assert(test.scope.node.value(1) >> test.scope.node.value(1) == true)
    assert(test.scope.node.value(1) >> test.scope.node.value(2) == false)
    assert(test.scope.node.value(1) >> test.scope.node.value(1.0) == true)
    assert(test.scope.node.value(1) >> test.scope.node.type 'integer' == true)

    assert(test.scope.node.type 'integer' >> test.scope.node.value(1) == false)
end

do
    assert(test.scope.node.value(1.0) >> test.scope.node.value(1) == true)
    assert(test.scope.node.value(1.0) >> test.scope.node.value(1.0) == true)
    assert(test.scope.node.value(1.0) >> test.scope.node.value(2) == false)
    assert(test.scope.node.value(1.0) >> test.scope.node.type 'integer' == true)

    assert(test.scope.node.type 'integer' >> test.scope.node.value(1.0) == false)
end

do
    assert(test.scope.node.value(1.1) >> test.scope.node.type 'integer' == false)
    assert(test.scope.node.value(1.1) >> test.scope.node.type 'number'  == true)

    assert(test.scope.node.type 'number' >> test.scope.node.value(1.1) == false)
end

do
    assert(test.scope.node.value(true) >> test.scope.node.value(true) == true)
    assert(test.scope.node.value(true) >> test.scope.node.value(false) == false)
    assert(test.scope.node.value(true) >> test.scope.node.type 'boolean' == true)

    assert(test.scope.node.type 'boolean' >> test.scope.node.value(true) == false)
end

do
    assert(test.scope.node.value(false) >> test.scope.node.value(false) == true)
    assert(test.scope.node.value(false) >> test.scope.node.value(true) == false)
    assert(test.scope.node.value(false) >> test.scope.node.type 'boolean' == true)

    assert(test.scope.node.type 'boolean' >> test.scope.node.value(false) == false)
end

do
    assert(test.scope.node.value('abc', '"') >> test.scope.node.value('abc', '"') == true)
    assert(test.scope.node.value('abc', '"') >> test.scope.node.value('abc', "'") == true)
    assert(test.scope.node.value('abc', '"') >> test.scope.node.type 'string' == true)

    assert(test.scope.node.type 'string' >> test.scope.node.value('abc', '"') == false)
end

do
    local a = test.scope.node.type 'number'
    local b = test.scope.node.type 'string'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = test.scope.node.type 'number'
    local b = test.scope.node.type 'number' | test.scope.node.type 'string'

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = test.scope.node.type 'number' | test.scope.node.type 'string'
    local b = test.scope.node.type 'number' | test.scope.node.type 'boolean'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = test.scope.node.type 'number' | test.scope.node.type 'string'
    local b = test.scope.node.type 'number' | test.scope.node.type 'boolean' | test.scope.node.type 'string'

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = test.scope.node.type 'number'
    local b = test.scope.node.type 'integer'

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    local a = test.scope.node.type 'A'
    local b = test.scope.node.type 'B'
    local c = test.scope.node.type 'C'

    a:addExtends(b)
    b:addExtends(c)
    c:addExtends(a)

    assert(a >> b == true)
    assert(a >> c == true)
    assert(b >> c == true)
    assert(b >> a == true)
    assert(c >> a == true)
    assert(c >> b == true)

    a:removeExtends(b)
    b:removeExtends(c)
    c:removeExtends(a)
end

do
    local a = test.scope.node.value(1)
    local b = test.scope.node.value(2)
    local c = test.scope.node.type 'number'

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
    local a = test.scope.node.type 'number'
            & (test.scope.node.value(1) | test.scope.node.value(2))

    assert(a:view() == '1 | 2')
end

do
    local a = (test.scope.node.value(1) | test.scope.node.value(2))
            & test.scope.node.type 'number'

    assert(a:view() == '1 | 2')
end

do
    local a = (test.scope.node.value(1) | test.scope.node.value(2))
            & (test.scope.node.type 'number' | test.scope.node.type 'string')

    assert(a:view() == '1 | 2')
end
