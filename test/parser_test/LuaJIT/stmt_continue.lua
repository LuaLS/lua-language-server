return [[

local function expect_err(code, expect)
  local f, err = loadstring(code, "=")
  if f ~= nil then
    error("unexpected success", 2)
  elseif not err:match(expect) then
    error('expected "'..expect..'", but got "'..err:gsub("^:1: ", "")..'"', 2)
  end
end

-- continue: while loop.
do
  local sum = 0
  local i = 0
  while i < 100 do
    i = i + 1
    if (i & 4) == 0 then continue end
    if i >= 70 and i <= 80 then continue end
    if i == 95 then break end
    sum = sum + i
  end
  assert(sum == 1830)
end

-- continue: repeat loop.
do
  local sum = 0
  local i = 0
  repeat
    i = i + 1
    if (i & 4) == 0 then continue end
    if i >= 70 and i <= 80 then continue end
    if i == 95 then break end
    sum = sum + i
  until i >= 100
  assert(sum == 1830)
end

-- continue: numeric for loop.
do
  local sum = 0
  for i=1,100 do
    if (i & 4) == 0 then continue end
    if i >= 70 and i <= 80 then continue end
    if i == 95 then break end
    sum = sum + i
  end
  assert(sum == 1830)
end

-- continue: generic for loop.
do
  local t = {}
  for i=1,100 do t[i] = i end
  local sum = 0
  for _,i in ipairs(t) do
    if (i & 4) == 0 then continue end
    if i >= 70 and i <= 80 then continue end
    if i == 95 then break end
    sum = sum + i
  end
  assert(sum == 1830)
end

-- continue: nested continue.
do
  local sum = 0
  for j=1,10 do
    if j == 8 then continue end
    for i=1,100 do
      if (i & 4) == 0 then continue end
      if i >= 70 and i <= 80 then continue end
      if i == 95 then break end
      sum = sum + i
    end
  end
  assert(sum == 1830*9)
end

-- continue: closures.
do
  local t = {}
  for i=1,100 do
    t[i] = function() return i+2 end
    if i >= 70 then
      continue
    end
  end
  for i=1,100 do
    assert(t[i]() == i+2)
  end

  local u = {}
  local j = 0
  repeat
    j = j + 1
    local k = j
    if j >= 70 then
      continue
    end
  until (function() u[j] = function() return k+2 end; return k >= 100 end)()
  for i=1,100 do
    assert(u[i]() == i+2)
  end
end

-- continue: syntax errors and semantic errors.
do
  expect_err("continue", "loop.*continue")
  expect_err("do continue end", "loop.*continue")
  expect_err("function f() continue end", "loop.*continue")

  expect_err("repeat continue; x = 1 until false", "expected")

  expect_err("repeat if x then continue end; local a = a; until not a", "continue.*scope.*'a'")
  expect_err("repeat if x then continue end; local a = a; if y then continue end until not a", "continue.*scope.*'a'")
  expect_err("repeat if true then local a; continue end; local a = a; until not a", "continue.*scope.*'a'")
end

-- continue: soft keyword.
do
  do
    local continue = 1
    assert(continue == 1)
    continue = 2
    assert(continue == 2)
    continue = continue
    assert(continue == 2)
  end
  do
    const continue = 1
    assert(continue == 1)
  end
  do
    local x = 1
    goto continue
    x = 2
  ::continue::
    assert(x == 1)
  end
  do
    local t = { continue = 1 }
    assert(t.continue == 1)
  end
  do
    local function continue() return 1 end
    assert(continue() == 1)
  end
  do
    local function f(continue) return continue + 1 end
    assert(f(1) == 2)
  end
  do
    local f = continue -> continue + 1
    assert(f(1) == 2)
    assert((continue -> continue + 1)(1) == 2)
  end
end
]]
