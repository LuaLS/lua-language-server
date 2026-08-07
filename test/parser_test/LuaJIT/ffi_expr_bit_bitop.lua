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
  0LL, 1LL, -1LL, 2LL, -2LL,
  0x123456789abcdef0LL, 0x0fedcba987654321LL,
  0x33333333LL, 0x77777777LL, 0x55aa55aaLL, 0xaa55aa55LL,
  0x7fffffffLL, 0x80000000LL, 0xffffffffLL,
  0x3333333333333333LL, 0x7777777777777777LL,
  0x55aa55aa55aa55aaLL, 0xaa55aa55aa55aa55LL,
  0x7fffffffffffffffLL, 0x8000000000000000LL, 0xffffffffffffffffLL,
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

-- FFI bit operators: computed value.
do
  check_unop("bnot", 2562401)

  check_binop("band", 691178007)
  check_binop("bor", 1218205008)
  check_binop("bxor", 1616063830)

  check_shift("lshift", 722026261)
  check_shift("rshift", 1938929707)
  check_shift("arshift", 1443445799)
end
]]
