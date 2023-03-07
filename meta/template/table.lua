---@meta table

---#DES 'table'
---@class tablelib
table = {}

---#DES 'table.concat'
---@param list table
---@param sep? string
---@param i?   integer
---@param j?   integer
---@return string
---@nodiscard
function table.concat(list, sep, i, j) end

---#DES 'table.insert'
---@overload fun(list: table, value: any)
---@param list table
---@param pos integer
---@param value any
function table.insert(list, pos, value) end

---@version <5.1
---#DES 'table.maxn'
---@param table table
---@return integer
---@nodiscard
function table.maxn(table) end

---@version >5.3
---#DES 'table.move'
---@param a1  table
---@param f   integer
---@param e   integer
---@param t   integer
---@param a2? table
---@return table a2
function table.move(a1, f, e, t, a2) end

---@version >5.2, JIT
---#DES 'table.pack'
---@return table
---@nodiscard
function table.pack(...) end

---#DES 'table.remove'
---@param list table
---@param pos? integer
---@return any
function table.remove(list, pos) end

---#DES 'table.sort'
---@generic T
---@param list T[]
---@param comp? fun(a: T, b: T):boolean
function table.sort(list, comp) end

---@version >5.2, JIT
---#DES 'table.unpack'
---@generic T
---@param list T[]
---@param i?   integer
---@param j?   integer
---@return T   ...
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
