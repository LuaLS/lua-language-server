---Bitwise operations API documentation
---Lua BitOp <http://bitop.luajit.org/api.html> is a C extension module for Lua 5.1/5.2 which adds bitwise operations on numbers.
---Lua BitOp is Copyright © 2008-2012 Mike Pall.
---Lua BitOp is free software, released under the MIT license (same license as the Lua core).
---Lua BitOp is compatible with the built-in bitwise operations in LuaJIT 2.0 and is used
---on platforms where Defold runs without LuaJIT.
---For clarity the examples assume the definition of a helper function printx().
---This prints its argument as an unsigned 32 bit hexadecimal number on all platforms:
---function printx(x)
---  print("0x"..bit.tohex(x))
---end

---@class bit
bit = {}
---Returns the bitwise arithmetic right-shift of its first argument by the number of bits given by the second argument.
---Arithmetic right-shift treats the most-significant bit as a sign bit and replicates it.
---Only the lower 5 bits of the shift count are used (reduces to the range [0..31]).
---@param x number # number
---@param n number # number of bits
---@return number # bitwise arithmetic right-shifted number
function bit.arshift(x, n) end

---Returns the bitwise and of all of its arguments. Note that more than two arguments are allowed.
---@param x1 number # number
--- ... number? # number(s)
---@return number # bitwise and of the provided arguments
function bit.band(x1, ...) end

---Returns the bitwise not of its argument.
---@param x number # number
---@return number # bitwise not of number x
function bit.bnot(x) end

---Returns the bitwise or of all of its arguments. Note that more than two arguments are allowed.
---@param x1 number # number
--- ... number? # number(s)
---@return number # bitwise or of the provided arguments
function bit.bor(x1, ...) end

---Swaps the bytes of its argument and returns it. This can be used to convert little-endian 32 bit numbers to big-endian 32 bit numbers or vice versa.
---@param x number # number
---@return number # bitwise swapped number
function bit.bswap(x) end

---Returns the bitwise xor of all of its arguments. Note that more than two arguments are allowed.
---@param x1 number # number
--- ... number? # number(s)
---@return number # bitwise xor of the provided arguments
function bit.bxor(x1, ...) end

---Returns the bitwise logical left-shift of its first argument by the number of bits given by the second argument.
---Logical shifts treat the first argument as an unsigned number and shift in 0-bits.
---Only the lower 5 bits of the shift count are used (reduces to the range [0..31]).
---@param x number # number
---@param n number # number of bits
---@return number # bitwise logical left-shifted number
function bit.lshift(x, n) end

---Returns the bitwise left rotation of its first argument by the number of bits given by the second argument. Bits shifted out on one side are shifted back in on the other side.
---Only the lower 5 bits of the rotate count are used (reduces to the range [0..31]).
---@param x number # number
---@param n number # number of bits
---@return number # bitwise left-rotated number
function bit.rol(x, n) end

---Returns the bitwise right rotation of its first argument by the number of bits given by the second argument. Bits shifted out on one side are shifted back in on the other side.
---Only the lower 5 bits of the rotate count are used (reduces to the range [0..31]).
---@param x number # number
---@param n number # number of bits
---@return number # bitwise right-rotated number
function bit.ror(x, n) end

---Returns the bitwise logical right-shift of its first argument by the number of bits given by the second argument.
---Logical shifts treat the first argument as an unsigned number and shift in 0-bits.
---Only the lower 5 bits of the shift count are used (reduces to the range [0..31]).
---@param x number # number
---@param n number # number of bits
---@return number # bitwise logical right-shifted number
function bit.rshift(x, n) end

---Normalizes a number to the numeric range for bit operations and returns it. This function is usually not needed since all bit operations already normalize all of their input arguments.
---@param x number # number to normalize
---@return number # normalized number
function bit.tobit(x) end

---Converts its first argument to a hex string. The number of hex digits is given by the absolute value of the optional second argument. Positive numbers between 1 and 8 generate lowercase hex digits. Negative numbers generate uppercase hex digits. Only the least-significant 4*|n| bits are used. The default is to generate 8 lowercase hex digits.
---@param x number # number to convert
---@param n number # number of hex digits to return
---@return string # hexadecimal string
function bit.tohex(x, n) end




return bit