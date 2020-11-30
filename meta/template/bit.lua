---@meta

---@version JIT
---@class bit*
local bit = {}

---@param x integer
---@return integer y
function bit.tobit(x) end

---@param x  integer
---@param n? integer
---@return integer y
function bit.tohex(x, n) end

---@param x integer
---@return integer y
function bit.bnot(x) end

---@param x  integer
---@param x2 integer
---@vararg integer
---@return integer y
function bit.bor(x, x2, ...) end

---@param x  integer
---@param x2 integer
---@vararg integer
---@return integer y
function bit.band(x, x2, ...) end

---@param x  integer
---@param x2 integer
---@vararg integer
---@return integer y
function bit.bxor(x, x2, ...) end

---@param x integer
---@param n integer
---@return integer y
function bit.lshift(x, n) end

---@param x integer
---@param n integer
---@return integer y
function bit.rshift(x, n) end

---@param x integer
---@param n integer
---@return integer y
function bit.arshift(x, n) end

---@param x integer
---@param n integer
---@return integer y
function bit.rol(x, n) end

---@param x integer
---@param n integer
---@return integer y
function bit.ror(x, n) end

---@param x integer
---@return integer y
function bit.bswap(x) end

return bit
