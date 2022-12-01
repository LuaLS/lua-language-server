---@meta

--- Returns `true` when the given Lua table is a pure array-like Lua table, or
--- `false` otherwise.
---
--- Empty Lua tables are treated as arrays.
---
--- This API can be JIT compiled.
---
--- Usage:
---
--- ```lua
--- local isarray = require "table.isarray"
---
--- print(isarray{"a", true, 3.14})  -- true
--- print(isarray{dog = 3})  -- false
--- print(isarray{})  -- true
--- ```
---@param t table
---@return boolean
local function isarray(t) end

return isarray
