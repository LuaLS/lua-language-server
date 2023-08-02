---@meta string

---#DES 'string'
---@class stringlib
string = {}

---#DES 'string.byte'
---@param s  string|number
---@param i? integer
---@param j? integer
---@return integer ...
---@nodiscard
function string.byte(s, i, j) end

---#DES 'string.char'
---@param byte integer
---@param ... integer
---@return string
---@nodiscard
function string.char(byte, ...) end

---#DES 'string.dump'
---#if VERSION >= 5.3 or JIT then
---@param f      async fun(...):...
---@param strip? boolean
---@return string
---@nodiscard
function string.dump(f, strip) end
---#else
---@param f      async fun(...):...
---@return string
---@nodiscard
function string.dump(f) end
---#end

---#DES 'string.find'
---@param s       string|number
---@param pattern string|number
---@param init?   integer
---@param plain?  boolean
---@return integer|nil start
---@return integer|nil end
---@return any|nil ... captured
---@nodiscard
function string.find(s, pattern, init, plain) end

---#DES 'string.format'
---@param s string|number
---@param ... any
---@return string
---@nodiscard
function string.format(s, ...) end

---#DES 'string.gmatch'
---#if VERSION <= 5.3 then
---@param s       string|number
---@param pattern string|number
---@return fun():string, ...
---@nodiscard
function string.gmatch(s, pattern) end
---#else
---@param s       string|number
---@param pattern string|number
---@param init?   integer
---@return fun():string, ...
function string.gmatch(s, pattern, init) end
---#end

---#DES 'string.gsub'
---@param s       string|number
---@param pattern string|number
---@param repl    string|number|table|function
---@param n?      integer
---@return string
---@return integer count
---@nodiscard
function string.gsub(s, pattern, repl, n) end

---#DES 'string.len'
---@param s string|number
---@return integer
---@nodiscard
function string.len(s) end

---#DES 'string.lower'
---@param s string|number
---@return string
---@nodiscard
function string.lower(s) end

---#DES 'string.match'
---@param s       string|number
---@param pattern string|number
---@param init?   integer
---@return any ...
---@nodiscard
function string.match(s, pattern, init) end

---@version >5.3
---#DES 'string.pack'
---@param fmt string
---@param v1  string|number
---@param v2? string|number
---@param ... string|number
---@return string binary
---@nodiscard
function string.pack(fmt, v1, v2, ...) end

---@version >5.3
---#DES 'string.packsize'
---@param fmt string
---@return integer
---@nodiscard
function string.packsize(fmt) end

---#if VERSION <= 5.1 and not JIT then
---#DES 'string.rep<5.1'
---@param s    string|number
---@param n    integer
---@return string
---@nodiscard
function string.rep(s, n) end
---#else
---#DES 'string.rep>5.2'
---@param s    string|number
---@param n    integer
---@param sep? string|number
---@return string
---@nodiscard
function string.rep(s, n, sep) end
---#end

---#DES 'string.reverse'
---@param s string|number
---@return string
---@nodiscard
function string.reverse(s) end

---#DES 'string.sub'
---@param s  string|number
---@param i  integer
---@param j? integer
---@return string
---@nodiscard
function string.sub(s, i, j) end

---@version >5.3
---#DES 'string.unpack'
---@param fmt  string
---@param s    string
---@param pos? integer
---@return any ...
---@return integer offset
---@nodiscard
function string.unpack(fmt, s, pos) end

---#DES 'string.upper'
---@param s string|number
---@return string
---@nodiscard
function string.upper(s) end

return string
