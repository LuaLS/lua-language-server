---@meta math

---#DES 'math'
---@class mathlib
---#DES 'math.huge'
---@field huge       number
---#if VERSION >= 5.3 then
---#DES 'math.maxinteger'
---@field maxinteger integer
---#DES 'math.mininteger'
---@field mininteger integer
---#end
---#DES 'math.pi'
---@field pi         number
math = {}

---#DES 'math.abs'
---@generic Number: number
---@param x Number
---@return Number
---@nodiscard
function math.abs(x) end

---#DES 'math.acos'
---@param x number
---@return number
---@nodiscard
function math.acos(x) end

---#DES 'math.asin'
---@param x number
---@return number
---@nodiscard
function math.asin(x) end

---#if VERSION <= 5.2 then
---#DES 'math.atan<5.2'
---@param y number
---@return number
---@nodiscard
function math.atan(y) end
---#else
---#DES 'math.atan>5.3'
---@param y  number
---@param x? number
---@return number
---@nodiscard
function math.atan(y, x) end
---#end

---@version <5.2
---#DES 'math.atan2'
---@param y number
---@param x number
---@return number
---@nodiscard
function math.atan2(y, x) end

---#DES 'math.ceil'
---@param x number
---@return integer
---@nodiscard
function math.ceil(x) end

---#DES 'math.cos'
---@param x number
---@return number
---@nodiscard
function math.cos(x) end

---@version <5.2
---#DES 'math.cosh'
---@param x number
---@return number
---@nodiscard
function math.cosh(x) end

---#DES 'math.deg'
---@param x number
---@return number
---@nodiscard
function math.deg(x) end

---#DES 'math.exp'
---@param x number
---@return number
---@nodiscard
function math.exp(x) end

---#DES 'math.floor'
---@param x number
---@return integer
---@nodiscard
function math.floor(x) end

---#DES 'math.fmod'
---@param x number
---@param y number
---@return number
---@nodiscard
function math.fmod(x, y) end

---@version <5.2
---#DES 'math.frexp'
---@param x number
---@return number m
---@return number e
---@nodiscard
function math.frexp(x) end

---@version <5.2
---#DES 'math.ldexp'
---@param m number
---@param e number
---@return number
---@nodiscard
function math.ldexp(m, e) end

---#if VERSION <= 5.1 and not JIT then
---#DES 'math.log<5.1'
---@param x     number
---@return number
---@nodiscard
function math.log(x) end
---#else
---#DES 'math.log>5.2'
---@param x     number
---@param base? integer
---@return number
---@nodiscard
function math.log(x, base) end
---#end

---@version <5.1
---#DES 'math.log10'
---@param x number
---@return number
---@nodiscard
function math.log10(x) end

---#DES 'math.max'
---@generic Number: number
---@param x Number
---@param ... Number
---@return Number
---@nodiscard
function math.max(x, ...) end

---#DES 'math.min'
---@generic Number: number
---@param x Number
---@param ... Number
---@return Number
---@nodiscard
function math.min(x, ...) end

---#DES 'math.modf'
---@param x number
---@return integer
---@return number
---@nodiscard
function math.modf(x) end

---@version <5.2
---#DES 'math.pow'
---@param x number
---@param y number
---@return number
---@nodiscard
function math.pow(x, y) end

---#DES 'math.rad'
---@param x number
---@return number
---@nodiscard
function math.rad(x) end

---#DES 'math.random'
---@overload fun():number
---@overload fun(m: integer):integer
---@param m integer
---@param n integer
---@return integer
---@nodiscard
function math.random(m, n) end

---#if VERSION >= 5.4 then
---#DES 'math.randomseed>5.4'
---@param x? integer
---@param y? integer
function math.randomseed(x, y) end
---#else
---#DES 'math.randomseed<5.3'
---@param x integer
function math.randomseed(x) end
---#end

---#DES 'math.sin'
---@param x number
---@return number
---@nodiscard
function math.sin(x) end

---@version <5.2
---#DES 'math.sinh'
---@param x number
---@return number
---@nodiscard
function math.sinh(x) end

---#DES 'math.sqrt'
---@param x number
---@return number
---@nodiscard
function math.sqrt(x) end

---#DES 'math.tan'
---@param x number
---@return number
---@nodiscard
function math.tan(x) end

---@version <5.2
---#DES 'math.tanh'
---@param x number
---@return number
---@nodiscard
function math.tanh(x) end

---@version >5.3
---#DES 'math.tointeger'
---@param x any
---@return integer?
---@nodiscard
function math.tointeger(x) end

---@version >5.3
---#DES 'math.type'
---@param x any
---@return
---| '"integer"'
---| '"float"'
---| 'nil'
---@nodiscard
function math.type(x) end

---@version >5.3
---#DES 'math.ult'
---@param m integer
---@param n integer
---@return boolean
---@nodiscard
function math.ult(m, n) end

return math
