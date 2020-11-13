---@class string
string = {}

---@param s string
---@param i integer?
---@param j integer?
---@return integer
---@return ...
function string.byte(s, i, j) end

---@param byte integer
---@vararg integer
---@return string
---@return ...
function string.char(byte, ...) end

---@param f function
---@param strip boolean?
---@return string
function string.dump(f, strip) end

---@param s string
---@param pattern string
---@param init integer?
---@param plain boolean?
---@return integer start
---@return integer end
---@return ... captured
function string.find(s, pattern, init, plain) end

---@param s string
---@vararg string
---@return string
function string.format(s, ...) end

---@param s string
---@param pattern string
---@param init integer?
---@return fun():string, ...
function string.gmatch(s, pattern, init) end

---@param s string
---@param pattern string
---@param repl string|table|function
---@param n integer
---@return string
---@return integer count
function string.gsub(s, pattern, repl, n) end

---@param s string
---@return integer
function string.len(s) end

---@param s string
---@return string
function string.lower(s) end

---@param s string
---@param pattern string
---@param init integer?
---@return string captured
function string.match(s, pattern, init) end

---@param fmt string
---@param v1 string
---@param v2 string?
---@vararg string
---@return string binary
function string.pack(fmt, v1, v2, ...) end

---@param fmt string
---@return integer
function string.packsize(fmt) end

---@param s string
---@param n integer
---@param sep string?
---@return string
function string.rep(s, n, sep) end

---@param s string
---@return string
function string.reverse(s) end

---@param s string
---@param i integer
---@param j integer?
---@return string
function string.sub(s, i, j) end

---@param fmt string
---@param s string
---@param pos integer?
---@return ...
---@return integer offset
function string.unpack(fmt, s, pos) end

---@param s string
---@return string
function string.upper(s) end
