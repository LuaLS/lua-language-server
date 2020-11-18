---@meta

---@class table*
table = {}

---@param list table
---@param sep? string
---@param i?   integer
---@param j?   integer
---@return string
function table.concat(list, sep, i, j) end

---@overload fun(list: table, value: any)
---@param list table
---@param pos integer
---@param value any
function table.insert(list, pos, value) end

---@param table table
---@return integer
function table.maxn(table) end

---@param a1  table
---@param f   integer
---@param e   integer
---@param t   integer
---@param a2? table
---@return table a2
function table.move(a1, f, e, t, a2) end

---@return table
function table.pack(...) end

---@param list table
---@param pos? integer
---@return any
function table.remove(list, pos) end

---@param list table
---@param comp fun(a: any, b: any):boolean
function table.sort(list, comp) end

---@param list table
---@param i?   integer
---@param j?   integer
function table.unpack(list, i, j) end

return table
