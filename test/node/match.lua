local Any = ls.node.any()
local Nil = ls.node.Nil()
local Never = ls.node.never()
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
    --assert(ls.node.value(1):canCast)
end
