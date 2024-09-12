local Any     = ls.node.any()
local Nil     = ls.node.Nil()
local Never   = ls.node.never()
local Unknown = ls.node.unknown()

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
end

do
    assert(ls.node.value(1) >> ls.node.value(1) == true)
    assert(ls.node.value(1) >> ls.node.value(2) == false)
    assert(ls.node.value(1) >> ls.node.value(1.0) == true)
    assert(ls.node.value(1) >> ls.node.type 'integer' == true)
end

do
    assert(ls.node.value(1.0) >> ls.node.value(1) == true)
    assert(ls.node.value(1.0) >> ls.node.value(1.0) == true)
    assert(ls.node.value(1.0) >> ls.node.value(2) == false)
    assert(ls.node.value(1.0) >> ls.node.type 'number' == true)
end

do
    assert(ls.node.value(true) >> ls.node.value(true) == true)
    assert(ls.node.value(true) >> ls.node.value(false) == false)
    assert(ls.node.value(true) >> ls.node.type 'boolean' == true)
end

do
    assert(ls.node.value(false) >> ls.node.value(false) == true)
    assert(ls.node.value(false) >> ls.node.value(true) == false)
    assert(ls.node.value(false) >> ls.node.type 'boolean' == true)
end

do
    assert(ls.node.value('abc', '"') >> ls.node.value('abc', '"') == true)
    assert(ls.node.value('abc', '"') >> ls.node.value('abc', "'") == true)
    assert(ls.node.value('abc', '"') >> ls.node.type 'string' == true)
end
