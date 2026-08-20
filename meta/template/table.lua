---@meta table

---#DES 'table'
---@class tablelib
table = {}

---#DES 'table.concat'
---@param list any[]
---@param sep? string
---@param i?   integer
---@param j?   integer
---@return string
---@nodiscard
function table.concat(list, sep, i, j) end

---#DES 'table.insert'
---@generic T
---@overload fun(list: T[], value: T)
---@param list T[]
---@param pos integer
---@param value T
function table.insert(list, pos, value) end

---@version <5.1
---#DES 'table.maxn'
---@param table table
---@return integer
---@nodiscard
function table.maxn(table) end

---@version >5.3
---#DES 'table.move'
---@generic T: table
---@param a1  T
---@param f   integer
---@param e   integer
---@param t   integer
---@param a2? T
---@return T a2
function table.move(a1, f, e, t, a2) end

---@version >5.2, JIT
---#DES 'table.pack'
---@param ...T any
---@return T & { n: integer }
---@nodiscard
function table.pack(...) end

---#DES 'table.remove'
---@generic T
---@param list T[]
---@param pos? integer
---@return T
function table.remove(list, pos) end

---#DES 'table.sort'
---@generic T
---@param list T[]
---@param comp? fun(a: T, b: T):boolean
function table.sort(list, comp) end

---@version >5.2, JIT
---#DES 'table.unpack'
---@generic T: any[]
---@param list T
---@param i?   integer
---@param j?   integer
---@return ...T
---@nodiscard
function table.unpack(list, i, j) end

---@version <5.1, JIT
---#DES 'table.foreach'
---@generic T
---@param list any
---@param callback fun(key: string, value: any):T|nil
---@return T|nil
---@deprecated
function table.foreach(list, callback) end

---@version <5.1, JIT
---#DES 'table.foreachi'
---@generic T
---@param list any
---@param callback fun(key: string, value: any):T|nil
---@return T|nil
---@deprecated
function table.foreachi(list, callback) end

---@version <5.1, JIT
---#DES 'table.getn'
---@generic T
---@param list T[]
---@return integer
---@nodiscard
---@deprecated
function table.getn(list) end

return table
