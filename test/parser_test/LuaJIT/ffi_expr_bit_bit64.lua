return [[

-- FFI bit operators: JIT logical ops.
do
  local a = 0x123456789abcdef0LL
  local y1, y2, y3, y4, y5, y6
  for i=1,100 do
    y1 = a & 0x000000005a5a5a5aLL
    y2 = a & 0x5a5a5a5a00000000LL
    y3 = a & 0xffffffff5a5a5a5aLL
    y4 = a & 0x5a5a5a5affffffffLL
    y5 = a & 0xffffffff00000000LL
    y6 = a & 0x00000000ffffffffLL
  end
  assert(y1 == 0x000000001a185a50LL)
  assert(y2 == 0x1210525800000000LL)
  assert(y3 == 0x123456781a185a50LL)
  assert(y4 == 0x121052589abcdef0LL)
  assert(y5 == 0x1234567800000000LL)
  assert(y6 == 0x000000009abcdef0LL)

  for i=1,100 do
    y1 = a | 0x000000005a5a5a5aLL
    y2 = a | 0x5a5a5a5a00000000LL
    y3 = a | 0xffffffff5a5a5a5aLL
    y4 = a | 0x5a5a5a5affffffffLL
    y5 = a | 0xffffffff00000000LL
    y6 = a | 0x00000000ffffffffLL
  end
  assert(y1 == 0x12345678dafedefaLL)
  assert(y2 == 0x5a7e5e7a9abcdef0LL)
  assert(y3 == 0xffffffffdafedefaLL)
  assert(y4 == 0x5a7e5e7affffffffLL)
  assert(y5 == 0xffffffff9abcdef0LL)
  assert(y6 == 0x12345678ffffffffLL)

  for i=1,100 do
    y1 = a ~ 0x000000005a5a5a5aLL
    y2 = a ~ 0x5a5a5a5a00000000LL
    y3 = a ~ 0xffffffff5a5a5a5aLL
    y4 = a ~ 0x5a5a5a5affffffffLL
    y5 = a ~ 0xffffffff00000000LL
    y6 = a ~ 0x00000000ffffffffLL
  end
  assert(y1 == 0x12345678c0e684aaLL)
  assert(y2 == 0x486e0c229abcdef0LL)
  assert(y3 == 0xedcba987c0e684aaLL)
  assert(y4 == 0x486e0c226543210fLL)
  assert(y5 == 0xedcba9879abcdef0LL)
  assert(y6 == 0x123456786543210fLL)
end

-- FFI bit operators: JIT shift and logical ops.
do
  local a, b = 0x123456789abcdef0LL, 0x31415926535898LL
  for i=1,200 do
    a = a ~ b; b = (b ~>> 14) + (b << 50)
    a = a - b; b = (b << 5) + (b ~>> 59)
    b = a ~ b; b = b - (b << 13) - (b >> 51)
  end
  assert(b == -7993764627526027113LL)
end
]]
