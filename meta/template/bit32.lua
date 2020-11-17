---@meta

---@class bit32*
bit32 = {}

---@param x integer
---@param disp integer
---@return integer
function bit32.arshift(x, disp) end

---@return integer
function bit32.band(...) end

---@param x integer
---@return integer
function bit32.bnot(x) end

---@return integer
function bit32.bor(...) end

---@return boolean
function bit32.btest(...) end

---@return integer
function bit32.bxor(...) end

---@param n integer
---@param field integer
---@param width integer?
---@return integer
function bit32.extract(n, field, width) end

---@param n integer
---@param v integer
---@param field integer
---@param width integer?
function bit32.replace(n, v, field, width) end

---@param x integer
---@param distp integer
---@return integer
function bit32.lrotate(x, distp) end

---@param x integer
---@param distp integer
---@return integer
function bit32.lshift(x, distp) end

---@param x integer
---@param distp integer
---@return integer
function bit32.rrotate(x, distp) end

---@param x integer
---@param distp integer
---@return integer
function bit32.rshift(x, distp) end

return bit32
