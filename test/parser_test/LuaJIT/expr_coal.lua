return [[

local function expect_err(code, expect)
  local f, err = loadstring(code, "=")
  if f ~= nil then
    error("unexpected success", 2)
  elseif not err:match(expect) then
    error('expected "'..expect..'", but got "'..err:gsub("^:1: ", "")..'"', 2)
  end
end

local ok, ffi = pcall(require, "ffi")
if ok then
  NULL = ffi.new("void *")
else
  NULL = nil
end
NIL = nil
FALSE = false
TRUE = true
NUMBER1 = 1
NUMBER2 = 2

collectgarbage() -- Prevent (simple) global store-to-load forwarding.

-- nil-coalescing operator: syntax.
do
  assert((NIL ?? NIL) == nil)
  assert((NIL ?? NUMBER1) == 1)
  assert((NULL ?? NUMBER1) == 1)
  assert((FALSE ?? NUMBER1) == false)
  assert((TRUE ?? NUMBER1) == true)
  assert((NUMBER1 ?? NUMBER2) == 1)

  assert((NIL == FALSE ?? NUMBER1) == false)
  assert((FALSE == FALSE ?? NUMBER1) == true)
  assert((NUMBER1 < NUMBER2 ?? NUMBER1) == true)
  assert((NUMBER1 > NUMBER2 ?? NUMBER1) == false)

  assert((NIL ?? NUMBER1 + NUMBER2) == 3)
  assert((NULL ?? NUMBER1 + NUMBER2) == 3)
  assert((FALSE ?? NUMBER1 + NUMBER2) == false)
  assert((TRUE ?? NUMBER1 + NUMBER2) == true)

  assert((NIL ?? NIL ?? NIL) == nil)

  assert((NIL ?? NIL ?? NUMBER1) == 1)
  assert((NIL ?? NULL ?? NUMBER1) == 1)
  assert((NULL ?? NULL ?? NUMBER1) == 1)

  assert((NIL ?? FALSE ?? NIL) == false)
  assert((NIL ?? FALSE ?? NUMBER2) == false)

  assert((NIL ?? NUMBER1 ?? NIL) == 1)
  assert((NIL ?? NUMBER1 ?? NUMBER2) == 1)
end

-- nil-coalescing operator: constant folding.
do
  assert((nil ?? nil) == nil)
  assert((nil ?? 1) == 1)
  assert((false ?? 1) == false)
  assert((true ?? 1) == true)
  assert((1 ?? 2) == 1)

  assert((nil == false ?? 1) == false)
  assert((false == false ?? 1) == true)
  assert((1 < 2 ?? 1) == true)
  assert((1 > 2 ?? 1) == false)

  assert((nil ?? 1 + 2) == 3)
  assert((false ?? 1 + 2) == false)
  assert((true ?? 1 + 2) == true)

  assert((nil ?? nil ?? nil) == nil)

  assert((nil ?? nil ?? 1) == 1)

  assert((nil ?? false ?? nil) == false)
  assert((nil ?? false ?? 1) == false)

  assert((nil ?? 1 ?? nil) == 1)
  assert((nil ?? 1 ?? 2) == 1)
end

-- nil-coalescing operator: mixed with not/and/or.
do
  assert((not (NIL ?? NUMBER1)) == false)
  assert((not (FALSE ?? NUMBER1)) == true)
  assert((not (TRUE ?? NUMBER1)) == false)

  assert(((not NIL) ?? NUMBER1) == true)
  assert(((not FALSE) ?? NUMBER1) == true)
  assert(((not TRUE) ?? NUMBER1) == false)

  assert(((NIL ?? NUMBER1) and NUMBER2) == 2)
  assert((NIL ?? (NUMBER1 and NUMBER2)) == 2)
  assert(((NUMBER1 and NUMBER2) ?? NIL) == 2)
  assert((NUMBER1 and (NIL ?? NUMBER2)) == 2)

  assert(((NIL ?? NUMBER1) or NUMBER2) == 1)
  assert((NIL ?? (NUMBER1 or NUMBER2)) == 1)
  assert((NIL or NUMBER1 ?? NUMBER2) == 1)
  assert(((NIL or NUMBER1) ?? NUMBER2) == 1)
  assert((NIL or (NUMBER1 ?? NUMBER2)) == 1)
  assert(((NUMBER1 or NUMBER2) ?? NIL) == 1)
  assert((NUMBER1 or (NIL ?? NUMBER2)) == 1)
end

-- nil-coalescing operator: precedence.
do
  assert((NIL ?? NUMBER1 + NUMBER2) == 3)
  assert((NUMBER1 + NUMBER2 ?? 4 + 8) == 3)

  assert((FALSE ?? NIL ? 2 : 3) == 3)
  assert(((FALSE ?? NIL) ? 2 : 3) == 3)
  assert((FALSE ?? (NIL ? 2 : 3)) == false)

  assert((not NIL ?? NUMBER1) == true)
  assert((NIL ?? NUMBER1 and NUMBER2) == 2)
  assert((NIL ?? NUMBER1 or NUMBER2) == 1)
end

-- nil-coalescing operator: short-circuiting.
do
  local function bad() error("call short-circuiting failed", 2) end
  assert((NUMBER1 ?? bad()) == 1)
  assert((NUMBER1 ?? bad() ?? bad()) == 1)

  local t = setmetatable({}, {
    __index = function() error("access short-circuiting failed", 2) end,
  })
  assert((NUMBER1 ?? t.x) == 1)
  assert((NUMBER1 ?? t.x ?? t.y) == 1)

  local ok, err = pcall(function() return NIL ?? bad() ?? t.x end)
  assert(err:match("call"))
end

-- nil-coalescing operator: syntax errors.
do
  expect_err("??", "near.*%?%?")
  expect_err("a ??", "near.*%?%?")
  expect_err("a ?? b", "near.*%?%?")
  expect_err("a ?? b = 1", "near.*%?%?")
  expect_err("a ?? b += 1", "near.*%?%?")
  expect_err("a() ?? b", "near.*%?%?")
  expect_err("a ?? b()", "near.*%?%?")
end

NULL = nil
FALSE = nil
TRUE = nil
NUMBER1 = nil
NUMBER2 = nil
]]
