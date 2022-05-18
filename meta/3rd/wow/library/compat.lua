---@meta
---@diagnostic disable: deprecated

---[Documentation](https://wowpedia.fandom.com/wiki/API_foreach)
---@param tbl table
---@param func function
function table.foreach(tbl, func) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_foreachi)
---@param tbl table
---@param func function
function table.foreachi(tbl, func) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_getn)
---@param tbl table
---@return number size
function table.getn(tbl) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_wipe)
---@param tbl table
---@return table
function table.wipe(tbl) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_strtrim)
---@param str string
---@param chars? string
---@return string
function strtrim(str, chars) end

---@param delimiter string
---@param str string
---@param pieces? number
---@return ...
function strsplit(delimiter, str, pieces) end

---@param delimiter string
---@param str string
---@param pieces? number
---@return string[] chunks
function strsplittable(delimiter, str, pieces) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_strjoin)
---@param delim string
---@param str1 string
---@param str2 string
---@vararg string
---@return string
function strjoin(delim, str1, str2, ...) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_difftime)
---@param time1 number
---@param time2 number
---@return number
function difftime(time1, time2) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_fastrandom)
---@param lower? number
---@param upper? number
---@return number
function fastrandom(lower, upper) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_gcinfo)
---@return number memoryInUse
function gcinfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_newproxy)
---@param bool boolean
---@return userdata
---@overload fun(otherproxy: userdata): userdata
function newproxy(bool) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_strcmputf8i)
---@param str1 string
---@param str2 string
---@return string
function strcmputf8i(str1, str2) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_strconcat)
---@vararg string
---@return string
function strconcat(...) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_strlenutf8)
---@param str string
---@return number
function strlenutf8(str) end

bit = {}

--- Returns the one's complement of `a`
---@param a number
---@return number
function bit.bnot(a) end

--- Returns the bitwise "AND" of the values
---@param a1 number
---@vararg number
---@return number
function bit.band(a1, ...) end

--- Returns the bitwise "OR" of the values
---@param a1 number
---@vararg number
---@return number
function bit.bor(a1, ...) end

--- Returns the bitwise "exclusive OR" of the values
---@param a1 number
---@vararg number
---@return number
function bit.bxor(a1, ...) end

--- Returns `a` logical shifted left by `n` bits
---@param a number
---@param n number
---@return number
function bit.lshift(a, n) end

--- Returns `a` logical shifted right by `n` bits
---@param a number
---@param n number
---@return number
function bit.rshift(a, n) end

--- Returns `a` arithmetically shifted right by `n` bits
---@param a number
---@param n number
---@return number
function bit.arshift(a, n) end

--- Returns the signed value of `a` modulo `n`
---@param a number
---@param n number
---@return number
function bit.mod(a, n) end

-- os.date
date = os.date

-- os.time
time = os.time

-- Table library
local tab = table
foreach = tab.foreach
foreachi = tab.foreachi
getn = tab.getn
tinsert = tab.insert
tremove = tab.remove
sort = tab.sort
wipe = tab.wipe

-------------------------------------------------------------------
-- math library
local math = math
abs = math.abs
acos = function (x) return math.deg(math.acos(x)) end
asin = function (x) return math.deg(math.asin(x)) end
atan = function (x) return math.deg(math.atan(x)) end
atan2 = function (x,y) return math.deg(math.atan2(x,y)) end
ceil = math.ceil
cos = function (x) return math.cos(math.rad(x)) end
deg = math.deg
exp = math.exp
floor = math.floor
frexp = math.frexp
ldexp = math.ldexp
log = math.log
log10 = math.log10
max = math.max
min = math.min
mod = math.fmod
PI = math.pi
--pow = math.pow
rad = math.rad
random = math.random
sin = function (x) return math.sin(math.rad(x)) end
sqrt = math.sqrt
tan = function (x) return math.tan(math.rad(x)) end

-------------------------------------------------------------------
-- string library
local str = string
strbyte = str.byte
strchar = str.char
strfind = str.find
format = str.format
gmatch = str.gmatch
gsub = str.gsub
strlen = str.len
strlower = str.lower
strmatch = str.match
strrep = str.rep
strrev = str.reverse
strsub = str.sub
strupper = str.upper
-------------------------------------------------------------------
-- Add custom string functions to the string table
str.trim = strtrim
str.split = strsplit
str.join = strjoin
