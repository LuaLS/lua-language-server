return [[

-- Numbers with underscores: parser.
do
  assert(1_234 == 1234)
  assert(1_ == 1)
  assert(0_ == 0)
  assert(0_1 == 1)
  assert(1_2_3__4__ == 1234)
  assert(0x1_2 == 18)
  assert(0__x__1__2__ == 18)
  assert(0__b__1__0__ == 2)
end

-- Numbers with underscores: rejected by tonumber.
do
  assert(not tonumber("1_2"))
  assert(not tonumber("0_x2"))
  assert(not tonumber("0x_2"))
  assert(not tonumber("0x2_"))
end
]]
