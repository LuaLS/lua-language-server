local Any     = ls.node.ANY
local Nil     = ls.node.NIL
local Never   = ls.node.NEVER
local Unknown = ls.node.UNKNOWN

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
    assert(ls.node.value(1) >> Any == true)
    assert(ls.node.value(1) >> Nil == false)
    assert(ls.node.value(1) >> Never == false)
    assert(ls.node.value(1) >> Unknown == true)

    assert(Any     >> ls.node.value(1) == true)
    assert(Nil     >> ls.node.value(1) == false)
    assert(Never   >> ls.node.value(1) == false)
    assert(Unknown >> ls.node.value(1) == true)
end

do
    assert(ls.node.value(1) >> ls.node.value(1) == true)
    assert(ls.node.value(1) >> ls.node.value(2) == false)
    assert(ls.node.value(1) >> ls.node.value(1.0) == true)
    assert(ls.node.value(1) >> ls.node.type 'integer' == true)

    assert(ls.node.type 'integer' >> ls.node.value(1) == false)
end

do
    assert(ls.node.value(1.0) >> ls.node.value(1) == true)
    assert(ls.node.value(1.0) >> ls.node.value(1.0) == true)
    assert(ls.node.value(1.0) >> ls.node.value(2) == false)
    assert(ls.node.value(1.0) >> ls.node.type 'integer' == true)

    assert(ls.node.type 'integer' >> ls.node.value(1.0) == false)
end

do
    assert(ls.node.value(1.1) >> ls.node.type 'integer' == false)
    assert(ls.node.value(1.1) >> ls.node.type 'number'  == true)

    assert(ls.node.type 'number' >> ls.node.value(1.1) == false)
end

do
    assert(ls.node.value(true) >> ls.node.value(true) == true)
    assert(ls.node.value(true) >> ls.node.value(false) == false)
    assert(ls.node.value(true) >> ls.node.type 'boolean' == true)

    assert(ls.node.type 'boolean' >> ls.node.value(true) == false)
end

do
    assert(ls.node.value(false) >> ls.node.value(false) == true)
    assert(ls.node.value(false) >> ls.node.value(true) == false)
    assert(ls.node.value(false) >> ls.node.type 'boolean' == true)

    assert(ls.node.type 'boolean' >> ls.node.value(false) == false)
end

do
    assert(ls.node.value('abc', '"') >> ls.node.value('abc', '"') == true)
    assert(ls.node.value('abc', '"') >> ls.node.value('abc', "'") == true)
    assert(ls.node.value('abc', '"') >> ls.node.type 'string' == true)

    assert(ls.node.type 'string' >> ls.node.value('abc', '"') == false)
end

do
    local a = ls.node.type 'number'
    local b = ls.node.type 'string'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = ls.node.type 'number'
    local b = ls.node.type 'number' | ls.node.type 'string'

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = ls.node.type 'number' | ls.node.type 'string'
    local b = ls.node.type 'number' | ls.node.type 'boolean'

    assert(a >> b == false)
    assert(b >> a == false)
end

do
    local a = ls.node.type 'number' | ls.node.type 'string'
    local b = ls.node.type 'number' | ls.node.type 'boolean' | ls.node.type 'string'

    assert(a >> b == true)
    assert(b >> a == false)
end

do
    local a = ls.node.type 'number'
    local b = ls.node.type 'integer'

    assert(a >> b == false)
    assert(b >> a == true)
end

do
    local a = ls.node.type 'A'
    local b = ls.node.type 'B'
    local c = ls.node.type 'C'

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
