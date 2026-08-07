return [[

local function expect_err(code, expect)
  local f, err = loadstring(code, "=")
  if f ~= nil then
    error("unexpected success", 2)
  elseif not err:match(expect) then
    error('expected "'..expect..'", but got "'..err:gsub("^:1: ", "")..'"', 2)
  end
end

-- const: declaration.
do
  const x = 1
  assert(x == 1)

  const y, z = 2, 3
  assert(y == 2 and z == 3)

  local function f() const u = 2; return x + u end
  local u = 10
  assert(f() == 3)
end

-- const: lexical scoping.
do
  do const x = 1 end
  const x = 2
  do const y = 3 end
  local y = 4
  assert(x == 2 and y == 4)
end

-- const: re-assignment error.
do
  expect_err("const x = 1; x = 1", "assign to const")
  expect_err("const x = 1; x += 1", "assign to const")
  expect_err("const x, y = 1, 2; y = 2", "assign to const")
  expect_err("const x = 1; function x() end", "assign to const")
  expect_err("const x = 1; local function f() x = 1 end", "assign to const")
  expect_err("const x = 1; local function f() return function() return function() x = 1 end end end", "assign to const")

  -- Check line number of error.
  expect_err("const x = 1\na,\nx,\ny = 1, 2, 3\nreturn", ":3:")
  expect_err("const x = 1\nfunction x()\nend\nreturn", ":2:")
end

-- const: local re-declaration error.
do
  expect_err("const x = 1; const x = 1", "declare const")
  expect_err("const x = 1; local x = 1", "declare const")
  expect_err("const x = 1; local y, x = 1, 1", "declare const")
  expect_err("const x, x = 1, 1", "declare const")

  expect_err("const x = 1; local function x() end", "declare const")
  expect_err("const x = 1; for x=1,100 do end", "declare const")
  expect_err("const x = 1; for x in pairs(_G) do end", "declare const")
end

-- const: upvalue re-declaration error.
do
  expect_err("const x = 1; local function f() const x = 1 end", "declare const")

  expect_err("const x = 1; local function f() local x = 1 end", "declare const")

  expect_err("const x = 1; local function f() return function() return function() const x = 1 end end end", "declare const")
end

-- const: parameter re-declaration error.
do
  expect_err("const x = 1; local function f(x) end", "declare const")
  expect_err("const x = 1; local f = |x| -> x", "declare const")
end

-- const: soft keyword.
do
  do
    local const = 1
    assert(const == 1)
    const = 2
    assert(const == 2)
    const = const
    assert(const == 2)
  end
  do
    const const = 1
    assert(const == 1)
  end
  do
    local x = 1
    goto const
    x = 2
  ::const::
    assert(x == 1)
  end
  do
    local t = { const = 1 }
    assert(t.const == 1)
  end
  do
    local function const() return 1 end
    assert(const() == 1)
  end
  do
    local function f(const) return const + 1 end
    assert(f(1) == 2)
  end
  do
    local f = const -> const + 1
    assert(f(1) == 2)
    assert((const -> const + 1)(1) == 2)
  end
end
]]
