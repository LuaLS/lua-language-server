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
STRX = "x"
TAB = {
  x = 1,
  y = { z = 2 },
  v = "y",
  f = function(x) return x + 2 end,
  m = function(self, y) return self.x + y + 4 end,
  9,
}

collectgarbage() -- Prevent (simple) global store-to-load forwarding.

-- Safe navigation operator: indexing syntax.
do
  local local_nil = NIL
  local local_null = NULL
  local local_tab = { x = 1 }

  assert((nil)?.x == nil)
  assert(local_nil?.x == nil)
  assert(local_null?.x == nil)
  assert(tostring(local_null?.x) == "nil")
  assert(local_tab?.x == 1)

  local uv_nil = NIL
  local uv_null = NULL
  local uv_tab = { x = 1 }

  assert((function() return uv_nil?.x end)() == nil)
  assert((function() return uv_null?.x end)() == nil)
  assert((function() return uv_tab?.x end)() == 1)

  local uvcf1, uvcf2, uvcf3
  do
    local uvc_nil = NIL
    local uvc_null = NULL
    local uvc_tab = { x = 1 }

    uvcf1 = function() return uvc_nil?.x end
    uvcf2 = function() return uvc_null?.x end
    uvcf3 = function() return uvc_tab?.x end
  end
  assert(uvcf1() == nil)
  assert(uvcf2() == nil)
  assert(uvcf3() == 1)

  assert(NIL?.x == nil)
  assert(NULL?.x == nil)
  assert(TAB?.x == 1)
  assert(TAB ?. x == 1)

  assert(NIL?.["x"] == nil)
  assert(NULL?.["x"] == nil)
  assert(TAB?.["x"] == 1)

  assert(NIL?.[STRX] == nil)
  assert(NULL?.[STRX] == nil)
  assert(TAB?.[STRX] == 1)

  assert(NIL?.[1] == nil)
  assert(NULL?.[1] == nil)
  assert(TAB?.[1] == 9)
  assert(TAB ?. [1] == 9)

  local function fnil() return NIL end
  assert(fnil()?.x == nil)
  assert(fnil()?.[STRX] == nil)

  local function ftab() return TAB end
  assert(ftab()?.x == 1)
  assert(ftab()?.[STRX] == 1)
end

-- Safe navigation operator: false is not nil.
do
  debug.setmetatable(false, {
    __index = function(t, k) if t == false then return k end end,
  })

    assert((false)?.x == "x")

    local local_false = FALSE
    assert(local_false?.x == "x")

    local uv_false = FALSE
    assert((function() return uv_false?.x end)() == "x")

    local uvcf
    do
      local uvc_false = FALSE
      uvcf = function() return uvc_false?.x end
    end
    assert(uvcf() == "x")

    assert(FALSE?.x == "x")

  debug.setmetatable(false, nil)
end

-- Safe navigation operator: chaining.
do
  local local_tab = { y = { z = 2 }, v = "y" }
  assert(local_tab?.y.z == 2)
  assert(local_tab.y?.z == 2)
  assert(local_tab?.y?.z == 2)
  assert(local_tab?.[local_tab?.v]?.z == 2)
  assert(local_tab.NOKEY?.z == nil)
  assert(local_tab?.NOKEY?.z == nil)

  assert(TAB?.y.z == 2)
  assert(TAB.y?.z == 2)
  assert(TAB?.y?.z == 2)
  assert(TAB?.[TAB?.v]?.z == 2)
  assert(TAB.NOKEY?.z == nil)
  assert(TAB?.NOKEY?.z == nil)
end

-- Safe navigation operator: call syntax.
do
  assert(NIL?.() == nil)
  assert(NULL?.() == nil)

  assert(NIL?.x() == nil)
  assert(NIL?.x?.() == nil)

  local f = TAB.f
  assert(f?.(10) == 12)

  assert((TAB.f)?.(10) == 12)
  assert(TAB.f?.(10) == 12)
  assert(TAB?.f?.(10) == 12)
  assert(TAB.NOKEY?.(10) == nil)
  assert(TAB?.NOKEY?.(10) == nil)
  assert(TAB ?. f ?. (10) == 12)

  assert(TAB:m?.(10) == 15)
  assert(TAB?.:m(10) == 15)
  assert(TAB?.:m?.(10) == 15)
  assert(TAB:NOKEY?.(10) == nil)
  assert(TAB?.:NOKEY?.(10) == nil)
  assert(TAB ?. : m ?. (10) == 15)

  assert(NIL?."" == nil)
  local fs = function(s) return s.."y" end
  assert(fs?."x" == "xy")

  assert(NIL?.{} == nil)
  local ft = function(t) return t.x + 2 end
  assert(ft?.{ x = 10 } == 12)

  assert(("abcd")?.:sub(2, 3) == "bc")
end

-- Safe navigation operator: assignment.
do
  NIL?.v = 9
  NULL?.v = 9

  NIL?.v += 9
  NULL?.v += 9

  TAB.v = 5
    TAB?.v = 9
    assert(TAB.v == 9)

    TAB?.v += 3
    assert(TAB.v == 12)
  TAB.v = nil
end

-- Safe navigation operator: short-circuiting.
do
  local function bad() error("call short-circuiting failed", 2) end
  assert(NIL?.[bad()] == nil)
  assert(NIL?.f(bad()) == nil)
  NIL?.[bad()] = 1
  NIL?.x = bad()
  assert(TAB?.NOKEY?.[bad()] == nil)
  assert(TAB?.NOKEY?.(bad()) == nil)

  local t = setmetatable({}, {
    __index = function() error("access short-circuiting failed", 2) end,
  })
  assert(NIL?.[t.x] == nil)
  assert(NIL?.f(t.x) == nil)

  local ok, err = pcall(function() return FALSE?.[bad()] end)
  assert(err:match("call"))
end

-- Safe navigation operator: multiple return values.
do
  local function f() return 42, 99 end
  local a, b = f?.()
  assert(a == 42 and b == 99)
  local y, a, b = 11, f?.()
  assert(y == 11 and a == 42 and b == 99)

  do local a, b, c, d, e = 1, 2, 3, 4, 5 end
  local a, b = NIL?.()
  assert(a == nil and b == nil)
  local y, a, b = 11, NIL?.()
  assert(y == 11 and a == nil and b == nil)

  local obj = { method = function(self) return 42, 99 end }
  local a, b = obj?.:method()
  assert(a == 42 and b == 99)
  local y, a, b = 11, obj?.:method()
  assert(y == 11 and a == 42 and b == 99)

  do local a, b, c, d, e = 1, 2, 3, 4, 5 end
  local a, b = obj?.:NOMETHOD?.()
  assert(a == nil and b == nil)
  local y, a, b = 11, obj?.:NOMETHOD?.()
  assert(y == 11 and a == nil and b == nil)
end

-- Safe navigation operator: forced single return value.
do
  local function f() return 1, 2 end
  local function g(...) return ... end
  local a, b = g(f?.())
  assert(a == 1 and b == nil)

  local t = { f?.() }
  assert(#t == 1 and t[1] == 1 and t[2] == nil)
end

-- Safe navigation operator: syntax errors.
do
  expect_err("?.", "near.*%?%.")
  expect_err("a?.", "near.*eof")
  expect_err("a?.=", "near.*=")
  expect_err("a?.b", "near.*eof")
  expect_err("a?.b=", "near.*eof")
  expect_err("a()?.b", "near.*eof")
  expect_err("a()?.b=", "near.*eof")
  expect_err("a?.[", "near.*eof")
  expect_err("a?.(", "near.*eof")
  expect_err("a?.\"", "near.*eof")
  expect_err("a?.{", "near.*eof")

  expect_err("a?.b, c = 1, 2", "near.*,")
  expect_err("a, b?.c = 1, 2", "near.*%?%.")

  expect_err("y = a?.5:1", "name.*expected")
  assert((NIL ? .5 : 1) == 1)
end

NULL = nil
FALSE = nil
STRX = nil
TAB = nil
]]
