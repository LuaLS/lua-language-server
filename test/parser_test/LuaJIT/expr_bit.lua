return [[

local function expect_err(code, expect)
  local f, err = loadstring(code, "=")
  if f ~= nil then
    error("unexpected success", 2)
  elseif not err:match(expect) then
    error('expected "'..expect..'", but got "'..err:gsub("^:1: ", "")..'"', 2)
  end
end

local N = setmetatable({}, { __index = function(_, x) return x end })

-- Bit operators: syntax.
do
  assert(~ N[0b1010] == 0xfffffff5|0)

  assert(N[0xffffffff] | 0 == -1)

  assert(N[0b1010] & N[0b1100] == 0b1000)
  assert(N[0b1010] | N[0b1100] == 0b1110)
  assert(N[0b1010] ~ N[0b1100] == 0b0110)

  assert(N[0x55aa55aa] << N[4] == 0x5aa55aa0)
  assert(N[0x55aa55aa] >> N[4] == 0x055aa55a)
  assert(N[0x55aa55aa] ~>> N[4] == 0x055aa55a)
  assert(N[0xaa55aa55] >> N[4] == 0x0aa55aa5)
  assert(N[0xaa55aa55] ~>> N[4] == 0xfaa55aa5|0)
end

-- Bit operators: constant folding.
do
  assert(~ 0b1010 == 0xfffffff5|0)

  assert(0xffffffff | 0 == -1)

  assert(0b1010 & 0b1100 == 0b1000)
  assert(0b1010 | 0b1100 == 0b1110)
  assert(0b1010 ~ 0b1100 == 0b0110)

  assert(0x55aa55aa << 4 == 0x5aa55aa0)
  assert(0x55aa55aa >> 4 == 0x055aa55a)
  assert(0x55aa55aa ~>> 4 == 0x055aa55a)
  assert(0xaa55aa55 >> 4 == 0x0aa55aa5)
  assert(0xaa55aa55 ~>> 4 == 0xfaa55aa5|0)
end

-- Bit operators: precedence.
do
  assert(~ N[0b1010] & N[0b1100] == 0b0100)
  assert((~ N[0b1010]) & N[0b1100] == 0b0100)
  assert(~ (N[0b1010] & N[0b1100]) == -9)

  assert(~ N[0b1010] | N[0b1100] == -3)
  assert((~ N[0b1010]) | N[0b1100] == -3)
  assert(~ (N[0b1010] | N[0b1100]) == -15)

  assert(~ N[0b1010] ~ N[0b1100] == -7)
  assert((~ N[0b1010]) ~ N[0b1100] == -7)
  assert(~ (N[0b1010] ~ N[0b1100]) == -7)

  assert(~ N[0x55aa55aa] << N[4] == 0xa55aa550|0)
  assert((~ N[0x55aa55aa]) << N[4] == 0xa55aa550|0)
  assert(~ (N[0x55aa55aa] << N[4]) == 0xa55aa55f|0)

  assert(~ N[0x55aa55aa] >> N[4] == 0x0aa55aa5)
  assert((~ N[0x55aa55aa]) >> N[4] == 0x0aa55aa5)
  assert(~ (N[0x55aa55aa] >> N[4]) == 0xfaa55aa5|0)

  assert(~ N[0x55aa55aa] ~>> N[4] == 0xfaa55aa5|0)
  assert((~ N[0x55aa55aa]) ~>> N[4] == 0xfaa55aa5|0)
  assert(~ (N[0x55aa55aa] ~>> N[4]) == 0xfaa55aa5|0)

  assert(N[0b1010] & N[0b1100] ~ N[0b1101] == 0b0101)
  assert((N[0b1010] & N[0b1100]) ~ N[0b1101] == 0b0101)
  assert(N[0b1010] & (N[0b1100] ~ N[0b1101]) == 0b0000)

  assert(N[0b1010] | N[0b1100] & N[0b1101] == 0b1110)
  assert((N[0b1010] | N[0b1100]) & N[0b1101] == 0b1100)
  assert(N[0b1010] | (N[0b1100] & N[0b1101]) == 0b1110)

  assert(N[0b1010] | N[0b1100] ~ N[0b1101] == 0b1011)
  assert((N[0b1010] | N[0b1100]) ~ N[0b1101] == 0b0011)
  assert(N[0b1010] | (N[0b1100] ~ N[0b1101]) == 0b1011)

  assert(N[0x55aa55aa] >> N[3] & N[1] == 0x00000001)
  assert((N[0x55aa55aa] >> N[3]) & N[1] == 0x00000001)
  assert(N[0x55aa55aa] >> (N[3] & N[1]) == 0x2ad52ad5)

  assert(N[0b1010] | N[0b1100] + N[0b0101] == 0b11011)
  assert((N[0b1010] | N[0b1100]) + N[0b0101] == 0b10011)
  assert(N[0b1010] | (N[0b1100] + N[0b0101]) == 0b11011)
end

-- Bit operators: associativity.
do
  assert(N[0x55aa55aa] << N[4] << N[2] == 0x6a956a80)
  assert((N[0x55aa55aa] << N[4]) << N[2] == 0x6a956a80)
  assert(N[0x55aa55aa] << (N[4] << N[2]) == 0x55aa0000)

  assert(N[0x55aa55aa] >> N[4] >> N[2] == 0x0156a956)
  assert((N[0x55aa55aa] >> N[4]) >> N[2] == 0x0156a956)
  assert(N[0x55aa55aa] >> (N[4] >> N[2]) == 0x2ad52ad5)

  assert(N[0xaa55aa55] ~>> N[4] ~>> N[2] == 0xfea956a9|0)
  assert((N[0xaa55aa55] ~>> N[4]) ~>> N[2] == 0xfea956a9|0)
  assert(N[0xaa55aa55] ~>> (N[4] ~>> N[2]) == 0xd52ad52a|0)
end

-- Bit operators: shift width masking.
do
  assert(N[0x55aa55aa] << N[32] == 0x55aa55aa)
  assert(N[0x55aa55aa] >> N[32] == 0x55aa55aa)
  assert(N[0x55aa55aa] ~>> N[32] == 0x55aa55aa)
  assert(N[0xaa55aa55] ~>> N[32] == 0xaa55aa55|0)

  assert(N[0x55aa55aa] << N[36] == 0x5aa55aa0)
  assert(N[0x55aa55aa] >> N[36] == 0x055aa55a)
  assert(N[0x55aa55aa] ~>> N[36] == 0x055aa55a)
  assert(N[0xaa55aa55] ~>> N[36] == 0xfaa55aa5|0)

  assert(N[0xaa55aa55] << N[-1] == 0x80000000|0)
  assert(N[0xaa55aa55] >> N[-1] == 0x00000001)
  assert(N[0xaa55aa55] ~>> N[-1] == 0xffffffff|0)
end

-- Bit operators: metamethods.
if jit and jit.version_num >= 30000 then -- NOT backported to v2.1.
  local mt = {}
  for _,name in ipairs({"bnot", "band", "bor", "bxor", "shl", "shr", "sar"}) do
    mt["__"..name] = function() return name end
  end
  local a = setmetatable({}, mt)
  local b = setmetatable({}, mt)

  assert(~ a == "bnot")

  assert(a & 1 == "band"  and 1 & b == "band"  and a & b == "band")
  assert(a | 1 == "bor"   and 1 | b == "bor"   and a | b == "bor")
  assert(a ~ 1 == "bxor"  and 1 ~ b == "bxor"  and a ~ b == "bxor")

  assert(a << 1 == "shl"  and 1 << b == "shl"  and a << b == "shl")
  assert(a >> 1 == "shr"  and 1 >> b == "shr"  and a >> b == "shr")
  assert(a ~>> 1 == "sar" and 1 ~>> b == "sar" and a ~>> b == "sar")
end

-- Bit operators: syntax errors.
do
  expect_err("~", "near.*~")
  expect_err("~ a", "near.*~")
  expect_err("~ a = 1", "near.*~")
  expect_err("~ a += 1", "near.*~")
  expect_err("~ a()", "near.*~")

  expect_err("&", "near.*&")
  expect_err("a &", "near.*&")
  expect_err("a & b", "near.*&")
  expect_err("a & b = 1", "near.*&")
  expect_err("a & b += 1", "near.*&")
  expect_err("a() & b", "near.*&")
  expect_err("a & b()", "near.*&")

  expect_err("|", "near.*|")
  expect_err("a |", "near.*|")
  expect_err("a | b", "near.*|")
  expect_err("a | b = 1", "near.*|")
  expect_err("a | b += 1", "near.*|")
  expect_err("a() | b", "near.*|")
  expect_err("a | b()", "near.*|")

  expect_err("~", "near.*~")
  expect_err("a ~", "near.*~")
  expect_err("a ~ b", "near.*~")
  expect_err("a ~ b = 1", "near.*~")
  expect_err("a ~ b += 1", "near.*~")
  expect_err("a() ~ b", "near.*~")
  expect_err("a ~ b()", "near.*~")

  expect_err("<<", "near.*<<")
  expect_err("a <<", "near.*<<")
  expect_err("a << b", "near.*<<")
  expect_err("a << b = 1", "near.*<<")
  expect_err("a << b += 1", "near.*<<")
  expect_err("a() << b", "near.*<<")
  expect_err("a << b()", "near.*<<")

  expect_err(">>", "near.*>>")
  expect_err("a >>", "near.*>>")
  expect_err("a >> b", "near.*>>")
  expect_err("a >> b = 1", "near.*>>")
  expect_err("a >> b += 1", "near.*>>")
  expect_err("a() >> b", "near.*>>")
  expect_err("a >> b()", "near.*>>")

  expect_err("~>>", "near.*~>>")
  expect_err("a ~>>", "near.*~>>")
  expect_err("a ~>> b", "near.*~>>")
  expect_err("a ~>> b = 1", "near.*~>>")
  expect_err("a ~>> b += 1", "near.*~>>")
  expect_err("a() ~>> b", "near.*~>>")
  expect_err("a ~>> b()", "near.*~>>")
end
]]
