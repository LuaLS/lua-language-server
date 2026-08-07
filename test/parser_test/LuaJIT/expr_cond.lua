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
  NULL = "FALLBACK-ANY-NON-NIL-OR-FALSE-OBJECT" -- Only here!
end
NIL = nil
FALSE = false
TRUE = true
NUMBER1 = 1
NUMBER2 = 2

collectgarbage() -- Prevent (simple) global store-to-load forwarding.

-- Conditional operator: syntax.
do
  assert((NIL ? 1 : 2) == 2)
  assert((FALSE ? 1 : 2) == 2)
  assert((TRUE ? 1 : 2) == 1)
  assert((NULL ? 1 : 2) == 1)
  assert((9 ? 1 : 2) == 1)
  assert(("" ? 1 : 2) == 1)

  assert((NIL?1:2) == 2)
  assert((FALSE?1:2) == 2)
  assert((TRUE?1:2) == 1)

  assert((NIL ? NIL : FALSE) == false)
  assert((NIL ? FALSE : NIL) == nil)
  assert((FALSE ? NIL : FALSE) == false)
  assert((FALSE ? FALSE : NIL) == nil)
  assert((TRUE ? NIL : FALSE) == nil)
  assert((TRUE ? FALSE : NIL) == false)

  assert((NIL == FALSE ? 9 : 11) == 11)
  assert((FALSE == FALSE ? 9 : 11) == 9)
  assert((NUMBER1 < NUMBER2 ? 9 : 11) == 9)
  assert((NUMBER1 > NUMBER2 ? 9 : 11) == 11)

  assert((NIL ? NUMBER1 + NUMBER2 : NUMBER1 - NUMBER2) == -1)
  assert((FALSE ? NUMBER1 + NUMBER2 : NUMBER1 - NUMBER2) == -1)
  assert((TRUE ? NUMBER1 + NUMBER2 : NUMBER1 - NUMBER2) == 3)

  assert((NUMBER1 < NUMBER2 ? NUMBER1 + NUMBER2 : NUMBER1 - NUMBER2) == 3)
  assert((NUMBER1 > NUMBER2 ? NUMBER1 + NUMBER2 : NUMBER1 - NUMBER2) == -1)
end

-- Conditional operator: constant folding.
do
  assert((nil ? 1 : 2) == 2)
  assert((false ? 1 : 2) == 2)
  assert((true ? 1 : 2) == 1)
  assert((9 ? 1 : 2) == 1)
  assert(("" ? 1 : 2) == 1)

  assert((nil ? nil : false) == false)
  assert((nil ? false : nil) == nil)
  assert((false ? nil : false) == false)
  assert((false ? false : nil) == nil)
  assert((true ? nil : false) == nil)
  assert((true ? false : nil) == false)

  assert((nil == false ? 9 : 11) == 11)
  assert((false == false ? 9 : 11) == 9)
  assert((1 < 2 ? 9 : 11) == 9)
  assert((1 > 2 ? 9 : 11) == 11)

  assert((nil ? 1 + 2 : 1 - 2) == -1)
  assert((false ? 1 + 2 : 1 - 2) == -1)
  assert((true ? 1 + 2 : 1 - 2) == 3)

  assert((1 < 2 ? 1 + 2 : 1 - 2) == 3)
  assert((1 > 2 ? 1 + 2 : 1 - 2) == -1)
end

-- Conditional operator: mixed with not/and/or.
do
  assert((not (NIL ? NUMBER1 : FALSE)) == true)
  assert((not (FALSE ? NUMBER1 : FALSE)) == true)
  assert((not (TRUE ? NUMBER1 : FALSE)) == false)
  assert(((not NIL) ? NUMBER1 : FALSE) == 1)
  assert(((not FALSE) ? NUMBER1 : FALSE) == 1)
  assert(((not TRUE) ? NUMBER1 : FALSE) == false)

  assert(((NIL ? NUMBER1 : FALSE) and NUMBER2) == false)
  assert((NIL ? (NUMBER1 and NUMBER2) : FALSE) == false)
  assert(((NUMBER1 and NUMBER2) ? NIL : FALSE) == nil)
  assert((NUMBER1 and (NIL ? NUMBER2 : FALSE)) == false)

  assert(((NIL ? NUMBER1 : FALSE) or NUMBER2) == 2)
  assert((NIL ? (NUMBER1 or NUMBER2) : FALSE) == false)
  assert((NIL or NUMBER1 ? NUMBER2 : FALSE) == 2)
  assert(((NIL or NUMBER1) ? NUMBER2 : FALSE) == 2)
  assert((NIL or (NUMBER1 ? NUMBER2 : FALSE)) == 2)
  assert(((NUMBER1 or NUMBER2) ? NIL : FALSE) == nil)
  assert((NUMBER1 or (NIL ? NUMBER2 : FALSE)) == 1)
end

-- Conditional operator: associativity.
do
  assert((FALSE ? NUMBER1 : FALSE ? NUMBER2 : NUMBER1 + NUMBER2) == 3)
  assert((TRUE ? NUMBER1 : FALSE ? NUMBER2 : NUMBER1 + NUMBER2) == 1)
  assert((FALSE ? NUMBER1 : TRUE ? NUMBER2 : NUMBER1 + NUMBER2) == 2)
  assert((TRUE ? NUMBER1 : TRUE ? NUMBER2 : NUMBER1 + NUMBER2) == 1)

  assert((FALSE ? NUMBER1 : (FALSE ? NUMBER2 : NUMBER1 + NUMBER2)) == 3)
  assert((TRUE ? NUMBER1 : (FALSE ? NUMBER2 : NUMBER1 + NUMBER2)) == 1)
  assert((FALSE ? NUMBER1 : (TRUE ? NUMBER2 : NUMBER1 + NUMBER2)) == 2)
  assert((TRUE ? NUMBER1 : (TRUE ? NUMBER2 : NUMBER1 + NUMBER2)) == 1)

  assert(((FALSE ? NUMBER1 : FALSE) ? NUMBER2 : NUMBER1 + NUMBER2) == 3)
  assert(((TRUE ? NUMBER1 : FALSE) ? NUMBER2 : NUMBER1 + NUMBER2) == 2)
  assert(((FALSE ? NUMBER1 : TRUE) ? NUMBER2 : NUMBER1 + NUMBER2) == 2)
  assert(((TRUE ? NUMBER1 : TRUE) ? NUMBER2 : NUMBER1 + NUMBER2) == 2)
end

-- Conditional operator: short-circuiting.
do
  local function bad() error("call short-circuiting failed", 2) end
  assert((FALSE ? bad() : NUMBER1) == 1)
  assert((TRUE ? NUMBER1 : bad()) == 1)

  local t = setmetatable({}, {
    __index = function() error("access short-circuiting failed", 2) end,
  })
  assert((FALSE ? t.x : NUMBER1) == 1)
  assert((TRUE ? NUMBER1 : t.x) == 1)
end

-- Conditional operator: colon parsing.
do
  local a = {
    x = 1,
    b = function(obj1)
      return {
	x = 2,
	c = function(obj2)
	  return obj1.x + obj2.x + 10
	end,
      }
    end,
  }
  local b = function()
      return {
      x = 3,
      c = function(obj3)
	return obj3.x + 20
      end,
    }
  end
  local c = function() return 15 end
  assert((TRUE ? a : b():c() + 30).x == 1)
  assert((FALSE ? a : b():c() + 30) == 53)
  assert((TRUE ? a : 0 + b():c() + 30).x == 1)
  assert((FALSE ? a : 0 + b():c() + 30) == 53)
  assert((TRUE ? (a:b()) : c() + 30).x == 2)
  assert((FALSE ? (a:b()) : c() + 30) == 45)
end

-- Conditional operator: forced single return value.
do
  local function f() return 1, 2 end
  local function g() return 3, 4 end
  local a, b = FALSE ? f() : 9
  assert(a == 9 and b == nil)
  local a, b = TRUE ? f() : 9
  assert(a == 1 and b == nil)
  local a, b = FALSE ? 9 : f()
  assert(a == 1 and b == nil)
  local a, b = TRUE ? 9 : f()
  assert(a == 9 and b == nil)
  local a, b = FALSE ? f() : g()
  assert(a == 3 and b == nil)
  local a, b = TRUE ? f() : g()
  assert(a == 1 and b == nil)
end

-- Conditional operator: syntax errors.
do
  expect_err("?:", "near.*%?")
  expect_err("a?:", "near.*%?")
  expect_err("a?b:", "near.*%?")
  expect_err("a?:c", "near.*%?")
  expect_err("a?b:c", "near.*%?")
  expect_err("a?b:c = 1", "near.*%?")
  expect_err("(a?b:c) = 1", "near.*=")
  expect_err("local x = a ?", "near.*eof")
  expect_err("local x = a ? :", "near.*:")
  expect_err("local x = a ? b :", "near.*eof")
  expect_err("local x = a ? : c", "near.*:")

  expect_err("local x = a ? obj:method() : c", "near.*eof")
end

NULL = nil
FALSE = nil
TRUE = nil
NUMBER1 = nil
NUMBER2 = nil
]]
