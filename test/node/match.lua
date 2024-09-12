local Any = ls.node.any()
local Nil = ls.node.Nil()
local Never = ls.node.never()
local Unknown = ls.node.unknown()

do
    assert(Any:canCast(Any) == true)
    assert(Any:canCast(Nil) == true)
    assert(Any:canCast(Never) == false)
    assert(Any:canCast(Unknown) == true)
end

do
    assert(Nil:canCast(Any) == true)
    assert(Nil:canCast(Nil) == true)
    assert(Nil:canCast(Never) == false)
    assert(Nil:canCast(Unknown) == false)
end

do
    assert(Never:canCast(Any) == false)
    assert(Never:canCast(Nil) == false)
    assert(Never:canCast(Never) == false)
    assert(Never:canCast(Unknown) == false)
end

do
    assert(Unknown:canCast(Any) == true)
    assert(Unknown:canCast(Nil) == false)
    assert(Unknown:canCast(Never) == false)
    assert(Unknown:canCast(Unknown) == true)
end
