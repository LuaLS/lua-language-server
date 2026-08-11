return [[
-- Adapted from bit operations library tests.
local xbit = {
  bnot = function(a) return ~a end,
  band = function(a, b) return a & b end,
  bor = function(a, b) return a | b end,
  bxor = function(a, b) return a ~ b end,
  lshift = function(a, b) return a << b end,
  rshift = function(a, b) return a >> b end,
  arshift = function(a, b) return a ~>> b end,
}

local vb = {
  0, 1, -1, 2, -2, 0x12345678, 0x87654321,
  0x33333333, 0x77777777, 0x55aa55aa, 0xaa55aa55,
  0x7fffffff, 0x80000000, 0xffffffff
}

local function cksum(name, s, r)
  local z = 0
  for i=1,#s do z = (z + string.byte(s, i)*i) % 2147483629 end
  if z ~= r then
    error("bit."..name.." test failed (got "..z..", expected "..r..")", 0)
  end
end

local function check_unop(name, r)
  local f = xbit[name]
  local s = ""
  if pcall(f) or pcall(f, "z") or pcall(f, true) then
    error("bit."..name.." fails to detect argument errors", 0)
  end
  for _,x in ipairs(vb) do s = s..","..tostring(f(x)) end
  cksum(name, s, r)
end

local function check_binop(name, r)
  local f = xbit[name]
  local s = ""
  if pcall(f) or pcall(f, "z") or pcall(f, true) then
    error("bit."..name.." fails to detect argument errors", 0)
  end
  for _,x in ipairs(vb) do
    for _,y in ipairs(vb) do s = s..","..tostring(f(x, y)) end
  end
  cksum(name, s, r)
end

local function check_binop_range(name, r, yb, ye)
  local f = xbit[name]
  local s = ""
  if pcall(f) or pcall(f, "z") or pcall(f, true) or pcall(f, 1, true) then
    error("bit."..name.." fails to detect argument errors", 0)
  end
  for _,x in ipairs(vb) do
    for y=yb,ye do s = s..","..tostring(f(x, y)) end
  end
  cksum(name, s, r)
end

local function check_shift(name, r)
  check_binop_range(name, r, 0, 31)
end

-- Bit operators: minimal sanity checks.
do
  assert(0x7fffffff == 2147483647, "broken hex literals")
  assert(0xffffffff == -1 or 0xffffffff == 2^32-1, "broken hex literals")
  assert(tostring(-1) == "-1", "broken tostring()")
  assert(tostring(0xffffffff) == "-1" or tostring(0xffffffff) == "4294967295", "broken tostring()")
end

-- Bit operators: basic argument processing.
do
  assert(xbit.bxor(1,2) == 3)
end

-- Bit operators: computed value.
do
  check_unop("bnot", 287870)

  check_binop("band", 41206764)
  check_binop("bor", 51253663)
  check_binop("bxor", 79322427)

  check_shift("lshift", 325260344)
  check_shift("rshift", 139061800)
  check_shift("arshift", 111364720)
end
]]
