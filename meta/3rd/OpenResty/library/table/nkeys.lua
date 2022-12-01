---@meta

--- Returns the total number of elements in a given Lua table (i.e. from both the
--- array and hash parts combined).
---
--- This API can be JIT compiled.
---
--- Usage:
---
--- ```lua
--- local nkeys = require "table.nkeys"
---
--- print(nkeys({}))  -- 0
--- print(nkeys({ "a", nil, "b" }))  -- 2
--- print(nkeys({ dog = 3, cat = 4, bird = nil }))  -- 2
--- print(nkeys({ "a", dog = 3, cat = 4 }))  -- 3
--- ```
---
---@param t table
---@return integer
local function nkeys(t) end

return nkeys
