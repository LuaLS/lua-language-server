---@class math
---@field huge       number
---@field maxinteger integer
---@field mininteger integer
---@field pi         number
math = {}

---@param x number
---@return number
function math.abs(x) end

---@param x number
---@return number
function math.acos(x) end

---@param x number
---@return number
function math.asin(x) end

---@param y number
---@param x number
---@return number
function math.atan(y, x) end

---@param y number
---@param x number
---@return number

---@param y any
---@param x any
function math.atan2(y, x) end

---@param x number
---@return integer
function math.ceil(x) end

---@param x number
function math.cos(x) end

---@param x number
---@return number
function math.cosh(x) end

---@param x number
---@return number
function math.deg(x) end

---@param x number
---@return number
function math.exp(x) end

---@param x number
---@return number
function math.floor(x) end

---@param x number
---@param y number
---@return number
function math.fmod(x, y) end

---@param x number
---@return number m
---@return number e
function math.frexp(x) end

---@param m number
---@param e number
---@return number
function math.ldexp(m, e) end

---@param x number
---@param base integer?
---@return number
function math.log(x, base) end

---@param x number
---@return number
function math.log10(x) end

---@param x number
---@vararg number
---@return number
function math.max(x, ...) end

---@param x number
---@vararg number
---@return number
function math.min(x, ...) end

---@param x number
---@return integer
---@return number
function math.modf(x) end

---@param x number
---@param y number
---@return number
function math.pow(x, y) end

---@param x number
---@return number
function math.rad(x) end

---@overload fun():number
---@overload fun(m: integer):integer
---@param m integer
---@param n integer
---@return integer
function math.random(m, n) end

---@param x integer?
---@param y integer?
function math.randomseed(x, y) end

---@param x number
---@return number
function math.sin(x) end

---@param x number
---@return number
function math.sinh(x) end

---@param x number
---@return number
function math.sqrt(x) end

---@param x number
---@return number
function math.tan(x) end

---@param x number
---@return number
function math.tanh(x) end

---@param x number
---@return integer?
function math.tointeger(x) end

---@param x any
---@return
---| '"integer"'
---| '"float"'
---| 'nil'
function math.type(x) end

---@param m integer
---@param n integer
---@return boolean
function math.ult(m, n) end
