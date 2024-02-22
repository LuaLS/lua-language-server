TEST [[
local x
x = <!x or 0 + 1!>
]]

TEST [[
local x, y
x = <!x + y or 0!>
]]

TEST [[
local x, y, z
x = x and y or '' .. z
]]

TEST [[
local x
x = x or -1
]]

TEST [[
local x
x = x or (0 + 1)
]]

TEST [[
local x, y
x = (x + y) or 0
]]
