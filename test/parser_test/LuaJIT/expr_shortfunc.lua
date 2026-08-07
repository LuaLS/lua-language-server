return [[

local function expect_err(code, expect)
  local f, err = loadstring(code, "=")
  if f ~= nil then
    error("unexpected success", 2)
  elseif not err:match(expect) then
    error('expected "'..expect..'", but got "'..err:gsub("^:1: ", "")..'"', 2)
  end
end

-- Short functions: expression syntax.
do
  local f0 = ||->11
  assert(f0() == 11)

  local f1a = x->x+1
  assert(f1a(10) == 11)

  local f1b = |x|->x+1
  assert(f1b(10) == 11)

  local f2 = |x, y| -> x + y
  assert(f2(10, 2) == 12)
end

-- Short functions: statement syntax.
do
  local f00 = ||->do end
  assert(f00() == nil)
  assert(select("#", f00()) == 0)

  local f0 = ||->do return 11 end
  assert(f0() == 11)

  local f1a = x->do return x+1 end
  assert(f1a(10) == 11)

  local f1b = |x|->do return x+1 end
  assert(f1b(10) == 11)

  local f2 = |x, y| -> do return x + y end
  assert(f2(10, 2) == 12)
end

-- Short functions: vararg functions.
do
  local fv1a = |...| -> ...
  local a, b = fv1a(1, 2)
  assert(a == 1 and b == 2)

  local fv1b = |...| -> do return ... end
  local c, d = fv1b(1, 2)
  assert(c == 1 and d == 2)

  local fv3 = |a, b, ...| -> a + b + ...
  assert(fv3(1, 2, 8, 100) == 11)
end

-- Short functions: multiple results.
do
  local gg = ||->do return 1, 2 end
  local a, b = gg()
  assert(a == 1 and b == 2)

  local ff = ||->gg()
  local c, d = ff()
  assert(c == 1 and d == 2)
end

-- Short functions: parse single expression.
do
  local a, b = x->x, 1
  assert(type(a) == "function" and b == 1)

  local c, d = a(2)
  assert(c == 2 and d == nil)

  local e, f = |x|->x, 1
  assert(f == 1)

  local g, h = ||->a, 1
  assert(h == 1)

  local t = { 1, x->x+1, 3, f = x->x+2, g = "g", 4 }
  assert(t[1] == 1 and t[2](10) == 11 and t[3] == 3)
  assert(t.f(10) == 12 and t.g == "g" and t[4] == 4)
end

-- Short functions: syntax errors.
do
  expect_err("local f = -> 1", "unexpected.*%->")

  expect_err("local f = || 1", "%->.*expected")
  expect_err("local f = |x| 1", "%->.*expected")

  expect_err("local f = || ->", "eof")
  expect_err("local f = |x| ->", "eof")

  expect_err("local f = || -> do", "end.*expected")
  expect_err("local f = |x| -> do", "end.*expected")

  expect_err("local f = || -> ||", "%->.*expected")
  expect_err("local f = |x| -> ||", "%->.*expected")
  expect_err("local f = || -> |y|", "%->.*expected")
  expect_err("local f = |x| -> |y|", "%->.*expected")

  expect_err("local f = || -> ->", "unexpected.*%->")
  expect_err("local f = |x| -> ->", "unexpected.*%->")

  expect_err("local f = a || ->", "unexpected.*%->")
  expect_err("local f = a |x| ->", "unexpected.*%->")

  expect_err("|| -> 1", "unexpected.*'||'")
  expect_err("|.| -> 1", "unexpected.*'|'")
  expect_err("x -> x = 1", "expected.*%->")

  expect_err("local f = |x+y| -> a", "'|'.*expected")
  expect_err("local f = |x=y| -> a", "'|'.*expected")
  expect_err("local f = |x:y| -> a", "'|'.*expected")

  expect_err("local f = a ? ||->a:b() : c", "arguments.*expected")
end

-- Short functions: closures.
do
  local a = 1
  local fc1 = x -> x + a
  assert(fc1(10) == 11)

  local b = 1
  (x -> do b = x end)(20)
  assert(b == 20)

  local fc2
  do
    local c = 1
    fc2 = x -> x + c
  end
  collectgarbage()
  assert(fc2(10) == 11)

  local fc3g, fc3s
  do
    local d = 1
    fc3g, fc3s = || -> d, x -> do d = x end
  end
  collectgarbage()
  assert(fc3g() == 1)
  assert(fc3s(2) == nil)
  assert(fc3g() == 2)

  local inv = { 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 }
  local t = { 3, 7, 2, 6 }
  table.sort(t, |a, b| -> inv[a] < inv[b])
  assert(t[1] == 7 and t[2] == 6 and t[3] == 3 and t[4] == 2)
end

-- Short functions: precedence.
do
  local f = x -> y -> x + y
  assert(f(10)(1) == 11)

  debug.setmetatable(f, {
    __pow = |a, b| -> b(a),
    __add = |a, b| -> b(a),
  })

    local a = 2 ^ x -> x + 3
    assert(a == 5)

    local b = 1 + x -> do return x + 3 end + 8
    assert(b == 12)

  debug.setmetatable(f, nil)
end
]]
