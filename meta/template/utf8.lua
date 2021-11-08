---#if VERSION <= 5.2 then DISABLE() end
---@meta

---@version >5.3
---#DES 'utf8'
---@class utf8lib
---#DES 'utf8.charpattern'
---@field charpattern string
utf8 = {}

---#DES 'utf8.char'
---@param code integer
---@param ... integer
---@return string
---@nodiscard
function utf8.char(code, ...) end

---#DES 'utf8.codes'
---#if VERSION <= 5.3 then
---@param s    string
---@return fun():integer, integer
function utf8.codes(s) end
---#else
---@param s    string
---@param lax? boolean
---@return fun():integer, integer
function utf8.codes(s, lax) end
---#end

---#DES 'utf8.codepoint'
---#if VERSION <= 5.3 then
---@param s    string
---@param i?   integer
---@param j?   integer
---@return integer code
---@return ...
---@nodiscard
function utf8.codepoint(s, i, j) end
---#else
---@param s    string
---@param i?   integer
---@param j?   integer
---@param lax? boolean
---@return integer code
---@return ...
---@nodiscard
function utf8.codepoint(s, i, j, lax) end
---#end

---#DES 'utf8.len'
---#if VERSION <= 5.3 then
---@param s    string
---@param i?   integer
---@param j?   integer
---@return integer?
---@return integer? errpos
---@nodiscard
function utf8.len(s, i, j) end
---#else
---@param s    string
---@param i?   integer
---@param j?   integer
---@param lax? boolean
---@return integer?
---@return integer? errpos
---@nodiscard
function utf8.len(s, i, j, lax) end
---#end

---#DES 'utf8.offset'
---@param s string
---@param n integer
---@param i integer
---@return integer p
---@nodiscard
function utf8.offset(s, n, i) end

return utf8
