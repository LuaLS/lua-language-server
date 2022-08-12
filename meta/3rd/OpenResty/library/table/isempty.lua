---@meta

--- Returns `true` when the given Lua table contains neither non-nil array elements nor non-nil key-value pairs, or `false` otherwise.
---
--- This API can be JIT compiled.
--- Usage:
---
--- ```lua
--- local isempty = require "table.isempty"
---
--- print(isempty({}))  -- true
--- print(isempty({nil, dog = nil}))  -- true
--- print(isempty({"a", "b"}))  -- false
--- print(isempty({nil, 3}))  -- false
--- print(isempty({cat = 3}))  -- false
--- ```
---
---@param t table
---@return boolean
local function isempty(t) end

return isempty
