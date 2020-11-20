---@meta

---#DES 'math'
---@class math*
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
---@param x number
---@return number
function math.abs(x) end

---#DES 'math.acos'
---@param x number
---@return number
function math.acos(x) end

---#DES 'math.asin'
---@param x number
---@return number
function math.asin(x) end

---#if VERSION <= 5.2 then
---#DES 'math.atan<5.2'
---@param y number
---@return number
function math.atan(y) end
---#else
---#DES 'math.atan>5.3'
---@param y  number
---@param x? number
---@return number
function math.atan(y, x) end
---#end

---@version <5.2
---#DES 'math.atan2'
---@param y number
---@param x number
---@return number
function math.atan2(y, x) end

---#DES 'math.ceil'
---@param x number
---@return integer
function math.ceil(x) end

---#DES 'math.cos'
---@param x number
function math.cos(x) end

---@version <5.2
---#DES 'math.cosh'
---@param x number
---@return number
function math.cosh(x) end

---#DES 'math.deg'
---@param x number
---@return number
function math.deg(x) end

---#DES 'math.exp'
---@param x number
---@return number
function math.exp(x) end

---#DES 'math.floor'
---@param x number
---@return number
function math.floor(x) end

---#DES 'math.fmod'
---@param x number
---@param y number
---@return number
function math.fmod(x, y) end

---@version <5.2
---#DES 'math.frexp'
---@param x number
---@return number m
---@return number e
function math.frexp(x) end

---@version <5.2
---#DES 'math.ldexp'
---@param m number
---@param e number
---@return number
function math.ldexp(m, e) end

---#if VERSION <= 5.1 then
---#DES 'math.log<5.1'
---@param x     number
---@return number
function math.log(x) end
---#else
---#DES 'math.log>5.2'
---@param x     number
---@param base? integer
---@return number
function math.log(x, base) end
---#end

---@version <5.1
---#DES 'math.log10'
---@param x number
---@return number
function math.log10(x) end

---#DES 'math.max'
---@param x number
---@vararg number
---@return number
function math.max(x, ...) end

---#DES 'math.min'
---@param x number
---@vararg number
---@return number
function math.min(x, ...) end

---#DES 'math.modf'
---@param x number
---@return integer
---@return number
function math.modf(x) end

---@version <5.2
---#DES 'math.pow'
---@param x number
---@param y number
---@return number
function math.pow(x, y) end

---#DES 'math.rad'
---@param x number
---@return number
function math.rad(x) end

---#DES 'math.random'
---@overload fun():number
---@overload fun(m: integer):integer
---@param m integer
---@param n integer
---@return integer
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
function math.sin(x) end

---@version <5.2
---#DES 'math.sinh'
---@param x number
---@return number
function math.sinh(x) end

---#DES 'math.sqrt'
---@param x number
---@return number
function math.sqrt(x) end

---#DES 'math.tan'
---@param x number
---@return number
function math.tan(x) end

---@version <5.2
---#DES 'math.tanh'
---@param x number
---@return number
function math.tanh(x) end

---@version >5.3
---#DES 'math.tointeger'
---@param x number
---@return integer?
function math.tointeger(x) end

---#DES 'math.type'
---@param x any
---@return
---| '"integer"'
---| '"float"'
---| 'nil'
function math.type(x) end

---#DES 'math.ult'
---@param m integer
---@param n integer
---@return boolean
function math.ult(m, n) end

return math
