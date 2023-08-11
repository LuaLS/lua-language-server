TEST [[
<!aa!> = 1
tostring = 1
ROOT = 1
_G.bb = 1
]]

TEST [[
---@diagnostic disable-next-line
x = 1
]]

TEST [[
---@diagnostic disable-next-line: lowercase-global
x = 1
]]

TEST [[
---@diagnostic disable-next-line: unused-local
<!x!> = 1
]]

TEST [[
---@diagnostic disable
x = 1
]]

TEST [[
---@diagnostic disable
---@diagnostic enable
<!x!> = 1
]]

TEST [[
---@diagnostic disable
---@diagnostic disable
---@diagnostic enable
x = 1
]]
