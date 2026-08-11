return [[

local function expect_err(code, expect)
  local f, err = loadstring(code, "=")
  if f ~= nil then
    error("unexpected success", 2)
  elseif not err:match(expect) then
    error('expected "'..expect..'", but got "'..err:gsub("^:1: ", "")..'"', 2)
  end
end

NUMBER1 = 1
NUMBER2 = 2
NUMBER3 = 3
STRX = "x"
STRY = "y"

collectgarbage() -- Prevent (simple) global store-to-load forwarding.

-- Compound assignment: syntax.
do
  do local a = NUMBER3; a += NUMBER2; assert(a == 5) end
  do local a = NUMBER3; a -= NUMBER2; assert(a == 1) end
  do local a = NUMBER3; a *= NUMBER2; assert(a == 6) end
  do local a = NUMBER3; a /= NUMBER2; assert(a == 1.5) end
  do local a = NUMBER3; a %= NUMBER2; assert(a == 1) end

  do local a = NUMBER3; a &= NUMBER2; assert(a == 2) end
  do local a = NUMBER1; a |= NUMBER2; assert(a == 3) end
  do local a = NUMBER3; a ~= NUMBER2; assert(a == 1) end

  do local a = NUMBER3; a <<= NUMBER2; assert(a == 12) end
  do local a = NUMBER3; a >>= NUMBER1; assert(a == 1) end
  do local a = NUMBER3; a ~>>= NUMBER1; assert(a == 1) end
  do local a = -NUMBER3; a ~>>= NUMBER1; assert(a == -2) end

  do local a = STRX; a ..= STRY; assert(a == "xy") end

  do local t = { x = NUMBER2 }; t.x += NUMBER3; assert(t.x == 5) end
  do local t = { NUMBER2 }; t[1] += NUMBER3; assert(t[1] == 5) end
end

-- Compound assignment: constant folding.
do
  do local a = 3; a += 2; assert(a == 5) end
  do local a = 3; a -= 2; assert(a == 1) end
  do local a = 3; a *= 2; assert(a == 6) end
  do local a = 3; a /= 2; assert(a == 1.5) end
  do local a = 3; a %= 2; assert(a == 1) end

  do local a = 3; a &= 2; assert(a == 2) end
  do local a = 1; a |= 2; assert(a == 3) end
  do local a = 3; a ~= 2; assert(a == 1) end

  do local a = 3; a <<= 2; assert(a == 12) end
  do local a = 3; a >>= 1; assert(a == 1) end
  do local a = 3; a ~>>= 1; assert(a == 1) end
  do local a = -3; a ~>>= 1; assert(a == -2) end

  do local a = "x"; a ..= "y"; assert(a == "xy") end
end

-- Compound assignment: indexing metamethods.
do
  local mt = {
    __index = function(t, k) t.get += 1; return rawget(t, "_"..k) end,
    __newindex = function(t, k, v) t.set += 1; rawset(t, "_"..k, v) end,
  }
  local function proxy()
    return setmetatable({ get = 0, set = 0, }, mt)
  end
  do
    local t = proxy()
    t.x = NUMBER2
    assert(t.get == 0 and t.set == 1)
    t.x += NUMBER3
    assert(t.get == 1 and t.set == 2)
    assert(t.x == 5)
    assert(t.get == 2 and t.set == 2)
  end
  do
    local t = proxy()
    rawset(t, "x", NUMBER2)
    assert(t.get == 0 and t.set == 0)
    t.x += NUMBER3
    assert(t.get == 0 and t.set == 0)
    assert(t.x == 5)
  end
end

-- Compound assignment: extra metamethod argument.
if jit and jit.version_num >= 30000 then -- NOT backported to v2.1.
  local mt = { __add = function(a, b, c) b.c = c; return a.x + b.x end }
  local function adder(x)
    return setmetatable({ c = "BAD", x = x }, mt)
  end
  do
    local a = adder(NUMBER2)
    local b = adder(NUMBER3)
    local y = a + b
    assert(y == 5 and b.c == nil)
  end
  do
    local a = adder(NUMBER2)
    local b = adder(NUMBER3)
    a += b
    assert(a == 5 and b.c == true)
  end
end

-- Compound assignment: syntax error.
do
  expect_err("x + = 1", "near.*%+")

  expect_err("+=", "near.*%+")
  expect_err("x +=", "near.*eof")
  expect_err("+= 1", "near.*%+")

  expect_err("(x) += 1", "near.*%+")
  expect_err("f() += 1", "near.*%+")

  expect_err("x, y += 1", "near.*%+") -- No parallel assignment.
  expect_err("x, y += 1, 2", "near.*%+") -- No parallel assignment.

  expect_err("x ^= 1", "near.*^") -- No power compound assignment.
end

NUMBER1 = nil
NUMBER2 = nil
NUMBER3 = nil
STRX = nil
STRY = nil
]]
