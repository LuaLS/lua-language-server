---@meta

---@class utf8
---@field charpattern string
utf8 = {}

---@param code integer
---@vararg integer
---@return string
function utf8.char(code, ...) end

---@param s string
---@param lax boolean?
---@return fun():integer, integer
function utf8.codes(s, lax) end

---@param s string
---@param i integer?
---@param j integer?
---@param lax boolean?
---@return integer code
---@return ...
function utf8.codepoint(s, i, j, lax) end

---@param s string
---@param i integer?
---@param j integer?
---@param lax boolean?
---@return integer?
---@return integer errpos?
function utf8.len(s, i, j, lax) end

---@param s string
---@param n integer
---@param i integer
---@return integer p
function utf8.offset(s, n, i) end

return utf8
