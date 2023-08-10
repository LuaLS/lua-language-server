TEST [[
---@type string|boolean
local t

---@cast t string
]]

TEST [[
---@type string|boolean
local t

---@cast t <!number!>
]]
