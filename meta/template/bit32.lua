---#if VERSION ~= 5.2 then DISABLE() end
---@meta bit32

---@version 5.2
---#DES 'bit32'
---@class bit32lib
bit32 = {}

---#DES 'bit32.arshift'
---@param x    integer
---@param disp integer
---@return integer
---@nodiscard
function bit32.arshift(x, disp) end

---#DES 'bit32.band'
---@return integer
---@nodiscard
function bit32.band(...) end

---#DES 'bit32.bnot'
---@param x integer
---@return integer
---@nodiscard
function bit32.bnot(x) end

---#DES 'bit32.bor'
---@return integer
---@nodiscard
function bit32.bor(...) end

---#DES 'bit32.btest'
---@return boolean
---@nodiscard
function bit32.btest(...) end

---#DES 'bit32.bxor'
---@return integer
---@nodiscard
function bit32.bxor(...) end

---#DES 'bit32.extract'
---@param n      integer
---@param field  integer
---@param width? integer
---@return integer
---@nodiscard
function bit32.extract(n, field, width) end

---#DES 'bit32.replace'
---@param n integer
---@param v integer
---@param field  integer
---@param width? integer
---@nodiscard
function bit32.replace(n, v, field, width) end

---#DES 'bit32.lrotate'
---@param x     integer
---@param distp integer
---@return integer
---@nodiscard
function bit32.lrotate(x, distp) end

---#DES 'bit32.lshift'
---@param x     integer
---@param distp integer
---@return integer
---@nodiscard
function bit32.lshift(x, distp) end

---#DES 'bit32.rrotate'
---@param x     integer
---@param distp integer
---@return integer
---@nodiscard
function bit32.rrotate(x, distp) end

---#DES 'bit32.rshift'
---@param x     integer
---@param distp integer
---@return integer
---@nodiscard
function bit32.rshift(x, distp) end

return bit32
