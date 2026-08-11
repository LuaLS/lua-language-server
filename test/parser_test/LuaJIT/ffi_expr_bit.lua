return [[

local N = setmetatable({}, { __index = function(_, x) return x end })

-- FFI bit operators: syntax.
do
  assert(~ N[0b1010LL] == 0xfffffffffffffff5LL)
  assert(~ N[0b1010ULL] == 0xfffffffffffffff5ULL)

  assert(N[0x1122334455667788LL] & N[0x5a5a5a5a5a5a5a5aLL] == 0x1002124050425208LL)
  assert(N[0x1122334455667788LL] | N[0x5a5a5a5a5a5a5a5aLL] == 0x5b7a7b5e5f7e7fdaLL)
  assert(N[0x1122334455667788LL] ~ N[0x5a5a5a5a5a5a5a5aLL] == 0x4b78691e0f3c2dd2LL)

  assert(N[0x55aa55aa55aa55aaLL] << N[4] == 0x5aa55aa55aa55aa0LL)
  assert(N[0x55aa55aa55aa55aaLL] >> N[4] == 0x055aa55aa55aa55aLL)
  assert(N[0x55aa55aa55aa55aaLL] ~>> N[4] == 0x055aa55aa55aa55aLL)
  assert(N[0xaa55aa55aa55aa55LL] >> N[4] == 0x0aa55aa55aa55aa5LL)
  assert(N[0xaa55aa55aa55aa55LL] ~>> N[4] == 0xfaa55aa55aa55aa5LL)

  assert(N[0x55aa55aa55aa55aaLL] << N[36] == 0x5aa55aa000000000LL)
  assert(N[0x55aa55aa55aa55aaLL] >> N[36] == 0x00000000055aa55aLL)
  assert(N[0x55aa55aa55aa55aaLL] ~>> N[36] == 0x00000000055aa55aLL)
  assert(N[0xaa55aa55aa55aa55LL] >> N[36] == 0x000000000aa55aa5LL)
  assert(N[0xaa55aa55aa55aa55LL] ~>> N[36] == 0xfffffffffaa55aa5LL)
end

-- FFI bit operators: constant folding.
do
  assert(~ 0b1010LL == 0xfffffffffffffff5LL)
  assert(~ 0b1010ULL == 0xfffffffffffffff5ULL)

  assert(0x1122334455667788LL & 0x5a5a5a5a5a5a5a5aLL == 0x1002124050425208LL)
  assert(0x1122334455667788LL | 0x5a5a5a5a5a5a5a5aLL == 0x5b7a7b5e5f7e7fdaLL)
  assert(0x1122334455667788LL ~ 0x5a5a5a5a5a5a5a5aLL == 0x4b78691e0f3c2dd2LL)

  assert(0x55aa55aa55aa55aaLL << 4 == 0x5aa55aa55aa55aa0LL)
  assert(0x55aa55aa55aa55aaLL >> 4 == 0x055aa55aa55aa55aLL)
  assert(0x55aa55aa55aa55aaLL ~>> 4 == 0x055aa55aa55aa55aLL)
  assert(0xaa55aa55aa55aa55LL >> 4 == 0x0aa55aa55aa55aa5LL)
  assert(0xaa55aa55aa55aa55LL ~>> 4 == 0xfaa55aa55aa55aa5LL)

  assert(0x55aa55aa55aa55aaLL << 36 == 0x5aa55aa000000000LL)
  assert(0x55aa55aa55aa55aaLL >> 36 == 0x00000000055aa55aLL)
  assert(0x55aa55aa55aa55aaLL ~>> 36 == 0x00000000055aa55aLL)
  assert(0xaa55aa55aa55aa55LL >> 36 == 0x000000000aa55aa5LL)
  assert(0xaa55aa55aa55aa55LL ~>> 36 == 0xfffffffffaa55aa5LL)
end

-- FFI bit operators: coercion.
do
  assert((N[0x55aa55aa] | N[0LL]) << N[4] == 0x000000055aa55aa0LL)
  assert(N[0x55aa55aa] << N[4LL] == 0x5aa55aa0)

  assert((N[-1LL] | N[0ULL]) > 0LL)
  assert((N[-1LL] << N[4ULL]) < 0LL)
end

-- FFI bit operators: shift width masking.
do
  assert(N[0x55aa55aa55aa55aaLL] << N[64] == 0x55aa55aa55aa55aaLL)
  assert(N[0x55aa55aa55aa55aaLL] >> N[64] == 0x55aa55aa55aa55aaLL)
  assert(N[0x55aa55aa55aa55aaLL] ~>> N[64] == 0x55aa55aa55aa55aaLL)
  assert(N[0xaa55aa55aa55aa55LL] ~>> N[64] == 0xaa55aa55aa55aa55LL)

  assert(N[0x55aa55aa55aa55aaLL] << N[68] == 0x5aa55aa55aa55aa0LL)
  assert(N[0x55aa55aa55aa55aaLL] >> N[68] == 0x055aa55aa55aa55aLL)
  assert(N[0x55aa55aa55aa55aaLL] ~>> N[68] == 0x055aa55aa55aa55aLL)
  assert(N[0xaa55aa55aa55aa55LL] ~>> N[68] == 0xfaa55aa55aa55aa5LL)

  assert(N[0xaa55aa55aa55aa55LL] << N[-1] == 0x8000000000000000LL)
  assert(N[0xaa55aa55aa55aa55LL] >> N[-1] == 0x0000000000000001LL)
  assert(N[0xaa55aa55aa55aa55LL] ~>> N[-1] == 0xffffffffffffffffLL)
end
]]
