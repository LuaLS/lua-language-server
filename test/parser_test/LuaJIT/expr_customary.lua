return [[

NIL = nil
FALSE = false
TRUE = true
NUMBER1 = 1
NUMBER2 = 2

collectgarbage() -- Prevent (simple) global store-to-load forwarding.

-- Customary operators: syntax.
do
  assert((! NIL) == true)
  assert((! FALSE) == true)
  assert((! TRUE) == false)
  assert((! NUMBER1) == false)

  assert((NIL && NUMBER1) == nil)
  assert((FALSE && NUMBER1) == false)
  assert((TRUE && NUMBER1) == 1)

  assert((NIL || NUMBER1) == 1)
  assert((FALSE || NUMBER1) == 1)
  assert((TRUE || NUMBER1) == true)
end

-- Customary operators: constant folding.
do
  assert((! nil) == true)
  assert((! false) == true)
  assert((! true) == false)
  assert((! 1) == false)

  assert((nil && 1) == nil)
  assert((false && 1) == false)
  assert((true && 1) == 1)

  assert((nil || 1) == 1)
  assert((false || 1) == 1)
  assert((true || 1) == true)
end

-- Customary operators: precedence.
do
  assert((! NIL && NUMBER1) == 1)
  assert(((! NIL) && NUMBER1) == 1)
  assert((! (NIL && NUMBER1)) == true)

  assert((! NIL || NUMBER1) == true)
  assert(((! NIL) || NUMBER1) == true)
  assert((! (NIL || NUMBER1)) == false)

  assert((NIL && TRUE || NUMBER1) == 1)
  assert(((NIL && TRUE) || NUMBER1) == 1)
  assert((NIL && (TRUE || NUMBER1)) == nil)

  assert((NIL && FALSE || NUMBER1) == 1)
  assert(((NIL && FALSE) || NUMBER1) == 1)
  assert((NIL && (FALSE || NUMBER1)) == nil)

  assert((TRUE && FALSE || NUMBER1) == 1)
  assert(((TRUE && FALSE) || NUMBER1) == 1)
  assert((TRUE && (FALSE || NUMBER1)) == 1) -- OK. Classic pitfall, use ?:

  debug.setmetatable(false, {
    __add = function(a, b)
      if a == false then return b+10 else return b+20 end
    end,
  })

    assert((! NUMBER1 + NUMBER2) == 12)
    assert(((! NUMBER1) + NUMBER2) == 12)
    assert((! (NUMBER1 + NUMBER2)) == false)

    assert((TRUE && NUMBER1 + NUMBER2) == 3)
    assert((FALSE && NUMBER1 + NUMBER2) == false)
    assert((FALSE && (NUMBER1 + NUMBER2)) == false)
    assert(((FALSE && NUMBER1) + NUMBER2) == 12)

    assert((FALSE || NUMBER1 + NUMBER2) == 3)
    assert((TRUE || NUMBER1 + NUMBER2) == true)
    assert((TRUE || (NUMBER1 + NUMBER2)) == true)
    assert(((TRUE || NUMBER1) + NUMBER2) == 22)

  debug.setmetatable(false, nil)
end

-- Customary operators: associativity.
do
  assert((TRUE && NUMBER1 && NUMBER2) == 2)
  assert(((TRUE && NUMBER1) && NUMBER2) == 2)
  assert((TRUE && (NUMBER1 && NUMBER2)) == 2)

  assert((FALSE && NUMBER1 && NUMBER2) == false)
  assert(((FALSE && NUMBER1) && NUMBER2) == false)
  assert((FALSE && (NUMBER1 && NUMBER2)) == false)

  assert((TRUE || NUMBER1 || NUMBER2) == true)
  assert(((TRUE || NUMBER1) || NUMBER2) == true)
  assert((TRUE || (NUMBER1 || NUMBER2)) == true)

  assert((FALSE || NUMBER1 || NUMBER2) == 1)
  assert(((FALSE || NUMBER1) || NUMBER2) == 1)
  assert((FALSE || (NUMBER1 || NUMBER2)) == 1)
end

-- Customary operators: short-circuiting.
do
  local function bad() error("call short-circuiting failed", 2) end
  assert((FALSE && bad()) == false)
  assert((TRUE || bad()) == true)

  local t = setmetatable({}, {
    __index = function() error("access short-circuiting failed", 2) end,
  })
  assert((FALSE && t.x) == false)
  assert((TRUE || t.x) == true)
end

NULL = nil
FALSE = nil
TRUE = nil
NUMBER1 = nil
NUMBER2 = nil
]]
