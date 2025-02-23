---#if not JIT then DISABLE() end
---@meta bit

---@version JIT
---@class bitlib
bit = {}

---@param x integer
---@return integer y
---@nodiscard
function bit.tobit(x) end

---@param x  integer
---@param n? integer
---@return string y
---@nodiscard
function bit.tohex(x, n) end

---@param x integer
---@return integer y
---@nodiscard
function bit.bnot(x) end

---@param x   integer
---@param ... integer
---@return integer y
---@nodiscard
function bit.bor(x, ...) end

---@param x   integer
---@param ... integer
---@return integer y
---@nodiscard
function bit.band(x, ...) end

---@param x   integer
---@param ... integer
---@return integer y
---@nodiscard
function bit.bxor(x, ...) end

---@param x integer
---@param n integer
---@return integer y
---@nodiscard
function bit.lshift(x, n) end

---@param x integer
---@param n integer
---@return integer y
---@nodiscard
function bit.rshift(x, n) end

---@param x integer
---@param n integer
---@return integer y
---@nodiscard
function bit.arshift(x, n) end

---@param x integer
---@param n integer
---@return integer y
---@nodiscard
function bit.rol(x, n) end

---@param x integer
---@param n integer
---@return integer y
---@nodiscard
function bit.ror(x, n) end

---@param x integer
---@return integer y
---@nodiscard
function bit.bswap(x) end

return bit
